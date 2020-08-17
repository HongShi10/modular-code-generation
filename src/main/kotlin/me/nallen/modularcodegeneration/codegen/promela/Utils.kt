package me.nallen.modularcodegeneration.codegen.promela

import me.nallen.modularcodegeneration.codegen.Configuration
import me.nallen.modularcodegeneration.codegen.c.Utils
import me.nallen.modularcodegeneration.parsetree.*
import me.nallen.modularcodegeneration.utils.NamingConvention
import me.nallen.modularcodegeneration.utils.convertWordDelimiterConvention

typealias ParseTreeLocality = me.nallen.modularcodegeneration.parsetree.Locality

/**
 * A set of utilities for C Code generation regarding types, ParseTree generation, and naming conventions
 */
object Utils {
    /**
     * Convert our VariableType to a Promela type
     */
    fun generatePromelaType(type: VariableType?): String {
        // Switch on the type, and return the appropriate C type
        return when (type) {
            null -> "void"
            VariableType.BOOLEAN -> "bit"
            VariableType.REAL -> "double"
            VariableType.INTEGER -> "int"
            else -> throw NotImplementedError("Unable to generate code for requested type '$type'")
        }
    }

    fun createFileName(vararg original: String): String {
        // File Names use snake_case
        return original.convertWordDelimiterConvention(NamingConvention.SNAKE_CASE)
    }

    fun generateCodeForParseTreeItem(instanceName: String, item: ParseTreeItem, parent: ParseTreeItem? = null, globalVariable: HashSet<String>? = null): String {
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
                // Functions have a lot of extra logic we need to do
                // Firstly we should check if it's a delayed function call, which will have special handling

                // Otherwise, let's build a function
                val builder = StringBuilder()


                // Now add each argument to the function
                for (argument in item.arguments) {
                    // If needed, deliminate by a comma
                    if (builder.isNotEmpty()) builder.append(", ")
                    builder.append(generateCodeForParseTreeItem(instanceName,argument, globalVariable = globalVariable))
                }

                // And then return the final function name
                return "${(item.functionName)}($builder)"
            }
            is Literal -> item.value
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
                        finishedVar = part
                        if(globalVariable != null) {
                            if (globalVariable!!.contains(part)) {
                                finishedVar = "pre_$part"
                                return finishedVar;
                            }
                        }

                        // If needed, deliminate by a period
                        if (builder.isNotEmpty()) builder.append("_")

                        if(instanceName != "") {
                            builder.append("${instanceName}_${finishedVar}")
                        }
                        else{
                            builder.append("${finishedVar}")

                        }
                    }

                    // And return the final variable name
                    return builder.toString()
                }
            }
            is Constant -> when (item.name) {
                ConstantType.PI -> "M_PI"
            }
            is Plus -> padOperand(instanceName,item, item.operandA) + " + " + padOperand(instanceName,item, item.operandB)
            is Minus -> padOperand(instanceName,item, item.operandA) + " - " + padOperand(instanceName,item, item.operandB)
            is Negative -> "-" + padOperand(instanceName,item, item.operandA)
            is Power -> "pow(" + generateCodeForParseTreeItem(instanceName,item.operandA) + ", " + generateCodeForParseTreeItem(instanceName,item.operandB) + ")"
            is Multiply -> padOperand(instanceName,item, item.operandA) + " * " + padOperand(instanceName,item, item.operandB)
            is Divide -> padOperand(instanceName,item, item.operandA) + " / " + padOperand(instanceName,item, item.operandB)
            is SquareRoot -> "sqrt(" + generateCodeForParseTreeItem(instanceName,item.operandA) + ")"
            is Exponential -> "exp(" + generateCodeForParseTreeItem(instanceName,item.operandA) + ")"
            is Ln -> "log(" + generateCodeForParseTreeItem(instanceName,item.operandA) + ")"
            is Sine -> "sin(" + generateCodeForParseTreeItem(instanceName,item.operandA) + ")"
            is Cosine -> "cos(" + generateCodeForParseTreeItem(instanceName,item.operandA) + ")"
            is Tangent -> "tan(" + generateCodeForParseTreeItem(instanceName,item.operandA) + ")"
            is Floor -> "floor(" + generateCodeForParseTreeItem(instanceName,item.operandA) + ")"
            is Ceil -> "ceil(" + generateCodeForParseTreeItem(instanceName,item.operandA) + ")"
        }
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
            return "(" + generateCodeForParseTreeItem(instanceName,operand, globalVariable = globalVariable) + ")"

        // Special cases for C revolve around Or and And
        if (item is Or && operand is And)
            return "(" + generateCodeForParseTreeItem(instanceName,operand, globalVariable = globalVariable) + ")"

        // Otherwise no brackets
        return generateCodeForParseTreeItem(instanceName,operand, item, globalVariable = globalVariable)
    }
}
