//
//  CryptoModel.swift
//  Crypto
//
//  Created by Gabriel Toro on 10/04/2022.
//

import Foundation

public struct Crypto{
    var name: String
    var symbol: String
    var price: Double
    
}

extension Crypto{
    static let dummyData: [Crypto] = [
        Crypto(name: "Anime 1", symbol: "Character 1", price: 1.1),
        Crypto(name: "Anime 2", symbol: "Character 2", price: 2.1),
        Crypto(name: "Anime 3", symbol: "Character 3", price: 3.1),
        Crypto(name: "Anime 4", symbol: "Character 4", price: 4.1),
        Crypto(name: "Anime 5", symbol: "Character 5", price: 5.1)
    ]
}
