package me.nallen.modularcodegeneration.codegen.promela

import me.nallen.modularcodegeneration.codegen.Configuration
import me.nallen.modularcodegeneration.codegen.promela.Utils.generateCodeForParseTreeItem
import me.nallen.modularcodegeneration.codegen.promela.Utils.generateCodeForProgram
import me.nallen.modularcodegeneration.codegen.promela.Utils.generatePromelaType
import me.nallen.modularcodegeneration.hybridautomata.*
import me.nallen.modularcodegeneration.parsetree.Literal
import me.nallen.modularcodegeneration.parsetree.VariableType
import me.nallen.modularcodegeneration.logging.Logger
import me.nallen.modularcodegeneration.parsetree.FunctionCall
import sun.net.idn.StringPrep

object PromelaFileGenerator {
    private var instanceToAutomataMap: HashMap<String,HybridItem> = HashMap()
    private val globalOutputInputVariables = HashSet<String>()
    private val usedVariableNames = HashSet<String>()
    private var automata: HybridItem = HybridAutomata()
    private var config: Configuration = Configuration()

    fun generate(item: HybridItem): String {
        automata = item
        val result = StringBuilder()
        if(automata is HybridNetwork && !(automata as HybridNetwork).isFlat()) {
                // We need to flatten the network so we can generate efficient code
                // Let's warn the user first
                Logger.warn("PROMELA Run-time generation requires a \"flat\" network. Network has automatically been " +
                        "flattened.")
                // And then flatten the network
            automata = automata.flatten()
            }
        // Initialises all the variables
        result.appendln(generateVariableInitialisation(automata))
        // creates the timer process
        result.appendln(generateTimerProcess())
        // creates all other processes from the instantiation of automata
        result.appendln(generateProcesses())
        result.append(generateFunctionsForEachLocation())
        return result.toString().trim()
    }

    private fun generateProcesses(): String {

        val result = StringBuilder()
        // For each available instance that maps to a automata create a process for that instance
        for (instanceName in instanceToAutomataMap.keys){
            val automataInstance = instanceToAutomataMap[instanceName]
            // creates the process method header
            result.appendln("proctype ${instanceName}_model(){")

            if(automataInstance is HybridAutomata){
                result.appendln(findAllTransitionLocationEdges(automataInstance,instanceName))
            }
            result.appendln("}")
            result.appendln()
            result.appendln()

        }
        return result.toString().trim()
    }

    private fun findAllTransitionLocationEdges(automataInstance: HybridAutomata, instanceName: String): String {
        val result = StringBuilder()
        // Finds all transitions for the automata for each location
        for(location in automataInstance.locations){
            result.appendln()
            val locationName = location.name
            result.appendln("${config.getIndent(1)}${locationName}:  ${instanceName}_finished == 0 ->")
            result.appendln("${config.getIndent(2)}if")
            // finds the location of the transition with the update and guards
            for((_, toLocation, guard, update) in automataInstance.edges.filter{it.fromLocation == location.name }) {

                result.append("${config.getIndent(2)}::(${generateCodeForParseTreeItem(guard,instanceName,globalVariable = globalOutputInputVariables )}) ->")
                // for each equation in the transition add it in
                for((variable, equation) in update) {
                    if(equation.type == "functionCall"){
                        result.append(" atomic{" )
                        result.append(" run ${generateCodeForParseTreeItem(equation,instanceName, globalVariable = globalOutputInputVariables)};")
                        if(equation is FunctionCall){
                            val mapped = getAutomataVariablePairForMappedGlobalVariables(instanceName,variable)
                            if(mapped != null){
                                result.append(" ${mapped.variable} = ${instanceName}_${equation.functionName}_function_returnVar;")

                            }
                            else{
                                result.append(" ${instanceName}_${variable} =  ${instanceName}_${equation.functionName}_function_returnVar;")

                            }
                        }
                        result.append("}")
                        continue
                    }
                    val mapped = getAutomataVariablePairForMappedGlobalVariables(instanceName,variable)
                    if(mapped != null){
                        result.append(" ${mapped.variable} = ${generateCodeForParseTreeItem(equation,instanceName, globalVariable = globalOutputInputVariables)};")
                    }
                    else{
                        result.append(" ${instanceName}_${variable} = ${generateCodeForParseTreeItem(equation, instanceName,globalVariable = globalOutputInputVariables)};")

                    }
                }
                // Adds the transition location after all variables have been updated as well as increment local tick for that process
                result.append(" ${instanceName}_finished = 1; goto $toLocation;")
                    result.appendln()
            }

            result.appendln("${config.getIndent(2)}::else -> ${instanceName}_finished == 1; goto ${locationName};")
            result.appendln("${config.getIndent(2)}fi")
        }
        return result.toString()

    }
    // Checks if the current variable is a global variable and if it is then it checks if the variable has a mapping which maps it to this instance of the automata and returns the key
    private fun getAutomataVariablePairForMappedGlobalVariables(instanceName: String, variableName: String): AutomataVariablePair? {
        if(automata is HybridNetwork){
            for (mappedVariables in (automata as HybridNetwork).ioMapping){
                val key = mappedVariables.key
                val value = mappedVariables.value
                val name = generateCodeForParseTreeItem(value)
                val convertedName = instanceName + "_" + variableName
                if(key.automata.isBlank() && convertedName == name){
                    return key;

                }
            }
        }
        return null

    }

    // Checks if the variableName has a mapping defined in HAML
    private fun checkVariableHasMapping(item: HybridItem, variableName: String ): AutomataVariablePair? {
        if(item is HybridNetwork){
            for(key in item.ioMapping.keys){
                 if("${key.automata}_${key.variable}" == variableName){
                    return key
                }
            }
        }
        return null
    }

    /**
     * Initialises all the variables that are needed at the start of the file
     */
    private fun generateVariableInitialisation(item: HybridItem): String {
        val result = StringBuilder()

        // If item is a hybrid network then we need to retrieve all the objects to make the processes for each
        if(item is HybridNetwork) {
            for (instanceName in item.getAllInstances().keys) {
                val automataDefinition = item.instances[instanceName]?.instantiate?.let { item.getDefinitionForInstantiateId(it) };
                if (automataDefinition != null && automataDefinition is HybridAutomata) {
                    instanceToAutomataMap[instanceName] = automataDefinition
                }
            }
        }
        // If its just a automata then directly add it into the map so we can generate the process later
        if(item is HybridAutomata) {
            instanceToAutomataMap[item.name] = item
        }
        // Creates global variables
        result.appendln(generateGlobalVariables())
        // Finds all the variables for processes with NO MAPPINGS
        result.appendln(generateVariablesWithNoMappings(item))
        // Finds all the variables for processes WITH MAPPINGS
        result.appendln(generateVariablesWithMappings(item))
        // Creates variables for previous tick values to be assigned
        result.appendln(generateVariablesForPreviousClockTick(item))
        // Creates variables for local clock ticks
        result.appendln(generateVariablesForProcessLocalTick())
        result.appendln(generateVariablesForFunctions()
        )
        return result.toString()

    }
    private fun generateGlobalVariables(): String{
        val result = StringBuilder()
        result.appendln("// Global Variables ")
        for(variable in automata.variables){
                result.appendln("${generatePromelaType(variable.type)} ${variable.name} = ${getVariableInitialValue(variable)};");
                globalOutputInputVariables.add(variable.name)
                usedVariableNames.add(variable.name)
        }
        return result.toString()
    }
    private fun generateVariablesForPreviousClockTick(item: HybridItem): String{
        val result = StringBuilder()
        for( variable in item.variables){
            val variableName = variable.name
            if(variable.locality.getTextualName() == "Outputs"){
                result.appendln("${generatePromelaType(variable.type)} pre_$variableName = ${getVariableInitialValue(variable)};")
                globalOutputInputVariables.add(variableName)
                usedVariableNames.add(variableName)
            }
        }
        return result.toString()
    }
    private fun generateVariablesWithNoMappings(item: HybridItem): String{
        val result = StringBuilder()
        for(instanceName in instanceToAutomataMap.keys){
            result.appendln()
            result.appendln("// $instanceName Variables without mappings")
            val automata = instanceToAutomataMap[instanceName]
            if( automata is HybridAutomata){
                for( variable in automata.variables){
                    // As these variables are instance specific we need to generate a new name for the variable with the instance attached to it
                    val variableName = instanceName + "_" + variable.name
                // if the variable name is part of the output
                    if(checkVariableHasMapping(item,variableName) == null){
                        if(!usedVariableNames.contains(variableName) && !globalOutputInputVariables.contains(variableName)) {
                            result.appendln("${generatePromelaType(variable.type)} $variableName = ${getVariableInitialValue(variable)};")
                            usedVariableNames.add(variableName)
                        }
                        else{
                            Logger.error("PROMELA Run-time generation could not produce variables: DUPLICATE VARIABLES")
                        }
                    }
                }
            }
        }
        return result.toString()
    }
    private fun generateVariablesWithMappings(item:HybridItem) : String{
        val result = StringBuilder()
        for(instanceName in instanceToAutomataMap.keys){
            result.appendln()
            result.appendln("// $instanceName Variables with mappings")
            val automata = instanceToAutomataMap[instanceName]
            if( automata is HybridAutomata){
                for( variable in automata.variables){
                    val variableName = instanceName + "_" + variable.name
                    // If the variable name hasnt been used before we can use it and continue
                        // Checks the IO mappings in HAML to see if the variable with the instance exists as a mapped variable
                        val mapped = checkVariableHasMapping(item,variableName)
                        if(mapped  != null){
                            if(item is HybridNetwork) {
                                if(!globalOutputInputVariables.contains(variableName) && !usedVariableNames.contains(variableName)) {
                                    result.appendln("${generatePromelaType(variable.type)} $variableName = ${item.ioMapping[mapped]?.let { generateCodeForParseTreeItem( it) }};")
                                    usedVariableNames.add(variableName)
                                }
                                else{
                                    Logger.error("PROMELA Run-time generation could not produce variables: DUPLICATE VARIABLES")

                                }
                            }
                        }
                    }

                }
        }
        return result.toString()
    }
    private fun generateVariablesForProcessLocalTick() : String{
        val result = StringBuilder()
        for(instanceName in instanceToAutomataMap.keys){
            result.appendln("bit ${instanceName}_finished = 0;")
        }
        return result.toString()
    }
    private fun generateVariablesForFunctions() : String{
        val result = StringBuilder()
        for (instanceName in instanceToAutomataMap.keys){
            val automataInstance = instanceToAutomataMap[instanceName]
            // creates the process method header
            if(automataInstance is HybridAutomata && automataInstance.functions.isNotEmpty()){
                for(function in automataInstance.functions){
                    result.appendln("${ generatePromelaType(function.returnType)} ${instanceName}_${function.name}_function_returnVar = ${function.returnType?.let { generateDefaultInitForType(it) }};")
                }

            }

        }
        return result.toString()
    }

    /**
     * Generates the variables initial value if present
     */
    private fun getVariableInitialValue(variable: Variable): String {
        // Let's start with a default value for the initialisation
        var initValue: String = generateDefaultInitForType(variable.type)

        // But, if an initial value for the variable is provided then let's use that
        if(automata is HybridAutomata && (automata as HybridAutomata).init.valuations.containsKey(variable.name)) {
            // Generate code that represents the initial value for the variable
            initValue = generateCodeForParseTreeItem((automata as HybridAutomata).init.valuations[variable.name] !!)
        }

        // Now we can return the code that initialises the variable
        return initValue
    }
    /**
     * Generates the default value for given VariableType
     */
    private fun generateDefaultInitForType(type: VariableType): String {
        // A simple switch based on the type returns the default value for the types of variables
        return when(type) {
            VariableType.BOOLEAN -> generateCodeForParseTreeItem(Literal("0"))
            VariableType.REAL -> generateCodeForParseTreeItem(Literal("0"))
            VariableType.INTEGER -> generateCodeForParseTreeItem(Literal("0"))
            else -> throw NotImplementedError("Unable to generate code for requested type '$type'")
        }
    }

    private fun generateTimerProcess(): String {
        val result = StringBuilder()
        result.appendln()
        result.appendln("proctype clock_pro(){")
        result.appendln()
        // creates the line which checks that each local tick of a process has passed
        result.appendln("${config.getIndent(1)}INITIAL: (${getProcessFinishVariablesEqualOne()}) ->")
        result.appendln("${config.getIndent(2)}d_step{")
        // resets the local tick so every process is synchronised
        result.appendln(resetProcessFinishVariables())
        // Example assert statement printed in the file for user to change
        result.appendln("${config.getIndent(3)}// ADD ASSERT STATEMENT CHECK HERE")
        result.appendln("${config.getIndent(3)}//if")
        result.appendln("${config.getIndent(3)}//:: (pre_x < y) -> assert(false)")
        result.appendln("${config.getIndent(3)}//:: else -> skip")
        result.appendln("${config.getIndent(3)}//fi")
        // sets the pre_variable to the last tick values
        result.appendln(setPastTickVariablesAndResetCurrent())
        result.appendln("${config.getIndent(1)}}")
        result.appendln("}")
        return result.toString()
    }

    private fun getProcessFinishVariablesEqualOne(): String {
        val result = StringBuilder()
        for((count, instanceName) in instanceToAutomataMap.keys.withIndex()){
            if(count != 0){
                result.append( " && ")
            }
            result.append("${instanceName}_finished == 1");
        }
        return result.toString().trim()
    }

    private fun resetProcessFinishVariables(): String {
        val result = StringBuilder()
        result.append(config.getIndent(3))
        for(instanceName in instanceToAutomataMap.keys){
            result.append("${instanceName}_finished == 0; ")
        }
        return result.toString()
    }

    private fun setPastTickVariablesAndResetCurrent(): String {
        val result = StringBuilder()
        // Sets all the variables from the current tick to the pre_$variableName variable
        for(variable in automata.variables){
            if(variable.locality.getTextualName() == "Outputs"){
                result.appendln("${config.getIndent(3)}pre_${variable.name} = ${variable.name};");

            }
        }
        result.appendln()
        // resets the value of the output variable to the initial value
        for(variable in automata.variables){
            if(variable.locality.getTextualName() == "Outputs"){
                result.appendln("${config.getIndent(3)}${variable.name} = ${getVariableInitialValue(variable)};");
            }
        }
        return result.toString()
    }

    private fun generateFunctionsForEachLocation(): String {
        val result = StringBuilder()
        for (instanceName in instanceToAutomataMap.keys){
            val automataInstance = instanceToAutomataMap[instanceName]
            // creates the process method header
            if(automataInstance is HybridAutomata && automataInstance.functions.isNotEmpty()){
                for(function in automataInstance.functions){
                    val functionName = "${instanceName}_${function.name}"
                    result.append("$functionName(")
                    val numberOfInputs = function.inputs.size
                    var counter = 1
                    for(inputVar in function.inputs){
                        result.append("${generatePromelaType(inputVar.type)} ${inputVar.name}")
                        if(counter < numberOfInputs){
                            result.append(", ")
                        }
                        counter++
                    }
                    result.append("){")
                    result.appendln()
                    result.appendln(generateCodeForProgram(function.logic, config,1,false, usedVariableNames,"${functionName}_function_returnVar"))
                    result.appendln("}")

                }

            }

        }



        return result.toString().trimEnd()
    }
}
