//
//  Game.swift
//  Set
//
//  Created by Samat Gaynutdinov on 25.05.2022.
//

import Foundation


class Game {
    static let matchCount = 3
    
    private(set) var deck = Deck()
    private(set) var selectedCards: [Card] = []
    private(set) var matchedCards: [Card] = []
    var score = 0
    
    static let matchScore = 3
    static let mismatchScore = -5
    static let deselectionScore = -1
    
    func startNewGame() {
        score = 0
        deck = Deck()
        selectedCards = []
        matchedCards = []
    }
    
    func touchCard(card: Card) -> Bool {
        if let index = selectedCards.firstIndex(of: card) {
            selectedCards.remove(at: index)
            return false
        }
        selectedCards.append(card)
        return true
    }
    
    func checkIfMatch() -> Bool {
        if (selectedCards.count < Game.matchCount) {
            return false
        }
        
        return selectedCards.first!.isMatch(selectedCards[1], selectedCards[2])
    }
    
    func clearSelected() {
        selectedCards.removeAll()
    }
    
    func clearFirstCards() {
        selectedCards.removeFirst(Game.matchCount)
    }
}


// TODO: make it more generic
extension Card {
    func isMatch(_ first: Card, _ second: Card) -> Bool {
        isColorMatch(first, second) ||
        isNumberMatch(first, second) ||
        isSymbolMatch(first, second) ||
        isShadingMatch(first, second)
    }
    
    private func isColorMatch(_ first: Card, _ second: Card) -> Bool {
        color == first.color && first.color == second.color
    }
    
    private func isSymbolMatch(_ first: Card, _ second: Card) -> Bool {
        symbol == first.symbol && first.symbol == second.symbol
    }
    
    private func isNumberMatch(_ first: Card, _ second: Card) -> Bool {
        number == first.number && first.number == second.number
    }
    
    private func isShadingMatch(_ first: Card, _ second: Card) -> Bool {
        shading == first.shading && first.shading == second.shading
    }
}
