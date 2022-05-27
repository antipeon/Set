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
        guard game.deck.cards.count >= Game.matchCount && cardToButton.count + Game.matchCount <= cardButtons.count else {
            sender.isEnabled = false
            return
        }
        sender.isEnabled = true
        
        updateFirstSelectedCardsState()
        dealCards()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        guard let card = getCardByButton(button: sender) else {
            fatalError("no card matches this button")
        }
        
        if game.selectedCards.contains(card) && game.selectedCards.count >= Game.matchCount {
            return
        }
        
        let deselected = !game.touchCard(card: card)
        if deselected {
            game.score += Game.deselectionScore
        }

        if game.selectedCards.count == Game.matchCount + 1 {
            let isMatch = game.checkIfMatch()
            updateFirstSelectedCardsState()
            if isMatch {
                dealCards()
            }
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
        initializeLabels()
        startNewGame()
        // Do any additional setup after loading the view.
    }
    
    private func initializeLabels() {
        let cornerRadius = 6.0
        newGameLabel.layer.cornerRadius = cornerRadius
        scoreLabel.layer.masksToBounds = true
        scoreLabel.layer.cornerRadius = cornerRadius
        dealMoreLabel.layer.cornerRadius = cornerRadius
    }
    
    private func hideAllCards() {
        for card in cardButtons {
            card.isHidden = true
        }
    }
    
    private func dealFirstCards() {
        dealCards(number: 12)
    }
    
    private func dealCards() {
        dealCards(number: Game.matchCount)
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
            fatalError("no more free buttons")
        }
        cardToButton[card] = button
        show(card: card, onButton: button)
    }
    
    private func getFreeButton() -> UIButton? {
        return cardButtons.first(where: {$0.isHidden})
    }
    
    private func updateFirstSelectedCardsState() {
        if game.checkIfMatch() {
            game.score += Game.matchScore
            game.selectedCards[..<Game.matchCount].forEach {
                cardToButton[$0]?.isHidden = true
                cardToButton[$0] = nil
            }
        } else {
            game.score += Game.mismatchScore
        }
        game.clearFirstCards()
    }

    private func show(card: Card, onButton button: UIButton) {
        var title = ""
        for _ in 1...card.number.rawValue {
            title += card.symbol.rawValue
        }
        button.backgroundColor = .white
        
        var attributes: [NSAttributedString.Key : Any] = [
            .strokeColor: card.color.UIKitColor,
            .font: UIFont(name: "Chalkduster", size: 30.0)!
        ]
        switch card.shading {
        case .open:
            attributes[.strokeWidth] = 7
            attributes[.foregroundColor] = card.color.UIKitColor.withAlphaComponent(1)
        case .solid:
            attributes[.strokeWidth] = -2
            attributes[.foregroundColor] = card.color.UIKitColor.withAlphaComponent(1)
        case .stripped:
            attributes[.strokeWidth] = 7
            attributes[.foregroundColor] = card.color.UIKitColor.withAlphaComponent(0.20)
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
            fatalError("no card for this button")
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
