//
//  GameViewController.swift
//  CCFocusForwarderExample
//
//  Created by Sabatino Masala on 19/12/15.
//  Copyright (c) 2015 Sabatino Masala. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, CCFocusForwarderDelegate {
  
  var gameScene: GameScene?
  
  override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
    let press: UIPress = presses.first!
    
    if press.type == .Select {
      self.gameScene?.openCurrentCard()
    }
    
  }
  
  override func viewDidLoad() {
    let forwarder: CCFocusForwarder = CCFocusForwarder()
    forwarder.delegate = self
    self.view.addSubview(forwarder)
    // forwarder.debug = true    
  }
  
  // CCFocusForwarderDelegate
  
  func focusForwarderDidMove(focusHeading: UIFocusHeading) {
    
    if focusHeading == .Right {
      self.gameScene!.focusNext()
    } else if focusHeading == .Left {
      self.gameScene!.focusPrev()
    } else if focusHeading == .Up {
      self.gameScene!.focusUp()
    } else if focusHeading == .Down {
      self.gameScene!.focusDown()
    } else if focusHeading.rawValue == 0 {
      self.gameScene!.focusFirst()
    }
    
  }
  
  func focusForwarderCanMoveRight() -> Bool {
    return self.gameScene!.canMoveRight()
  }
  func focusForwarderCanMoveLeft() -> Bool {
    return self.gameScene!.canMoveLeft()
  }
  func focusForwarderCanMoveUp() -> Bool {
    return self.gameScene!.canMoveUp()
  }
  func focusForwarderCanMoveDown() -> Bool {
    return self.gameScene!.canMoveDown()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    let skView: SKView = self.view as! SKView
    
    if skView.scene == nil {

      self.gameScene = GameScene()
      self.gameScene?.size = self.view.frame.size
      self.gameScene!.scaleMode = SKSceneScaleMode.AspectFill
      
      skView.presentScene(self.gameScene!)
      
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
}
