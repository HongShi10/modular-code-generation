package me.nallen.modularCodeGeneration

import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.SerializationFeature
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import me.nallen.modularCodeGeneration.finiteStateMachine.FiniteStateMachine
import me.nallen.modularCodeGeneration.hybridAutomata.*
import me.nallen.modularCodeGeneration.parseTree.*

/**
 * Created by nall426 on 31/05/2017.
 */

fun main(args: Array<String>) {
    val mapper: ObjectMapper = jacksonObjectMapper().configure(SerializationFeature.INDENT_OUTPUT, false)

    val ha = HybridAutomata("Cell")
            .addLocation(
                    "q0",
                    ParseTreeItem.generate("v < 44.5 && g < 44.5"),
                    hashMapOf(
                            "v_x" to ParseTreeItem.generate("C1 * v_x"),
                            "v_y" to ParseTreeItem.generate("C2 * v_y"),
                            "v_z" to ParseTreeItem.generate("C3 * v_z")
                    ),
                    hashMapOf(
                            "v" to ParseTreeItem.generate("v_x - v_y + v_z")
                    )
            )
            .addLocation(
                    "q1",
                    ParseTreeItem.generate("v < 44.5 && g > 0"),
                    hashMapOf(
                            "v_x" to ParseTreeItem.generate("C4 * v_x + C7 * g"),
                            "v_y" to ParseTreeItem.generate("C5 * v_y + C8 * g"),
                            "v_z" to ParseTreeItem.generate("C6 * v_z + C9 * g")
                    ),
                    hashMapOf(
                            "v" to ParseTreeItem.generate("v_x - v_y + v_z")
                    )
            )
            .addLocation(
                    "q2",
                    ParseTreeItem.generate("v < 131.1 - 80.1 * sqrt(theta)"),
                    hashMapOf(
                            "v_x" to ParseTreeItem.generate("C10 * v_x"),
                            "v_y" to ParseTreeItem.generate("C11 * v_y"),
                            "v_z" to ParseTreeItem.generate("C12 * v_z")
                    ),
                    hashMapOf(
                            "v" to ParseTreeItem.generate("v_x - v_y + v_z")
                    )
            )
            .addLocation(
                    "q3",
                    ParseTreeItem.generate("v > 30"),
                    hashMapOf(
                            "v_x" to ParseTreeItem.generate("C13 * v_x * f_theta"),
                            "v_y" to ParseTreeItem.generate("C14 * v_y * f_theta"),
                            "v_z" to ParseTreeItem.generate("C15 * v_z")
                    ),
                    hashMapOf(
                            "v" to ParseTreeItem.generate("v_x - v_y + v_z")
                    )
            )
            .addEdge(
                    "q0","q1",
                    ParseTreeItem.generate("g >= 44.5"),
                    hashMapOf(
                            "v_x" to ParseTreeItem.generate("0.3 * v"),
                            "v_y" to ParseTreeItem.generate("0.0 * v"),
                            "v_z" to ParseTreeItem.generate("0.7 * v"),
                            "theta" to ParseTreeItem.generate("v / 44.5"),
                            "f_theta" to ParseTreeItem.generate("0.3 * v")
                    )
            )
            .addEdge("q1","q0", ParseTreeItem.generate("g <= 0 && v < 44.5"))
            .addEdge("q1","q2", ParseTreeItem.generate("v > 44.5"))
            .addEdge("q2","q3", ParseTreeItem.generate("v >= 131.1 - 80.1 * sqrt(theta)"))
            .addEdge("q3","q0", ParseTreeItem.generate("v <= 30"))
            .setInit(Initialisation(
                    "q0",
                    hashMapOf(
                            "v_x" to ParseTreeItem.generate("0"),
                            "v_y" to ParseTreeItem.generate("0"),
                            "v_z" to ParseTreeItem.generate("0"),
                            "theta" to ParseTreeItem.generate("0")
                    )
            ))

    println(ha)
    print(mapper.writeValueAsString(ha))

    val fsm = FiniteStateMachine.generateFromHybridAutomata(ha)
    println(fsm)
    print(mapper.writeValueAsString(fsm))
}