//
//  Deck.swift
//  Set
//
//  Created by Samat Gaynutdinov on 25.05.2022.
//

import Foundation

class Deck {
    private(set) var cards: [Card] = []
    
    
    init() {
        for shading in Shading.allCases {
            for color in Color.allCases {
                for symbol in Symbol.allCases {
                    for number in Number.allCases {
                        let card = Card(shading: shading,
                                        color: color,
                                        symbol: symbol,
                                        number: number)
                        cards.append(card)
                    }
                }
            }
        }
        shuffle()
    }
    
    func dealCard() -> Card? {
        guard !cards.isEmpty else {
            return nil
        }
        return cards.popLast()
    }
    
    private func shuffle() {
        cards.shuffle()
    }
    
}
