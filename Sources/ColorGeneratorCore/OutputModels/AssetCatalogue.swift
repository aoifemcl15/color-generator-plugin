//
//  AssetCatalogue.swift
//  ColorGenerator
//
//  Created by Sophie Lambrakis on 07/10/2019.
//

import Foundation

public struct AssetCatalogueInfo: Encodable {
    enum EncodingKeys: String, CodingKey {
        case version
        case author
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(1, forKey: .version)
        try container.encode("ColorGenerator", forKey: .author)
    }
}

public struct AssetCatalogue: Encodable {
    let providesNamespace: Bool

    enum EncodingKeys: String, CodingKey {
        case info
        case properties
    }

    enum PropertiesKeys: String, CodingKey {
        case providesNamespace = "provides-namespace"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        try container.encode(AssetCatalogueInfo(), forKey: .info)

        if providesNamespace {
            var properties = container.nestedContainer(keyedBy: PropertiesKeys.self, forKey: .properties)
            try properties.encode(true, forKey: .providesNamespace)
        }
    }
}
