import PackagePlugin


@main
struct ColorGenerator: BuildToolPlugin {

    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        // Uses the target that the plugin is being used by

        guard let target = target as? SourceModuleTarget else { return [] }

        // Find relevant input files for

            let jsonFiles = target.sourceFiles(withSuffix: "json")
        guard let semanticJsonPath = jsonFiles.first(where: { $0.path.string == "Semantic"})?.path,
              let paletteJsonPath = jsonFiles.first(where: { $0.path.string == "Palette"})?.path else {
                return []
            }

        var semanticJsonPathString = "\(semanticJsonPath)"
        var paletteJsonPathString = "\(paletteJsonPath)"
        let semanticJson = semanticJsonPathString.removeLast()
        let paletteJson = paletteJsonPathString.removeLast()

        let outPut = target.directory.appending(subpath: "Resources/GeneratedColors/TestGeneratedColorOutput")
        return [.buildCommand(displayName: "Generating color assets",
                              executable: .init("../Sources/ColorGeneratorExec"),
                              arguments: [semanticJson, paletteJson, outPut.string],
                              inputFiles: [semanticJsonPath, paletteJsonPath],
                              outputFiles: [])]
        
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

        let outputPath = Path("GLA/Resources/GeneratedColors")

        Diagnostics.remark("Semantic json path: \(semanticJsonPath)")
        Diagnostics.remark("Palette json path: \(paletteJsonPath)")
        Diagnostics.remark("Output path: \(outputPath)")

        return [.buildCommand(displayName: "Generating color assets",
                              executable: try context.tool(named: "ColorGeneratorExec").path,
                              arguments: [semanticJsonPath.string, paletteJsonPath.string, outputPath.string],
                              inputFiles: [semanticJsonPath, paletteJsonPath],
                              outputFiles: [outputPath])]
    }
}
#endif
