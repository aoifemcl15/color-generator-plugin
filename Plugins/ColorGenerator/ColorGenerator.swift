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

        print("Semantic JSON \(semanticJson)")
        print("Palette JSON \(paletteJson)")

        let outPut = target.directory.appending(["TestGeneratedColorOutput"])
        return [.buildCommand(displayName: "Generating color assets",
                              executable: try context.tool(named: "ColorGeneratorExec").path,
                              arguments: [semanticJson.string, paletteJson.string, outPut.string],
                              inputFiles: [semanticJson, paletteJson],
                              outputFiles: [outPut])]
    }

}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension ColorGenerator: XcodeBuildToolPlugin {

    // This implementation is required function to enable functionality to work with Xcode project
    func createBuildCommands(context: XcodeProjectPlugin.XcodePluginContext, target: XcodeProjectPlugin.XcodeTarget) throws -> [PackagePlugin.Command] {

        let resourceFiles = target.inputFiles.filter { $0.type == .resource }
        guard let semanticJsonPath = resourceFiles.first(where: { $0.path.lastComponent == "Semantic.json" })?.path,
              let paletteJsonPath = resourceFiles.first(where: { $0.path.lastComponent == "Palette.json" })?.path else {
            return []
        }

        // TODO: Improve selection of files - maybe check folder they belong to?

        print("Semantic json path: \(semanticJsonPath)")
        print("Palette json path: \(paletteJsonPath)")

        let outputPath = semanticJsonPath.appending(["GeneratedFile"])

        // TODO: figure out how to add files to the target
        //        let outPut = target.appending(["TestGeneratedColorOutput"])
        return [.buildCommand(displayName: "Generating color assets",
                              executable: try context.tool(named: "ColorGeneratorExec").path,
                              arguments: [semanticJsonPath.string, paletteJsonPath.string],
                              inputFiles: [semanticJsonPath, paletteJsonPath],
                              outputFiles: [outputPath])]
    }
}
#endif
