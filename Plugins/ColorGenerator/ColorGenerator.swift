import PackagePlugin

@main
struct ColorGenerator: BuildToolPlugin {

    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        // Uses the target that the plugin is being used by

        guard let target = target as? SourceModuleTarget else { return [] }

        // Find relevant input files for

            let jsonFiles = target.sourceFiles(withSuffix: "json")
            guard let semanticJson = jsonFiles.first(where: { $0.path.string == "Semantic"})?.path,
                  let paletteJson = jsonFiles.first(where: { $0.path.string == "Palette"})?.path else {
                return []
            }

        let outPut = target.directory.appending(["TestGeneratedColorOutput"])
        return [.buildCommand(displayName: "Generating color assets",
                              executable: try context.tool(named: "ColorGeneratorExec").path,
                              arguments: [semanticJson.string, paletteJson.string, outPut.string],
                              inputFiles: [semanticJson, paletteJson],
                              outputFiles: [outPut])]
    }

}
