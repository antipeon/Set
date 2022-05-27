//
//  Card.swift
//  Set
//
//  Created by Samat Gaynutdinov on 25.05.2022.
//

import Foundation

struct Card {
    private let id: UUID
    
    let shading: Shading
    let color: Color
    let symbol: Symbol
    let number: Number
    
    init(shading: Shading, color: Color, symbol: Symbol, number: Number) {
        self.shading = shading
        self.color = color
        self.symbol = symbol
        self.number = number
        id = UUID()
    }
}


enum Shading: CaseIterable {
    case solid
    case stripped
    case open
}

enum Color: CaseIterable {
    case red
    case green
    case purple
}

enum Symbol: String, CaseIterable {
    case diamond = "△"
    case squiggle = "⌽"
    case oval = "Ο"
}

enum Number: Int, CaseIterable {
    case one = 1
    case two
    case three
}


extension Card: Hashable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
