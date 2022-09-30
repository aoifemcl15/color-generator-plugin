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

        let paletteFilePath = arguments[1]
        let semanticsFilePath = arguments[2]
        let outputPath = arguments[3]

        // Input
        let paletteFile = try File(path: paletteFilePath)
        NSLog("Palette file path \(paletteFile)")
        let palette = try Palette(from: paletteFile)
        let semanticColorsFile = try File(path: semanticsFilePath)

        let paletteChecksum = try paletteFile.read().checksum()
        let semanticChecksum = try semanticColorsFile.read().checksum()

        // Output
        let outputFolder = try Folder(path: outputPath)

        let semanticColorsDecoder = JSONDecoder()
        semanticColorsDecoder.userInfo[.palette] = palette

        print("Trying to decode the semantic colours")
        let colorGroups = try semanticColorsDecoder.decode([ColorGroup].self, from: try semanticColorsFile.read())

        if let existingPaletteChecksum = try? outputFolder.file(named: "palette.checksum").readAsString(),
            let existingSemanticChecksum = try? outputFolder.file(named: "semantic.checksum").readAsString(),
            paletteChecksum == existingPaletteChecksum,
            semanticChecksum == existingSemanticChecksum {
            print("colours have not changed... skipping generation")
            return
        }

        print("generating colours...")
        try outputFolder.empty()

        let swiftReferences = SwiftReferencesGenerator.generate(for: colorGroups)
        try outputFolder.createFile(named: "Colors.swift", contents: swiftReferences.data(using: .utf8)!)

        try AssetCatalogueGenerator.generate(for: colorGroups, outputFolder: outputFolder)

        // generate checksum files
        let paletteChecksumFile = try outputFolder.createFile(named: "palette.checksum")
        let semanticChecksumFile = try outputFolder.createFile(named: "semantic.checksum")
        try paletteChecksumFile.write(paletteChecksum)
        try semanticChecksumFile.write(semanticChecksum)
    }
}

extension CodingUserInfoKey {
    static let palette = CodingUserInfoKey(rawValue: "palette")!
}
