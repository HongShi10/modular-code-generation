package me.nallen.modularcodegeneration.codegen.promela

import me.nallen.modularcodegeneration.description.Importer

fun main() {
//    val imported = Importer.import("RSA.yaml");
//    val imported = Importer.import("examples/thermostat/main.yaml");
//    val imported = Importer.import("examples/nn/neural_network.yaml");
    val imported = Importer.import("examples/cardiac_grid/main.yaml");

    val network = imported.first
    val codeGenConfig = imported.second
    val promelaCodeGen = PromelaCodeGenerator.generate(network,codeGenConfig,"output");

}