//
//  CardModel.swift
//  CCFocusForwarderExample
//
//  Created by Sabatino Masala on 19/12/15.
//  Copyright © 2015 Sabatino Masala. All rights reserved.
//

import UIKit

class CardModel: NSObject {
  var asset: String
  var suit: Suit
  var card: String
  var rank: Rank
  
  override var description: String {
    return "\(self.card) of \(self.suit)"
  }
  
  init(suit: Suit, card: Rank) {
    self.rank = card
    self.suit = suit
    self.card = card.stringValue()
    self.asset = "card" + String(suit) + self.card
    super.init()
  }
  
}
