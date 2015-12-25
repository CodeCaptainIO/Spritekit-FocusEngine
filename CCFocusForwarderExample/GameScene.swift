//
//  GameScene.swift
//  CCFocusForwarderExample
//
//  Created by Sabatino Masala on 19/12/15.
//  Copyright (c) 2015 Sabatino Masala. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  
  var textLabel: SKLabelNode?
  
  // 13 cards per row, hardcoded for now
  let numberOfCardsPerRow: Int = 13
  
  // Keep a reference to every card
  var cardDeck: [Card]! = []
  
  var selectedCard: Card? {
    didSet {
      var index: CGFloat = 0
      let animationDuration: NSTimeInterval = 0.1
     
      for card: Card in self.cardDeck {
        // TODO - This is hacky & comes with a performance impact, only apply actions to the cards that need to change!
        var fadeAction: SKAction
        var scaleAction: SKAction
      
        if card != self.selectedCard {
          fadeAction = SKAction.fadeAlphaTo(0.2, duration: animationDuration)
          scaleAction = SKAction.scaleTo(1.0, duration: animationDuration)
          card.zPosition = index
        } else {
          fadeAction = SKAction.fadeAlphaTo(1.0, duration: animationDuration)
          scaleAction = SKAction.scaleTo(1.2, duration: animationDuration)
          card.zPosition = 999
        }
        
        card.runAction( SKAction.group([fadeAction, scaleAction]) )
        index++
      }
      
    }
  }
  
  
  override func didMoveToView(view: SKView) {
    self.backgroundColor = UIColor(red: 0.231, green: 0.49, blue: 0.725, alpha: 1.0)
    
    // Setup textlabel
    self.textLabel = SKLabelNode(text: "Focus Forwarding Example for SpriteKit")
    self.textLabel?.position = CGPoint(x: self.size.width / 2, y: self.size.height - 100)
    self.textLabel!.fontSize = 40
    self.textLabel!.fontName = "HelveticaNeue-Regular"
    self.addChild(self.textLabel!)
    
    self.setupCards()
  }
  
  func setupCards() {
    let suits = [
      Suit.Clubs,
      Suit.Diamonds,
      Suit.Hearts,
      Suit.Spades
    ]
    let cards = [
      Rank.Ace,
      Rank.Two,
      Rank.Three,
      Rank.Four,
      Rank.Five,
      Rank.Six,
      Rank.Seven,
      Rank.Eight,
      Rank.Nine,
      Rank.Ten,
      Rank.Jack,
      Rank.Queen,
      Rank.King
    ]
    
    var yPos: CGFloat = self.size.height - 250
    
    for suit: Suit in suits {
      
      var xPos: CGFloat = 77
      
      for card: Rank in cards {
        
        let cardModel: CardModel = CardModel(suit: suit, card: card)
        
        let card: Card = Card(cardModel: cardModel)
        self.cardDeck.append( card )
        self.addChild( card )
        card.position = CGPoint(x: xPos, y: yPos)
        
        xPos += 147
        
      }
      yPos -= 200
    }
    
  }
  
  func openCurrentCard() {

    if !self.selectedCard!.open {
      self.selectedCard?.flip()
    }
    
  }
  
  func focusFirst() {
    
    self.selectedCard = self.cardDeck[0]
    
  }
  
  func focusNext() {
    var index: Int = self.cardDeck.indexOf(self.selectedCard!)!
    let oldIndex = index
    index += 1
  
    // This check will keep the selected card on the same row & wrap around
    if oldIndex % self.numberOfCardsPerRow > index % self.numberOfCardsPerRow {
      index -= self.numberOfCardsPerRow
    }
    
    self.selectedCard = self.cardDeck[index]
    
  }
  
  func focusPrev() {
    var index: Int = self.cardDeck.indexOf(self.selectedCard!)!
    let oldIndex = index
    index -= 1
   
    // This check will keep the selected card on the same row & wrap around
    if oldIndex % self.numberOfCardsPerRow == 0 {
      index += self.numberOfCardsPerRow
    }
    
    self.selectedCard = self.cardDeck[index]
    
  }
  
  func focusUp() {
    var index: Int = self.cardDeck.indexOf(self.selectedCard!)!
    index -= self.numberOfCardsPerRow

    if index < 0 {
      index = index + self.cardDeck.count
    }
    
    self.selectedCard = self.cardDeck[index]
    
  }
  
  func focusDown() {
    var index: Int = self.cardDeck.indexOf(self.selectedCard!)!
    index += self.numberOfCardsPerRow
   
    if index > self.cardDeck.count - 1 {
      index = index - self.cardDeck.count
    }
    self.selectedCard = self.cardDeck[index]
    
  }
  
}
