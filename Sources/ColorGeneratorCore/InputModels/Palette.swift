//
//  Palette.swift
//  ColorGenerator
//
//  Created by Sophie Lambrakis on 03/10/2019.
//

import Files
import Foundation

struct PaletteColor: Decodable {
    let name: String
    let red: UInt64
    let green: UInt64
    let blue: UInt64

    enum CodingKeys: String, CodingKey {
        case name, hex
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)

        let hex = try container.decode(String.self, forKey: .hex)

        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0
        guard scanner.scanHexInt64(&hexNumber) else {
            throw DecodingError.dataCorruptedError(forKey: .hex, in: container, debugDescription: "Not a valid hexadecimal format")
        }

        red = (hexNumber & 0xff0000) >> 16
        green = (hexNumber & 0x00ff00) >> 8
        blue = hexNumber & 0x0000ff
    }
}

public struct Palette {
    let colorsByName: [String: PaletteColor]

    init(from file: File) throws {
        let colors = try JSONDecoder().decode([PaletteColor].self, from: file.read())
        colorsByName = colors.reduce(into: [String: PaletteColor]()) {
            $0[$1.name] = $1
        }
    }

    public func rgb(for colorName: String) throws -> (UInt64, UInt64, UInt64) {
        guard let color = colorsByName[colorName] else { throw Palette.Error.missingPaletteColor(colorName) }
        return (color.red, color.green, color.blue)
    }
}

public extension Palette {
    enum Error: Swift.Error {
        case missingPaletteColor(_ paletteColorName: String)
    }
}
