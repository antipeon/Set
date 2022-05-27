//
//  ViewController.swift
//  Set
//
//  Created by Samat Gaynutdinov on 25.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private var game = Game()
    
    private var cardToButton = [Card: UIButton]()
    
    // MARK: actions
    @IBAction func startNewGame(_ sender: UIButton) {
        startNewGame()
    }
    
    @IBAction func dealMore(_ sender: UIButton) {
        let cardsToDeal = 3
        guard game.deck.cards.count >= cardsToDeal && cardToButton.count + cardsToDeal <= cardButtons.count else {
            sender.isEnabled = false
            return
        }
        sender.isEnabled = true
        dealCards(number: cardsToDeal)
    }
    
    
    @IBAction func touchCard(_ sender: UIButton) {
        guard sender.isHidden == false else {
            return
        }
        guard let card = getCardByButton(button: sender) else {
            print("no card matches this button")
            exit(EXIT_FAILURE)
        }
        
        if game.selectedCards.contains(card) && game.selectedCards.count < 3 {
            return
        }
        
        let deselected = !game.touchCard(card: card)
        if deselected {
            game.score += Game.deselectionScore
        }
        if game.selectedCards.count == 3 {
            if game.checkIfMatch() {
                game.score += Game.matchScore
                game.selectedCards.forEach {
                    cardToButton[$0]?.isHidden = true
                    cardToButton[$0] = nil
                }
                
                game.clearSelected()
                dealCards(number: 3)
            } else {
                game.score += Game.mismatchScore
            }
        } else if game.selectedCards.count == 4 {
            game.clearSelected()
            _ = game.touchCard(card: card)
        }
        updateScoreLabel()
        redrawCardsWithSelection()
    }
    
    
    //MARK: outlets
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var newGameLabel: UIButton!
    @IBOutlet weak var dealMoreLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let radius = 6.0
        
        newGameLabel.layer.cornerRadius = radius
        scoreLabel.layer.masksToBounds = true
        scoreLabel.layer.cornerRadius = radius
        dealMoreLabel.layer.cornerRadius = radius
        startNewGame()
        // Do any additional setup after loading the view.
    }
    
    private func hideAllCards() {
        for card in cardButtons {
            card.isHidden = true
        }
    }
    
    private func dealFirstCards() {
        dealCards(number: 12)
    }
    
    private func dealCards(number: Int) {
        for _ in 0..<number {
            dealCard()
        }
        redrawCardsWithSelection()
    }
    
    private func dealCard() {
        guard let card = game.deck.dealCard() else {
            return
        }
        guard let button = getFreeButton() else {
            print("no more free buttons")
            exit(EXIT_FAILURE)
        }
        cardToButton[card] = button
        show(card: card, onButton: button)
    }
    
    private func getFreeButton() -> UIButton? {
        return cardButtons.first(where: {$0.isHidden})
    }
    
    private func show(card: Card, onButton button: UIButton) {
        var title = ""
        for _ in 1...card.number.rawValue {
            title += card.symbol.rawValue
        }
        button.backgroundColor = .white
        
        var attributes: [NSAttributedString.Key : Any] = [
            .strokeColor: card.color.toUIKitColor(),
            .font: UIFont(name: "Chalkduster", size: 30.0)!
        ]
        switch card.shading {
        case .open:
            attributes[.strokeWidth] = 7
            attributes[.foregroundColor] = card.color.toUIKitColor().withAlphaComponent(1)
        case .solid:
            attributes[.strokeWidth] = -2
            attributes[.foregroundColor] = card.color.toUIKitColor().withAlphaComponent(1)
        case .stripped:
            attributes[.strokeWidth] = 7
            attributes[.foregroundColor] = card.color.toUIKitColor().withAlphaComponent(0.20)
        }
        
        
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        // TODO: drawing a card needs to be more complicated
        button.isHidden = false
    }
    
    private func getCardByButton(button: UIButton) -> Card? {
        cardToButton.first(where: {
            button == $0.value
        })?.key
    }
    
    private func redrawCardsWithSelection() {
        for button in cardButtons {
            button.isHidden = true
        }
        for (_, button) in cardToButton {
            redrawCardForButton(button: button)
        }
    }
    
    private func redrawCardForButton(button: UIButton) {
        button.isHidden = false
        guard let card = getCardByButton(button: button) else {
            print("no card for this button")
            exit(EXIT_FAILURE)
        }
        if game.selectedCards.contains(card) {
            button.layer.borderWidth = 3
            button.layer.borderColor = UIColor.orange.cgColor
        } else {
            button.layer.borderColor = nil
            button.layer.borderWidth = 1
        }
    }
    
    private func startNewGame() {
        game.startNewGame()
        cardToButton = [Card: UIButton]()
        hideAllCards()
        dealFirstCards()
        redrawCardsWithSelection()
    }
    
    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(game.score)"
    }


}

extension Color {
    func toUIKitColor() -> UIColor {
        switch self {
        case .red:
            return UIColor.red
        case .green:
            return UIColor.green
        case .purple:
            return UIColor.purple
        }
    }
}

