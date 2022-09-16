//
//  SemanticColor+Encodable.swift
//  ColorGenerator
//
//  Created by Sophie Lambrakis on 07/10/2019.
//

import Foundation

extension UInt64 {
    func asHexString() -> String {
        return String(format: "0x%02X", self)
    }
}

extension PaletteColorReference: Encodable {
    enum EncodingKeys: String, CodingKey {
        case colorSpace = "color-space"
        case components
    }

    enum ComponentsKeys: String, CodingKey {
        case red
        case green
        case blue
        case alpha
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode("srgb", forKey: .colorSpace)

        var components = container.nestedContainer(keyedBy: ComponentsKeys.self, forKey: .components)
        try components.encode(red.asHexString(), forKey: .red)
        try components.encode(green.asHexString(), forKey: .green)
        try components.encode(blue.asHexString(), forKey: .blue)
        try components.encode("\(opacity)", forKey: .alpha) // Yes, really, Xcode expects a string
    }
}

extension SemanticColor: Encodable {
    enum EncodingKeys: String, CodingKey {
        case info
        case colors
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(AssetCatalogueInfo(), forKey: .info)

        var colors = [ColorAppearance]()
        colors.append(ColorAppearance(color: universal, appearance: nil))
        if let light = light {
            colors.append(ColorAppearance(color: light, appearance: Appearance(appearanceType: .light)))
        }
        if let dark = dark {
            colors.append(ColorAppearance(color: dark, appearance: Appearance(appearanceType: .dark)))
        }
        try container.encode(colors, forKey: .colors)
    }
}
