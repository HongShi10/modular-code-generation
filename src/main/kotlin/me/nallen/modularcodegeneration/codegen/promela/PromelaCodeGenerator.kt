package me.nallen.modularcodegeneration.codegen.promela

import me.nallen.modularcodegeneration.codegen.Configuration
import me.nallen.modularcodegeneration.hybridautomata.HybridItem
import me.nallen.modularcodegeneration.logging.Logger
import me.nallen.modularcodegeneration.utils.getRelativePath
import java.io.File

class PromelaCodeGenerator {
    companion object {

        fun generate(item: HybridItem, codeGenConfig : Configuration, dir: String) {
            val outputDir = File(dir)

            // If the directory doesn't already exist, we want to create it
            if (!outputDir.exists())
                outputDir.mkdirs()

            Logger.info("Generating Promela Code to \"${outputDir.getRelativePath()}\"")

            // Use default parameters for top-level item
            item.setDefaultParametrisation()
            var multiplier = 1;
//            System.out.println(PromelaFileGenerator.generate(item))
            File(outputDir, "${Utils.createFileName(item.name)}.pml").writeText(PromelaFileGenerator.generate(item,codeGenConfig,multiplier))
        }


    }

}