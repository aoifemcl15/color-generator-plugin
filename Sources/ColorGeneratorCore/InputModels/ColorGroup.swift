//
//  ColorGroup.swift
//  ColorGenerator
//
//  Created by Sophie Lambrakis on 03/10/2019.
//

import Foundation

public struct ColorGroup: Decodable {
    let namespace: String
    let colors: [SemanticColor]
}
