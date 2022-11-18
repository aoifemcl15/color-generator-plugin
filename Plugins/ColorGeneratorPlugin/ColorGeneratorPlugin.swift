import PackagePlugin

@main
struct ColorGenerator: BuildToolPlugin {

    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        // Uses the target that the plugin is being used by
        Diagnostics.remark("Color Generator starting on swift package")

        guard let target = target as? SourceModuleTarget else { return [] }
        Diagnostics.remark("Color generator applying to target: \(target)")

        // 1. Find the input files needed to pass through to the executable
        let resourceFiles = target.sourceFiles.filter { $0.type == .resource }
        guard let semanticJsonPath = resourceFiles.first(where: { $0.path.lastComponent == "Semantic.json" })?.path,
              let paletteJsonPath = resourceFiles.first(where: { $0.path.lastComponent == "Palette.json" })?.path
        else {
            Diagnostics.remark("Unable to find required input files, make sure both the Palette.json and Semantic.json exist in the target")
            return []
        }

        let outputPath = context.pluginWorkDirectory

        Diagnostics.remark("Semantic json path: \(semanticJsonPath)")
        Diagnostics.remark("Palette json path: \(paletteJsonPath)")
        Diagnostics.remark("Package output path: \(outputPath)")

        // 2. Create a reference to a file which will contain the colour output 
        let colorsOutput = outputPath.appending(subpath: "GeneratedColors/Colors.swift") // it's important to specify the file here so that it can be accessed within the target!
        let assetsOutput = outputPath.appending(subpath: "GeneratedColors/GeneratedColors.xcassets")

        return [.buildCommand(displayName: "Generating color assets",
                              executable: try context.tool(named: "ColorGeneratorExec").path,
                              arguments: [semanticJsonPath.string, paletteJsonPath.string, outputPath.string],
                              inputFiles: [semanticJsonPath, paletteJsonPath],
                              // output files should include any code you want to reference within the main target 
                              outputFiles: [colorsOutput, assetsOutput])]
        
    }

}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension ColorGenerator: XcodeBuildToolPlugin {

    // This implementation is required function to enable functionality to work with Xcode project
    func createBuildCommands(context: XcodeProjectPlugin.XcodePluginContext, target: XcodeProjectPlugin.XcodeTarget) throws -> [PackagePlugin.Command] {

        // 1. Find the input files to pass through to the executable
        let resourceFiles = target.inputFiles.filter { $0.type == .resource }
        guard let semanticJsonPath = resourceFiles.first(where: { $0.path.lastComponent == "Semantic.json" })?.path,
              let paletteJsonPath = resourceFiles.first(where: { $0.path.lastComponent == "Palette.json" })?.path
        else {
            Diagnostics.remark("Unable to find required input files, make sure both the Palette.json and Semantic.json belong to the target")
            return []
        }

        let outputFolder = context.pluginWorkDirectory

        Diagnostics.remark("Semantic json path: \(semanticJsonPath)")
        Diagnostics.remark("Palette json path: \(paletteJsonPath)")

        // 2. Create new reference for the Colors.swift output file
        let colorsOutput = outputFolder.appending(subpath: "GeneratedColors/Colors.swift") // it's important to specify the file here so that it can be accessed within the target!
        let assetsOutput = outputFolder.appending(subpath: "GeneratedColors/GeneratedColors.xcassets")

        Diagnostics.remark("Package output path: \(colorsOutput)")

        return [.buildCommand(displayName: "Generating color assets",
                              executable: try context.tool(named: "ColorGeneratorExec").path,
                              arguments: [semanticJsonPath.string, paletteJsonPath.string, outputFolder.string],
                              inputFiles: [semanticJsonPath, paletteJsonPath],
                              outputFiles: [colorsOutput, assetsOutput])]
    }
}
#endif
