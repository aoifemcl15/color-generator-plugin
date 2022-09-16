//
//  Appearance.swift
//  ColorGenerator
//
//  Created by Sophie Lambrakis on 07/10/2019.
//

import Foundation

public struct Appearance: Encodable {

    enum AppearanceType: String, Encodable {
        case light
        case dark
    }

    let appearanceType: AppearanceType

    enum EncodingKeys: String, CodingKey {
        case appearance
        case value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode("luminosity", forKey: .appearance)
        try container.encode(appearanceType, forKey: .value)
    }
}

public struct ColorAppearance: Encodable {
    let color: PaletteColorReference
    let appearance: Appearance?

    enum EncodingKeys: String, CodingKey {
        case idiom
        case appearances
        case color
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode("universal", forKey: .idiom)
        try container.encode(color, forKey: .color)

        if let appearance = appearance {
            try container.encode([appearance], forKey: .appearances)
        }
    }
}
