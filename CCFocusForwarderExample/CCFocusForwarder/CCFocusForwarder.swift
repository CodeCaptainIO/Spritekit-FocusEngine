//
//  CCFocusForwarder.swift
//  CCFocusForwarding
//
//  Created by Sabatino Masala on 19/12/15.
//  Copyright © 2015 Sabatino Masala. All rights reserved.
//

/*

TODO
Disabing sounds using private API.
Take a look at private class _UIFocusEngine, which has a property _playsSoundOnFocusChange.
https://github.com/neonichu/tvOS-headers/blob/b27d60eb4c2ab73c3473fcdc9219c6406ac1b885/UIKit/_UIFocusEngine.h

TODO
switch between sounds (UIButton / UIVIew / ...).

*/

import UIKit

@objc protocol CCFocusForwarderDelegate {
  func focusForwarderDidMove(focusHeading: UIFocusHeading)
  optional func focusForwarderCanMoveRight() -> Bool
  optional func focusForwarderCanMoveLeft() -> Bool
  optional func focusForwarderCanMoveUp() -> Bool
  optional func focusForwarderCanMoveDown() -> Bool
}

enum FocusGuidePosition: Int {
  case Top
  case Right
  case Bottom
  case Left
}

class CCFocusForwarder: UIView {
  
  // When set to true, we see the elements on screen
  var debug: Bool = false {
    didSet {
      if self.debug {
        self.alpha = 1
      } else {
        self.alpha = self.invisibleValue
      }
    }
  }
  
  // If set to 0, the Focus Engine will ignore the elements
  private var invisibleValue: CGFloat = 0.000001
  
  // Direction of movement
  var focusHeading: UIFocusHeading! {
    didSet {
      
      if let delegate = self.delegate {
        delegate.focusForwarderDidMove(self.focusHeading)
      }
      
    }
  }
  
  var delegate: CCFocusForwarderDelegate?
  var button: CCFocusElement!
  
  var topFocusGuide: UIFocusGuide!
  var rightFocusGuide: UIFocusGuide!
  var bottomFocusGuide: UIFocusGuide!
  var leftFocusGuide: UIFocusGuide!
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    self.setup()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }
  
  convenience init() {
    self.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
  }
  
  func setup() {
    
    self.alpha = self.invisibleValue
    
    var tuple = self.createButton(
      CGRect(x: 0, y: 0, width: 100, height: 100),
      focusGuidePositions: [.Top, .Right, .Bottom, .Left]
    )
    self.button = tuple.btn
    
    self.topFocusGuide = tuple.guides[0]
    topFocusGuide.preferredFocusedView = self.button
    
    self.rightFocusGuide = tuple.guides[1]
    self.rightFocusGuide.preferredFocusedView = self.button
    
    self.bottomFocusGuide = tuple.guides[2]
    self.bottomFocusGuide.preferredFocusedView = self.button
    
    self.leftFocusGuide = tuple.guides[3]
    self.leftFocusGuide.preferredFocusedView = self.button
    
    self.setNeedsFocusUpdate()
    
  }
  
  
  /**
   Creates a button and focusGuides associated to it.
   @param frame: Frame of the button
   @param focusGuidePositions: Array of focus guide positions
   */
  func createButton(frame: CGRect, focusGuidePositions: [FocusGuidePosition]) -> (btn: CCFocusElement, guides: [UIFocusGuide]) {
    let btn: CCFocusElement = CCFocusElement(frame: frame)
    btn.backgroundColor = UIColor.whiteColor()
    btn.userInteractionEnabled = true
    btn.frame = frame
    self.addSubview(btn)
    
    // Return value
    var guides: [UIFocusGuide] = []
    
    for focusGuidePosition: FocusGuidePosition in focusGuidePositions {
      
      let guide: UIFocusGuide = UIFocusGuide()
      self.addLayoutGuide(guide)
      guides.append(guide)
      guide.widthAnchor.constraintEqualToAnchor(btn.widthAnchor).active = true
      guide.heightAnchor.constraintEqualToAnchor(btn.heightAnchor).active = true
      
      // Create focus guides at the given position
      
      if focusGuidePosition == .Left {
        
        guide.topAnchor.constraintEqualToAnchor(btn.topAnchor).active = true
        guide.rightAnchor.constraintEqualToAnchor(btn.leftAnchor).active = true
        
      } else if focusGuidePosition == .Bottom {
        
        guide.topAnchor.constraintEqualToAnchor(btn.bottomAnchor).active = true
        guide.rightAnchor.constraintEqualToAnchor(btn.rightAnchor).active = true
        
      } else if focusGuidePosition == .Top {
        
        guide.bottomAnchor.constraintEqualToAnchor(btn.topAnchor).active = true
        guide.rightAnchor.constraintEqualToAnchor(btn.rightAnchor).active = true
        
      } else if focusGuidePosition == .Right {
        
        guide.topAnchor.constraintEqualToAnchor(btn.topAnchor).active = true
        guide.leftAnchor.constraintEqualToAnchor(btn.rightAnchor).active = true
        
      }
      
    }
    
    // Return tuple with button & guides
    return (btn, guides)
    
  }
  
  override func shouldUpdateFocusInContext(context: UIFocusUpdateContext) -> Bool {
    let heading = context.focusHeading
    
    if let delegate = self.delegate {
      if heading == .Right {
        if let method = delegate.focusForwarderCanMoveRight {
          return method()
        }
      } else if heading == .Left {
        if let method = delegate.focusForwarderCanMoveLeft {
          return method()
        }
      } else if heading == .Up {
        if let method = delegate.focusForwarderCanMoveUp {
          return method()
        }
      } else if heading == .Down {
        if let method = delegate.focusForwarderCanMoveDown {
          return method()
        }
      }
    }
    
    return true
  }
  
  override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
    super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)
    
    context.nextFocusedView?.backgroundColor = UIColor.grayColor()
    context.previouslyFocusedView?.backgroundColor = UIColor.whiteColor()
    
    // Update the heading
    self.focusHeading = context.focusHeading
    
  }
  
}
