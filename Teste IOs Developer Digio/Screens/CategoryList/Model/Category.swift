//
//  Category.swift
//  Teste IOs Developer Digio
//
//  Created by Luiz on 25/01/23.
//

import Foundation
struct Category: Codable {
    let spotlight: [Spotlight]
    let products: [Product]
    let cash: Cash
}
