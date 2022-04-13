//
//  CryptoViewModel.swift
//  Crypto
//
//  Created by Gabriel Toro on 10/04/2022.
//
import Combine
import Foundation
import SwiftUI

class CryptoViewModel: ObservableObject{
    
    @Published private(set) var cryptos: [Crypto] = []
    @Published var BTCNotification: Crypto = Crypto(name: "", symbol: "", price: 0.0)
    var cryptoType: Crypto = Crypto(name: "", symbol: "", price: 0.0)
    

    //suscripcion al publisher
    private var suscription: AnyCancellable?
    

    
    public func onAppear(){
        //datos ip
        suscription = CoinMarketCapAPI.shared.fetchCrypto()
            .sink(receiveCompletion: { completion in
                switch completion{
                case .failure(let error):
                    print(error)
                case .finished:
                    print("Success!")
                }
                
            }, receiveValue: { [weak self] value in
                guard let self = self else {return}
                for i in 0..<value.data.count{
                    if value.data[i].symbol == "BTC"{
                        self.BTCNotification.name = value.data[i].name
                        self.BTCNotification.symbol = value.data[i].symbol
                        self.BTCNotification.price = value.data[i].quote.usd.price
                    }
                    self.cryptoType.name = value.data[i].name
                    self.cryptoType.symbol = value.data[i].symbol
                    self.cryptoType.price = value.data[i].quote.usd.price
                    
                    self.cryptos.append(self.cryptoType)
                }
                self.cryptos.sort{
                    $0.price > $1.price
                }
                
            })
    }
}
