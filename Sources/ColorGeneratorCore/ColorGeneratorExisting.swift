import Files
import Foundation
import CommonCrypto

extension Data {
    func checksum() -> String {
        var bytes = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(count), &bytes)
        }
        return bytes.reduce("") { $0 + String(format: "%02x", $1) }
    }
}

public final class ColorGeneratorExisting {

    public class func run(arguments: [String]) throws {

        let semanticsFilePath = arguments[1]
        let paletteFilePath = arguments[2]
        let outputPath = arguments[3]

        NSLog("Arguments \(arguments)")

        // Input
        let paletteFile = try File(path: paletteFilePath)
        NSLog("paletteFilePath \(paletteFilePath)")
        let palette = try Palette(from: paletteFile)
        NSLog("semanticsFilePath \(semanticsFilePath)")
        let semanticColorsFile = try File(path: semanticsFilePath)


        // Output

        let parentFolder = try Folder(path: outputPath)
        let outputFolder = try parentFolder.createSubfolder(at: "GeneratedColors")

        let semanticColorsDecoder = JSONDecoder()
        semanticColorsDecoder.userInfo[.palette] = palette

        NSLog("Trying to decode the semantic colours")
        let colorGroups = try semanticColorsDecoder.decode([ColorGroup].self, from: try semanticColorsFile.read())

        NSLog("generating colours...")
        try outputFolder.empty()

        let swiftReferences = SwiftReferencesGenerator.generate(for: colorGroups)
        try outputFolder.createFile(named: "Colors.swift", contents: swiftReferences.data(using: .utf8)!)

        try AssetCatalogueGenerator.generate(for: colorGroups, outputFolder: outputFolder)
    }


    // Output folder lives here inside the derived data of the package  "/Users/aoife_mclaughlin/Library/Developer/Xcode/DerivedData/GLA-fhzbpkxiizkbvlcdejzovtupaxsk/SourcePackages/plugins/GLA.output/GLA/ColorGeneratorPlugin/GeneratedColors/"



}

extension CodingUserInfoKey {
    static let palette = CodingUserInfoKey(rawValue: "palette")!
}
