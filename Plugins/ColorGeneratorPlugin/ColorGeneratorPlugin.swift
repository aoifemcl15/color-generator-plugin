import PackagePlugin

@main
struct ColorGenerator: BuildToolPlugin {

    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        // Uses the target that the plugin is being used by

        guard let target = target as? SourceModuleTarget else { return [] }

        let resourceFiles = target.sourceFiles.filter { $0.type == .resource }
        guard let semanticJsonPath = resourceFiles.first(where: { $0.path.lastComponent == "Semantic.json" })?.path,
              let paletteJsonPath = resourceFiles.first(where: { $0.path.lastComponent == "Palette.json" })?.path
        else {
            return []
        }

        let outputPath = context.pluginWorkDirectory

        Diagnostics.remark("Semantic json path: \(semanticJsonPath)")
        Diagnostics.remark("Palette json path: \(paletteJsonPath)")
        Diagnostics.remark("Package output path: \(outputPath)")

        let colorsOutput = outputPath.appending(subpath: "GeneratedColors/Colors.swift") // it's important to specify the file here so that it can be accessed within the target!

        return [.buildCommand(displayName: "Generating color assets",
                              executable: try context.tool(named: "ColorGeneratorExec").path,
                              arguments: [semanticJsonPath.string, paletteJsonPath.string, outputPath.string],
                              inputFiles: [semanticJsonPath, paletteJsonPath],
                              // output files should include any code you want to reference within the main target 
                              outputFiles: [colorsOutput])]
        
    }

}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension ColorGenerator: XcodeBuildToolPlugin {

    // This implementation is required function to enable functionality to work with Xcode project
    func createBuildCommands(context: XcodeProjectPlugin.XcodePluginContext, target: XcodeProjectPlugin.XcodeTarget) throws -> [PackagePlugin.Command] {

        let resourceFiles = target.inputFiles.filter { $0.type == .resource }
        guard let semanticJsonPath = resourceFiles.first(where: { $0.path.lastComponent == "Semantic.json" })?.path,
              let paletteJsonPath = resourceFiles.first(where: { $0.path.lastComponent == "Palette.json" })?.path
        else {
            return []
        }

        let outputFolder = context.pluginWorkDirectory

        Diagnostics.remark("Semantic json path: \(semanticJsonPath)")
        Diagnostics.remark("Palette json path: \(paletteJsonPath)")

        let colorsOutput = outputFolder.appending(subpath: "GeneratedColors/Colors.swift") // it's important to specify the file here so that it can be accessed within the target!

        Diagnostics.remark("Package output path: \(colorsOutput)")

        return [.buildCommand(displayName: "Generating color assets",
                              executable: try context.tool(named: "ColorGeneratorExec").path,
                              arguments: [semanticJsonPath.string, paletteJsonPath.string, outputFolder.string],
                              inputFiles: [semanticJsonPath, paletteJsonPath],
                              outputFiles: [colorsOutput])]
    }
}
#endif
