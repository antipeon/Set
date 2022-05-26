//
//  Deck.swift
//  Set
//
//  Created by Samat Gaynutdinov on 25.05.2022.
//

import Foundation

class Deck {
    private(set) var cards = [Card]()
    
    
    init() {
        defer {
            shuffle()
        }
        for shading in Shading.allCases {
            for color in Color.allCases {
                for symbol in Symbol.allCases {
                    for number in Number.allCases {
                        cards.append(Card(shading: shading,
                                          color: color,
                                          symbol: symbol,
                                          number: number))
                    }
                }
            }
        }
    }
    
    func dealCard() -> Card? {
        guard !cards.isEmpty else {
            return nil
        }
        return cards.removeFirst()
    }
    
    func shuffle() {
        cards.shuffle()
    }
    
}

extension Int {
    func getRandomUpToThis() -> Int {
        Int(arc4random_uniform(UInt32(self)))
    }
}

