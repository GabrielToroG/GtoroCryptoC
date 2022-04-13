//
//  CryptoApp.swift
//  Crypto
//
//  Created by Gabriel Toro on 10/04/2022.
//

import SwiftUI

@main
struct CryptoApp: App {
    var body: some Scene {
        WindowGroup {
            CryptoView(viewModel: CryptoViewModel())
        }
    }
}
