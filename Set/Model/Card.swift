//
//  Card.swift
//  Set
//
//  Created by Samat Gaynutdinov on 25.05.2022.
//

import Foundation
import UIKit

struct Card {
    private let id = UUID()
    
    let shading: Shading
    let color: Color
    let symbol: Symbol
    let number: Number
}

extension Card: Hashable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
