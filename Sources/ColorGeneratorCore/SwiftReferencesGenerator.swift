//
//  SwiftReferencesGenerator.swift
//  ColorGenerator
//
//  Created by Sophie Lambrakis on 03/10/2019.
//

import Foundation

/* Generates Swift references for asset catalogue colours, of the format
     @objc extension ClassName {
         var colorName: UIColor { UIColor(named: "ClassName/colorName")! }
     }
*/

enum SwiftReferencesGenerator {

    private static func startFile() -> String {
        return """
        // This file is automatically generated. Please do not edit it manually.

        // swiftlint:disable color_named_reference
        
        enum Colors {

        """
    }

    private static func endFile() -> String {
        return """
        }

        // swiftlint:enable color_named_reference

        """
    }

    private static func startNamespace(_ namespace: String) -> String {
        return """

            enum \(namespace) {
        """
    }

    private static func endNamespace() -> String {
        return """

            }

        """
    }

    private static func declareColor(_ color: SemanticColor, in namespace: String) -> String {
        return """

                static let \(color.name) = UIColor(named: "\(namespace)/\(color.name)")!
        """
    }

    static func generate(for groups: [ColorGroup]) -> String {
        var str = startFile()
        for group in groups {
            str.append(startNamespace(group.namespace))
            for semanticColor in group.colors {
                str.append(declareColor(semanticColor, in: group.namespace))
            }
            str.append(endNamespace())
        }
        str.append(endFile())
        return str
    }
}
