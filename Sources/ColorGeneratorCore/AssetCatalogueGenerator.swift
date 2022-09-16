//
//  AssetCatalogueGenerator.swift
//  ColorGenerator
//
//  Created by Sophie Lambrakis on 06/10/2019.
//

import Files
import Foundation

/* Creates folders/files of the structure:
 Colors.xcasset
    OnboardingViewController // 'namespace'
        Contents.json // empty apart from setting 'provides-namespace' to true
        highlightedTextColor.colorset
            Contents.json // contains srgb definitions for each theme (universal/dark/light)
 */

enum AssetCatalogueGenerator {

    static func generate(for groups: [ColorGroup], outputFolder: Folder) throws {
        let catalogue = try outputFolder.createSubfolder(at: "GeneratedColors.xcassets")

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        for group in groups {
            let namespaceFolder = try catalogue.createSubfolder(named: group.namespace)
            let namespaceCatalogueData = try encoder.encode(AssetCatalogue(providesNamespace: true))
            try namespaceFolder.createFile(named: "Contents.json", contents: namespaceCatalogueData)

            for color in group.colors {
                let colorFolder = try namespaceFolder.createSubfolder(named: "\(color.name).colorset")
                let colorCatalogueData = try encoder.encode(color)
                try colorFolder.createFile(named: "Contents.json", contents: colorCatalogueData)
            }
        }
    }
}
