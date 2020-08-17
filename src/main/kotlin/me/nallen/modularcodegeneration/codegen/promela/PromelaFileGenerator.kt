package me.nallen.modularcodegeneration.codegen.promela

import me.nallen.modularcodegeneration.codegen.Configuration
import me.nallen.modularcodegeneration.codegen.c.CFileGenerator
import me.nallen.modularcodegeneration.hybridautomata.*
import me.nallen.modularcodegeneration.parsetree.Literal
import me.nallen.modularcodegeneration.parsetree.VariableType

object PromelaFileGenerator {
    private var instanceToAutomataMap: HashMap<String,HybridItem> = HashMap();
    private val globalOutputInputVariables = HashSet<String>();
    private val usedVariableNames = HashSet<String>();
    private var automata: HybridItem = HybridAutomata()
    private var config: Configuration = Configuration()

    fun generate(item: HybridItem): String {
        automata = item;
        val result = StringBuilder()
        // And return the total source file contents
        result.appendln(generateVariableInitialisation(item))
        result.appendln(generateTimerProcess())
        result.appendln(generateProcesses())
        val x = instanceToAutomataMap
        return result.toString().trim()
    }

    fun generateProcesses(): String {

        val result = StringBuilder()
        for (instanceName in instanceToAutomataMap.keys){
            val automataInstance = instanceToAutomataMap[instanceName]
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

        for(location in automataInstance.locations){
            result.appendln()
            val locationName = location.name
            result.appendln("${config.getIndent(1)}${locationName}:  ${instanceName}_finished == 0 ->")
            result.appendln("${config.getIndent(2)}if")
            for((_, toLocation, guard, update) in automataInstance.edges.filter{it.fromLocation == location.name }) {

                result.append("${config.getIndent(2)}::(${Utils.generateCodeForParseTreeItem(instanceName,guard,globalVariable = globalOutputInputVariables )})")
                for((variable, equation) in update) {
                    result.append(" ${variable}_${instanceName} = ${Utils.generateCodeForParseTreeItem(instanceName,equation, globalVariable = globalOutputInputVariables)};")
                }
                // Adds the transition location after all variables have been updated
                result.append(" ${instanceName}_finished == 1; goto $toLocation;")
                    result.appendln()
            }

            result.appendln("${config.getIndent(2)}::else -> ${instanceName}_finished == 1; goto ${locationName}")
            result.appendln("${config.getIndent(2)}fi")
        }
        return result.toString()

    }

    /**
     * Initialises all the variables that are needed at the start of the file
     */
    fun generateVariableInitialisation(item: HybridItem): String {
        val result = StringBuilder()
        // Variables for inputs and outputs of the whole system
        result.appendln("// Network Variables")
        for( variable in item.variables){
            val variableName = variable.name
            result.appendln("${Utils.generatePromelaType(variable.type)} $variableName = ${getVariableInitialValue(variable)};");
            globalOutputInputVariables.add(variableName)
        }
        result.appendln()

        for( variable in item.variables){
            val variableName = variable.name
            result.appendln("${Utils.generatePromelaType(variable.type)} pre_$variableName = ${getVariableInitialValue(variable)};");
            globalOutputInputVariables.add(variableName)
        }
        // If item is a hybrid network then we need to retrieve all the objects to make the processes for each
        if(item is HybridNetwork) {
            for (instanceName in item.getAllInstances().keys) {
                val automataDefinition = item.instances[instanceName]?.instantiate?.let { item.getDefinitionForInstantiateId(it) };
                if (automataDefinition is HybridNetwork) {
                    for (instanceName in automataDefinition.getAllInstances().keys) {
                        val automataDefinition = automataDefinition.instances[instanceName]?.instantiate?.let { item.getDefinitionForInstantiateId(it) };
                        if (automataDefinition != null) {
                            instanceToAutomataMap[instanceName] = automataDefinition
                        }
                    }
                }
                if (automataDefinition != null && automataDefinition is HybridAutomata) {
                    instanceToAutomataMap[instanceName] = automataDefinition
                }
            }
        }
        // If its just a automata then directly add it into the map so we can generate the process later
        if(item is HybridAutomata) {
            instanceToAutomataMap[item.name] = item
        }
        // Variables of each instantiation of the automata
        for(instanceName in instanceToAutomataMap.keys){
            result.appendln()
            result.appendln("// $instanceName Variables")
            val automata = instanceToAutomataMap[instanceName]
            if( automata is HybridAutomata){
                for( variable in automata.variables){
                    val variableName = variable.name + "_"+instanceName;
                    if(!globalOutputInputVariables.contains(variable.name) && !usedVariableNames.contains(variable.name)){
                        result.appendln("${Utils.generatePromelaType(variable.type)} $variableName = ${getVariableInitialValue(variable)};")
                    }
                }
            }
        }
        result.appendln()

        // Adds the variables for the clock process so that it only can transition when process hasnt finished
        for(instanceName in instanceToAutomataMap.keys){
            result.appendln("bit ${instanceName}_finished = 0;")
        }
        return result.toString().trim()
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
        return ""
    }
}
