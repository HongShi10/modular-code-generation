package me.nallen.modularcodegeneration.codegen.promela

import me.nallen.modularcodegeneration.codegen.Configuration
import me.nallen.modularcodegeneration.codegen.c.Utils
import me.nallen.modularcodegeneration.codegen.promela.PromelaFileGenerator.generateMappedVariable
import me.nallen.modularcodegeneration.parsetree.*
import me.nallen.modularcodegeneration.utils.NamingConvention
import me.nallen.modularcodegeneration.utils.convertWordDelimiterConvention

typealias ParseTreeLocality = me.nallen.modularcodegeneration.parsetree.Locality

/**
 * A set of utilities for C Code generation regarding types, ParseTree generation, and naming conventions
 */
object Utils {
    fun generateFixedPointValue(double: Double, multiplier: Int): Int {
        return (double * multiplier).toInt()

    }
    /**
     * Convert our VariableType to a Promela type
     */
    fun generatePromelaType(type: VariableType?): String {
        // Switch on the type, and return the appropriate C type
        return when (type) {
            null -> "void"
            VariableType.BOOLEAN -> "bool"
            VariableType.REAL -> "int"
            VariableType.INTEGER -> "int"
            else -> throw NotImplementedError("Unable to generate code for requested type '$type'")
        }
    }

    fun createFileName(vararg original: String): String {
        // File Names use snake_case
        return original.convertWordDelimiterConvention(NamingConvention.SNAKE_CASE)
    }

    fun generateCodeForParseTreeItem( item: ParseTreeItem,instanceName: String = "", parent: ParseTreeItem? = null, globalVariable: HashSet<String>? = null ): String {
        // For each possible ParseTreeItem we have a different output string that will be generated
        // We recursively call these generation functions until we reach the end of the tree
        return when (item) {
            is And -> padOperand(instanceName,item, item.operandA,globalVariable) + " && " + padOperand(instanceName,item, item.operandB,globalVariable)
            is Or -> padOperand(instanceName,item, item.operandA,globalVariable) + " || " + padOperand(instanceName,item, item.operandB,globalVariable)
            is Not -> padOperand(instanceName,item, item.operandA, globalVariable) + " == 0"
            is GreaterThan -> padOperand(instanceName,item, item.operandA, globalVariable) + " > " + padOperand(instanceName,item, item.operandB, globalVariable)
            is GreaterThanOrEqual -> padOperand(instanceName,item, item.operandA, globalVariable) + " >= " + padOperand(instanceName,item, item.operandB,globalVariable )
            is LessThanOrEqual -> padOperand(instanceName,item, item.operandA, globalVariable) + " <= " + padOperand(instanceName,item, item.operandB,globalVariable)
            is LessThan -> padOperand(instanceName,item, item.operandA, globalVariable) + " < " + padOperand(instanceName,item, item.operandB,globalVariable)
            is Equal -> padOperand(instanceName,item, item.operandA, globalVariable) + " == " + padOperand(instanceName,item, item.operandB,globalVariable)
            is NotEqual -> padOperand(instanceName,item, item.operandA, globalVariable) + " != " + padOperand(instanceName,item, item.operandB,globalVariable)
            is FunctionCall -> {

                // Otherwise, let's build a function
                val builder = StringBuilder()


                // Now add each argument to the function
                for (argument in item.arguments) {
                    // If needed, deliminate by a comma
                    if (builder.isNotEmpty()) builder.append(", ")
                    builder.append(generateCodeForParseTreeItem(argument,instanceName, globalVariable = globalVariable))
                }

                // And then return the final function name
                return "${(item.functionName)}($builder)"
            }
            is Literal ->  {
                return if(item.value.equals("true") || item.value.equals("false")){
                    item.value
                } else{
                    (item.value.toBigDecimal() * PromelaFileGenerator.multiplier.toBigDecimal()).toInt().toString()
                }
            }

            is Variable -> {
                // Variables also have a bit of extra logic that's needed

                // If the variable has a value assigned to it
                if (item.value != null)
                // Then we want to just replace this with the string representing the value
                    return padOperand(instanceName,parent ?: item, item.value!!, globalVariable)
                else {
                    // Otherwise we want to generate this variable
                    // It may consist of data inside structs, separated by periods
                    val parts = item.name.split(".")
                    val builder = StringBuilder()
                    var finishedVar = "";
                    // For each part
                    for (part in parts) {
                        if (builder.isNotEmpty()) builder.append("_")
                        builder.append(part)
                    }
                    var instanceNameVariable = builder.toString()
                    if(instanceName != ""){
                        instanceNameVariable = "${instanceName}_${builder}"
                    }
                    if(globalVariable != null) {
                        val isGloballyMapped = PromelaFileGenerator.getAutomataVariablePairForMappedGlobalVariables(instanceNameVariable)
                        val isLocallymapped = PromelaFileGenerator.checkVariableHasMapping(instanceNameVariable)
                        if (isGloballyMapped != null) {
                            if( isGloballyMapped.automata.isBlank()){
                                return "pre_${isGloballyMapped.variable}"
                            } else {
                                return "${isGloballyMapped.automata}_${isGloballyMapped.variable}"
                            }
                        }
                        else if(isLocallymapped != null){
                            return generateMappedVariable(isLocallymapped)
                        }
                        if (globalVariable!!.contains(builder.toString())) {
                            finishedVar = "pre_${builder}"
                            return finishedVar;
                        }
                    }
                    if(instanceName != ""){
                        return "${instanceName}_${builder}"
                    }                    // And return the final variable name
                    return builder.toString()
                }
            }
            is Constant -> when (item.name) {
                ConstantType.PI -> "M_PI"
            }
            is Plus -> padOperand(instanceName,item, item.operandA,globalVariable) + " + " + padOperand(instanceName,item, item.operandB,globalVariable)
            is Minus -> padOperand(instanceName,item, item.operandA,globalVariable) + " - " + padOperand(instanceName,item, item.operandB,globalVariable)
            is Negative -> "-" + padOperand(instanceName,item, item.operandA,globalVariable)
            is Power -> "pow(" + generateCodeForParseTreeItem(item.operandA,instanceName,globalVariable = globalVariable) + ", " + generateCodeForParseTreeItem(item.operandB,instanceName,globalVariable = globalVariable) + ")"
            is Multiply -> padOperand(instanceName,item, item.operandA,globalVariable) + " * " + padOperand(instanceName,item, item.operandB,globalVariable) + "/" + PromelaFileGenerator.multiplier
            is Divide -> padOperand(instanceName,item, item.operandA,globalVariable) + " / " + padOperand(instanceName,item, item.operandB,globalVariable) + "*" + PromelaFileGenerator.multiplier
            is SquareRoot -> "sqrt(" + generateCodeForParseTreeItem(item.operandA,instanceName,globalVariable = globalVariable) + ")"
            is Exponential -> "exp(" + generateCodeForParseTreeItem(item.operandA,instanceName,globalVariable = globalVariable) + ")"
            is Ln -> "log(" + generateCodeForParseTreeItem(item.operandA,instanceName,globalVariable = globalVariable) + ")"
            is Sine -> "sin(" + generateCodeForParseTreeItem(item.operandA,instanceName,globalVariable = globalVariable) + ")"
            is Cosine -> "cos(" + generateCodeForParseTreeItem(item.operandA,instanceName,globalVariable = globalVariable) + ")"
            is Tangent -> "tan(" + generateCodeForParseTreeItem(item.operandA,instanceName,globalVariable = globalVariable) + ")"
            is Floor -> "floor(" + generateCodeForParseTreeItem(item.operandA,instanceName,globalVariable = globalVariable) + ")"
            is Ceil -> "ceil(" + generateCodeForParseTreeItem(item.operandA,instanceName,globalVariable = globalVariable) + ")"
        }
    }

    fun generateCodeForProgram(program: Program, config: Configuration, depth: Int = 0, innerProgram: Boolean = false, usedVariableNames: HashSet<String>? = null, functionName: String = ""): String {
        val builder = StringBuilder()

        // First, we want to declare and initialise any internal variables that exist in this program, if it's not an inner program
        if(!innerProgram) {
            program.variables.filter {it.locality == ParseTreeLocality.INTERNAL}
                    .filterNot { usedVariableNames!!.contains(it.name) }
                    .forEach { builder.appendln("${config.getIndent(depth)}${generatePromelaType(it.type)} ${(it.name)};") }
            if(builder.isNotEmpty())
                builder.appendln()
        }

        // Now, we need to go through each line
        program.lines
                .map {
                    // And convert the ProgramLine into a string representation
                    // Note that some of these will recursively call this method, as they contain their own bodies
                    // (such as If statements)
                    when(it) {
                        is Statement -> "${generateCodeForParseTreeItem(it.logic)};"
                        is Break -> "break;"
                        is Assignment -> "${generateCodeForParseTreeItem(it.variableName)} = ${generateCodeForParseTreeItem(it.variableValue)};"
                        is Return -> "${functionName} = ${generateCodeForParseTreeItem(it.logic)};"
                        is IfStatement -> "if \n::(${generateCodeForParseTreeItem(it.condition)}) -> \n${generateCodeForProgram(it.body, config, 1,  true,usedVariableNames,functionName)} "
                        is ElseIfStatement -> "::(${generateCodeForParseTreeItem(it.condition)}) -> \n${generateCodeForProgram(it.body, config, 1, true,usedVariableNames,functionName)}"
                        is ElseStatement -> "::else -> \n${generateCodeForProgram(it.body, config, 1,true,usedVariableNames,functionName)}\nfi"
                        is ForStatement -> {
                            var loopAnnotation = ""
                            if(config.ccodeSettings.hasLoopAnnotations) {
                                val loops = Math.abs(it.upperBound - it.lowerBound) + 1
                                loopAnnotation = "\n${config.getIndent(1)}${config.ccodeSettings.getLoopAnnotation(loops)}"
                            }

                            if(it.lowerBound <= it.upperBound) {
                                "for(" +
                                        "int ${generateCodeForParseTreeItem(it.variableName)} = ${it.lowerBound}; " +
                                        "${generateCodeForParseTreeItem(it.variableName)} <= ${it.upperBound}; " +
                                        "${generateCodeForParseTreeItem(it.variableName)}++" +
                                        ") {$loopAnnotation\n${generateCodeForProgram(it.body, config, 1, true,usedVariableNames,functionName)}\n}"
                            }
                            else {
                                "for(" +
                                        "int ${generateCodeForParseTreeItem(it.variableName)} = ${it.lowerBound}; " +
                                        "${generateCodeForParseTreeItem(it.variableName)} >= ${it.upperBound}; " +
                                        "${generateCodeForParseTreeItem(it.variableName)}--" +
                                        ") {$loopAnnotation\n${generateCodeForProgram(it.body, config, 1, true,usedVariableNames,functionName)}\n}"
                            }
                        }
                    }
                }
                .forEach { builder.appendln(it.prependIndent(config.getIndent(depth))) }

        // And return the total program
        return builder.toString().trimEnd()
    }


    /**
     * Looks at a provided ParseTreeItem and its child and generates a C representation of the formula
     * If required, this method will add brackets around any operations that require them
     */
    private fun padOperand(instanceName: String,item: ParseTreeItem, operand: ParseTreeItem, globalVariable: HashSet<String>? = null): String {
        // We need to look at the precedence of both this operator and the child to decide whether brackets are needed
        var precedence = item.getPrecedence()

        // An interesting case happens when one of the operators is not commutative and the child has 2 or more arguments
        // In this case we try to be safe by including brackets if they previously had the same precedence
        if ((!operand.getCommutative() || !item.getCommutative()) && operand.getChildren().size > 1) {
            precedence--
        }

        // If the current operation's precedence is more than the childs, then we want brackets
        if (precedence < operand.getPrecedence())
            return "(" + generateCodeForParseTreeItem(operand, instanceName,globalVariable = globalVariable) + ")"

        // Special cases for C revolve around Or and And
        if (item is Or && operand is And)
            return "(" + generateCodeForParseTreeItem(operand,instanceName, globalVariable = globalVariable) + ")"

        // Otherwise no brackets
        return generateCodeForParseTreeItem(operand,instanceName,item, globalVariable = globalVariable)
    }
}
