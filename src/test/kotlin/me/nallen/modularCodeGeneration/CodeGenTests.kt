package me.nallen.modularCodeGeneration

import io.kotlintest.matchers.shouldBe
import io.kotlintest.specs.StringSpec
import me.nallen.modularCodeGeneration.codeGen.*
import me.nallen.modularCodeGeneration.description.Importer
import java.io.File
import java.io.IOException
import java.util.concurrent.TimeUnit

class CodeGenTests : StringSpec() {
    init {
        val canMake = "make".runCommand(File("build"), ProcessBuilder.Redirect.PIPE) != 127

        File("examples").list().forEach {
            val folder = File("examples", it)
            if(folder.isDirectory) {
                val main = File(folder, "main.yaml")

                if(main.exists() && main.isFile) {

                    ("Can Generate" + if(canMake) { " and Compile" } else { "" } + " Code For  $it") {
                        val imported = Importer.import(main.absolutePath)

                        val network = imported.first
                        var config = imported.second

                        config = config.copy(parametrisationMethod = ParametrisationMethod.COMPILE_TIME)
                        CodeGenManager.generateForNetwork(network, CodeGenLanguage.C, "build/tmp/codegen", config)
                        if(canMake) {
                            "make".runCommand(File("build/tmp/codegen")) shouldBe 0
                        }

                        config = config.copy(indentSize = -1, parametrisationMethod = ParametrisationMethod.RUN_TIME, logging = Logging())
                        CodeGenManager.generateForNetwork(network, CodeGenLanguage.C, "build/tmp/codegen", config)
                        if(canMake) {
                            "make".runCommand(File("build/tmp/codegen")) shouldBe 0
                        }

                        config = config.copy(maximumInterTransitions = 4, requireOneIntraTransitionPerTick = true)
                        CodeGenManager.generateForNetwork(network, CodeGenLanguage.C, "build/tmp/codegen", config)
                        if(canMake) {
                            "make".runCommand(File("build/tmp/codegen")) shouldBe 0
                        }

                        config = config.copy(maximumInterTransitions = 4, requireOneIntraTransitionPerTick = false)
                        CodeGenManager.generateForNetwork(network, CodeGenLanguage.C, "build/tmp/codegen", config)
                        if(canMake) {
                            "make".runCommand(File("build/tmp/codegen")) shouldBe 0
                        }
                    }

                    if(!canMake) {
                        "Can Compile Code For $it" {

                        }.config(enabled = false)
                    }
                }
            }
        }
    }

    private fun String.runCommand(workingDir: File, redirect: ProcessBuilder.Redirect = ProcessBuilder.Redirect.INHERIT): Int {
        return try {
            val parts = this.split("\\s".toRegex())
            val proc = ProcessBuilder(*parts.toTypedArray())
                    .directory(workingDir)
                    .redirectOutput(redirect)
                    .redirectError(redirect)
                    .start()

            proc.waitFor(60, TimeUnit.MINUTES)
            proc.exitValue()
        }
        catch(ex: IOException) {
            127
        }
    }

}