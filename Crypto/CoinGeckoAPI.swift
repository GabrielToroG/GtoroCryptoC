//
//  CoinGeckoAPI.swift
//  Crypto
//
//  Created by Gabriel Toro on 10/04/2022.
//

import Foundation

//https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false

struct CoinGeckoAPI{
    
    
}

/*===================================
    INICIO Estructuras de datos
 ==================================*/
struct APIResponse: Decodable{
    let name: String
    let symbol: String
    let image: String
    let currentPrice: Double
    
    enum CodingKeys: String, CodingKey{
        case name
        case symbol
        case image
        case currentPrice = "current_price"
    }
}
/*===================================
    FIN   Estructuras de datos
 ==================================*/
