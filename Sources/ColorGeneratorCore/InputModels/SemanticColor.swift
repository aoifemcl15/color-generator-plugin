//
//  SemanticColor.swift
//  ColorGenerator
//
//  Created by Sophie Lambrakis on 03/10/2019.
//

import Foundation

public struct PaletteColorReference: Decodable {
    let opacity: Float
    let red: UInt64
    let green: UInt64
    let blue: UInt64

    enum DecodingKeys: String, CodingKey {
        case paletteColor
        case opacity
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)

        let paletteColorName = try container.decode(String.self, forKey: .paletteColor)
        if paletteColorName == "clear" {
            (red, green, blue, opacity) = (0, 0, 0, 0)
        } else  {
            let palette = decoder.userInfo[.palette] as! Palette
            (red, green, blue) = try palette.rgb(for: paletteColorName)
            opacity = (try? container.decode(Float.self, forKey: .opacity)) ?? 1
        }
    }
}

public struct SemanticColor: Decodable {
    let name: String
    let universal: PaletteColorReference
    let dark: PaletteColorReference?
    let light: PaletteColorReference?

    enum DecodingKeys: String, CodingKey {
        case name, universal, dark, light
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        universal = try container.decode(PaletteColorReference.self, forKey: .universal)
        dark = try? container.decode(PaletteColorReference.self, forKey: .dark)
        light = try? container.decode(PaletteColorReference.self, forKey: .light)

        if light != nil && dark == nil {
            // If we have a light color, must also have a dark (or just use universal)
            throw DecodingError.keyNotFound(DecodingKeys.dark,
                                            DecodingError.Context(codingPath: decoder.codingPath,
                                                                  debugDescription: "If a light color is provided, a dark colour must also be provided"))
        }
    }
}
