//
//  CoinMarketCapAPI.swift
//  Crypto
//
//  Created by Gabriel Toro on 11/04/2022.
//

import Combine  //anypublisher
import Foundation

struct CoinMarketCapAPI{
    private let API_KEY = "bc8bfa2d-81a6-4908-bb42-5cf9d13a4582"
    public static let shared: CoinMarketCapAPI = CoinMarketCapAPI()
    
    public func fetchCrypto() -> AnyPublisher<APIResponse, Error>{
        guard let url = URL(string: "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?CMC_PRO_API_KEY=\(API_KEY)&limit=100") else {
            let error = URLError(.badURL)
            return Fail(error: error).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.unknown)
                }
                
                guard httpResponse.statusCode == 200 else {
                    let code = URLError.Code(rawValue: httpResponse.statusCode)
                    throw URLError(code)
                }
                
                return data
            })
            .decode(type: APIResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}



struct APIResponse: Decodable{
    let data: [Datum]
}

struct Datum: Decodable{
    var name: String
    let symbol: String
    let quote: Quote
}

struct Quote: Decodable{
    let usd: Usd
    
    enum CodingKeys: String, CodingKey{
        case usd = "USD"
    }
}

struct Usd: Decodable{
    let price: Double
}
