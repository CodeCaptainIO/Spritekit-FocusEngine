//
//  Rank.swift
//  CCFocusForwarderExample
//
//  Created by Sabatino Masala on 20/12/15.
//  Copyright © 2015 Sabatino Masala. All rights reserved.
//

import Foundation

enum Rank: Int {
  case Ace = 1; // we do this so we don't start at 0
  case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten;
  case Jack, Queen, King;
  func stringValue() -> String {
    switch self {
    case .Ace:
      return "A";
    case .Jack:
      return "J";
    case .Queen:
      return "Q";
    case .King:
      return "K";
    default:
      return String(self.rawValue);
    }
  }
}
