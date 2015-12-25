//
//  Card.swift
//  CCFocusForwarderExample
//
//  Created by Sabatino Masala on 19/12/15.
//  Copyright © 2015 Sabatino Masala. All rights reserved.
//

import SpriteKit

class Card: SKNode {
  
  override var description: String {
    return "\(self.cardModel!.asset)"
  }
  
  private let targetSize: CGSize = CGSize(width: 140, height: 190)
  
  var cardModel: CardModel? {
    didSet {
      if let front = self.front {
        front.texture = SKTexture(imageNamed: cardModel!.asset)
      }
    }
  }
  
  private var back: SKSpriteNode?
  private var front: SKSpriteNode?
  var size: CGSize {
    get {
      return self.targetSize
    }
  }
  override var frame: CGRect {
    get {
      return CGRect(
        x: self.position.x - self.size.width / 2,
        y: self.position.y - self.size.height / 2,
        width: self.targetSize.width,
        height: self.targetSize.height
      )
    }
  }
  var open: Bool = false {
    didSet {
      if open {
        self.back!.hidden = true
        self.front!.hidden = false
      } else {
        self.back!.hidden = false
        self.front!.hidden = true
      }
    }
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
  override init() {
    super.init()
  }
  
  convenience init(cardModel: CardModel) {
    self.init()
    
    self.cardModel = cardModel
    
    self.back = SKSpriteNode(imageNamed: "cardBack_red4")
    self.back!.size = self.targetSize
    self.addChild(self.back!)
    
    self.front = SKSpriteNode(imageNamed: cardModel.asset)
    self.addChild(self.front!)
    self.front!.hidden = true
    self.front!.size = self.targetSize
    
  }
  
  func updateAnimation() {
    self.updateAnimationWithScale(1.15)
  }
  
  private func updateAnimationWithScale(scale: CGFloat) {
    self.front!.xScale = scale
    self.front!.yScale = scale
    let scaleAction: SKAction = SKAction.scaleTo(1, duration: 0.2)
    self.front!.runAction(scaleAction, completion: { () -> Void in
    })
  }
  
  func flip() {
    if self.open {
      return
    }
    let scaleXAction: SKAction = SKAction.scaleXTo(0.05, duration: 0.225)
    let scaleYAction: SKAction = SKAction.scaleYTo(1.3, duration: 0.225)
    let groupAction: SKAction = SKAction.group([scaleXAction, scaleYAction])
    self.back!.runAction(groupAction) { () -> Void in
      self.back!.hidden = true
      self.front!.hidden = false
      self.updateAnimationWithScale(1.25)
      self.open = true
    }
  }
  
}
