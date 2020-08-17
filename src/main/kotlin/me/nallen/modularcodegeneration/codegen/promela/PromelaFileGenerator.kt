package me.nallen.modularcodegeneration.codegen.promela

import me.nallen.modularcodegeneration.codegen.Configuration
import me.nallen.modularcodegeneration.codegen.promela.Utils.generateCodeForParseTreeItem
import me.nallen.modularcodegeneration.hybridautomata.*
import me.nallen.modularcodegeneration.parsetree.Literal
import me.nallen.modularcodegeneration.parsetree.VariableType
import me.nallen.modularcodegeneration.logging.Logger

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
        return result.toString().trim()
    }

    fun generateProcesses(): String {

        val result = StringBuilder()
        // For each avaiable instance that maps to a automata create a process for that instance
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

                result.append("${config.getIndent(2)}::(${generateCodeForParseTreeItem(instanceName,guard,globalVariable = globalOutputInputVariables )})")
                // for each equation in the transition add it in
                for((variable, equation) in update) {
                    result.append(" ${instanceName}_${variable} = ${generateCodeForParseTreeItem(instanceName,equation, globalVariable = globalOutputInputVariables)};")
                }
                // Adds the transition location after all variables have been updated as well as increment local tick for that process
                result.append(" ${instanceName}_finished == 1; goto $toLocation;")
                    result.appendln()
            }

            result.appendln("${config.getIndent(2)}::else -> ${instanceName}_finished == 1; goto ${locationName};")
            result.appendln("${config.getIndent(2)}fi")
        }
        return result.toString()

    }

    // Checks if the variableName has a mapping defined in HAML
    fun checkVariableHasMapping(item: HybridItem, variableName: String, isGlobalVariable: Boolean ): Boolean {
        if(item is HybridNetwork){
            for(key in item.ioMapping.keys){
                if(key.automata.isBlank() && isGlobalVariable){
                    if(variableName == key.variable){
                        return true
                    }
                }
                else if("${key.automata}_${key.variable}" == variableName){
                    return true
                }
            }
        }
        return false
    }

    /**
     * Initialises all the variables that are needed at the start of the file
     */
    fun generateVariableInitialisation(item: HybridItem): String {
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
        // Finds all the global variables with NO MAPPINGS
        for(variable in item.variables){
            if(!checkVariableHasMapping(item,variable.name,true)){
                result.appendln("${Utils.generatePromelaType(variable.type)} ${variable.name} = ${getVariableInitialValue(variable)};")
                globalOutputInputVariables.add(variable.name)
            }
        }

        // Finds all the variables for processes with NO MAPPINGS
        for(instanceName in instanceToAutomataMap.keys){
            result.appendln()
            result.appendln("// $instanceName Variables without mappings")
            val automata = instanceToAutomataMap[instanceName]
            if( automata is HybridAutomata){
                for( variable in automata.variables){
                    // As these variables are instance specific we need to generate a new name for the variable with the instance attached to it
                    val variableName = instanceName + "_" + variable.name
                    // if the variable name is part of the output
                    if(!usedVariableNames.contains(variableName)){
                        if(!checkVariableHasMapping(item,variableName,false)){
                            result.appendln("${Utils.generatePromelaType(variable.type)} $variableName = ${getVariableInitialValue(variable)};")
                            usedVariableNames.add(variableName)
                        }
                    }
                }
            }
        }

        result.appendln()
        // Finds Variables for inputs and outputs of the whole system with mappings
        if(item is HybridNetwork){
            result.appendln("// Global Variables with mappings")
            for(key in item.ioMapping.keys){
                if(key.automata.isBlank()){
                    for(variable in item.variables){
                        if(variable.name == key.variable){
                            result.appendln("${Utils.generatePromelaType(variable.type)} ${variable.name} = ${item.ioMapping[key]?.let { generateCodeForParseTreeItem("", it) }};")
                            globalOutputInputVariables.add(variable.name)
                        }
                    }
                }
            }
        }

        // Finds all the variables for processes with NO MAPPINGS
        for(instanceName in instanceToAutomataMap.keys){
            result.appendln()
            result.appendln("// $instanceName Variables with mappings")
            val automata = instanceToAutomataMap[instanceName]
            if( automata is HybridAutomata){
                for( variable in automata.variables){
                    val variableName = instanceName + "_" + variable.name
                    // If the variable name hasnt been used before we can use it and continue
                    if(!globalOutputInputVariables.contains(variable.name) && !usedVariableNames.contains(variableName)){
                        // Checks the IO mappings in HAML to see if the variable with the instance exists as a mapped variable
                        if(item is HybridNetwork){
                            for(key in item.ioMapping.keys){
                                if("${key.automata}_${key.variable}" == variableName){
                                    result.appendln("${Utils.generatePromelaType(variable.type)} ${variableName} = ${item.ioMapping[key]?.let { generateCodeForParseTreeItem("", it) }};")
                                    usedVariableNames.add(variableName)
                                }
                            }
                        }

                    }
                }
            }
        }

        result.appendln()
        // Generates the input and output variables of the previous tick to be assigned to this variable
        for( variable in item.variables){
            val variableName = variable.name
            if(variable.locality.getTextualName() == "Outputs"){
                result.appendln("${Utils.generatePromelaType(variable.type)} pre_$variableName = ${getVariableInitialValue(variable)};")
                globalOutputInputVariables.add(variableName)
            }
        }

        result.appendln()
        // Adds the variables for the clock process so that it only can transition when process hasnt finished
        for(instanceName in instanceToAutomataMap.keys){
            result.appendln("bit ${instanceName}_finished = 0;")
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
            initValue = Utils.generateCodeForParseTreeItem("",(automata as HybridAutomata).init.valuations[variable.name] !!)
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
            VariableType.BOOLEAN -> Utils.generateCodeForParseTreeItem("",Literal("0"))
            VariableType.REAL -> Utils.generateCodeForParseTreeItem("",Literal("0"))
            VariableType.INTEGER -> Utils.generateCodeForParseTreeItem("",Literal("0"))
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
        // sets the mapped output variables to be outputting the correct values based on the HAML
        result.appendln(setMappedIOVariables())
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

    private fun setMappedIOVariables(): String {
        val result = StringBuilder()
        if(automata is HybridNetwork){
            for(key in (automata as HybridNetwork).ioMapping.keys){
                if(key.automata.isBlank()){
                    for(variable in automata.variables){
                        if(variable.name == key.variable){
                            result.appendln("${config.getIndent(3)}${variable.name} = ${(automata as HybridNetwork).ioMapping[key]?.let { generateCodeForParseTreeItem("", it) }};")
                        }
                    }
                }
            }
        }



        return result.toString().trim()


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
}
