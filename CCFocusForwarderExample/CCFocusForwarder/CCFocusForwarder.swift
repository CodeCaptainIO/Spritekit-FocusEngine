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

protocol CCFocusForwarderDelegate: CCEventForwardingDelegate {
  func focusForwarderDidMove(focusHeading: UIFocusHeading);
}

enum FocusGuidePosition: Int {
  case Top;
  case Right;
  case Bottom;
  case Left;
}

class CCFocusForwarder: UIView, CCEventForwardingDelegate {
  
  // When set to true, we see the elements on screen
  var debug: Bool = false {
    didSet {
      if self.debug {
        self.alpha = 1;
      } else {
        self.alpha = self.invisibleValue;
      }
    }
  };
  
  // If set to 0, the Focus Engine will ignore the elements
  private var invisibleValue: CGFloat = 0.000001;
  
  // Direction of movement
  var focusHeading: UIFocusHeading! {
    didSet {
      
      if let delegate = self.delegate {
        delegate.focusForwarderDidMove(self.focusHeading);
      }
      
    }
  }
  
  var delegate: CCFocusForwarderDelegate?;
  var topLeftButton: CCEventForwardingButton!;
  var topRightButton: CCEventForwardingButton!;
  var bottomLeftButton: CCEventForwardingButton!;
  var bottomRightButton: CCEventForwardingButton!;
  
  var leftTopFocusGuide: UIFocusGuide!;
  var leftBottomFocusGuide: UIFocusGuide!;
  
  var rightTopFocusGuide: UIFocusGuide!;
  var rightBottomFocusGuide: UIFocusGuide!;
  
  var topLeftFocusGuide: UIFocusGuide!;
  var topRightFocusGuide: UIFocusGuide!;
  
  var bottomLeftFocusGuide: UIFocusGuide!;
  var bottomRightFocusGuide: UIFocusGuide!;
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!;
    self.setup();
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame);
    self.setup();
  }
  
  convenience init() {
    self.init(frame: CGRectMake(0, 0, 200, 200));
  }
  
  func setup() {
    
    self.alpha = self.invisibleValue;
    
    // TL
    var tuple = self.createButton(CGRectMake(0, 0, 100, 100), focusGuidePositions: [.Top, .Left]);
    self.topLeftButton = tuple.btn;
    self.topLeftFocusGuide = tuple.guides[0];
    self.leftTopFocusGuide = tuple.guides[1];
    
    // TR
    tuple = self.createButton(CGRectMake(100, 0, 100, 100), focusGuidePositions: [.Top, .Right]);
    self.topRightButton = tuple.btn;
    self.topRightFocusGuide = tuple.guides[0];
    self.rightTopFocusGuide = tuple.guides[1];
    
    // BR
    tuple = self.createButton(CGRectMake(100, 100, 100, 100), focusGuidePositions: [.Right, .Bottom]);
    self.bottomRightButton = tuple.btn;
    self.rightBottomFocusGuide = tuple.guides[0];
    self.bottomRightFocusGuide = tuple.guides[1];
    
    // BL
    tuple = self.createButton(CGRectMake(0, 100, 100, 100), focusGuidePositions: [.Bottom, .Left]);
    self.bottomLeftButton = tuple.btn;
    self.bottomLeftFocusGuide = tuple.guides[0];
    self.leftBottomFocusGuide = tuple.guides[1];
    
    self.setNeedsFocusUpdate();
    
  }
  
  
  /**
   Creates a button and focusGuides associated to it.
   @param frame: Frame of the button
   @param focusGuidePositions: Array of focus guide positions
   */
  func createButton(frame: CGRect, focusGuidePositions: [FocusGuidePosition]) -> (btn: CCEventForwardingButton, guides: [UIFocusGuide]) {
    let btn: CCEventForwardingButton = CCEventForwardingButton(frame: frame);
    btn.backgroundColor = UIColor.whiteColor();
    btn.delegate = self;
    btn.frame = frame;
    self.addSubview(btn);
    
    // Return value
    var guides: [UIFocusGuide] = [];
    
    for focusGuidePosition:FocusGuidePosition in focusGuidePositions {
      
      let guide: UIFocusGuide = UIFocusGuide();
      self.addLayoutGuide(guide);
      guides.append(guide);
      guide.widthAnchor.constraintEqualToAnchor(btn.widthAnchor).active = true;
      guide.heightAnchor.constraintEqualToAnchor(btn.heightAnchor).active = true;
      
      // Create layout guides at the given position
      
      if (focusGuidePosition == .Left) {
        
        guide.topAnchor.constraintEqualToAnchor(btn.topAnchor).active = true;
        guide.rightAnchor.constraintEqualToAnchor(btn.leftAnchor).active = true;
        
      } else if (focusGuidePosition == .Bottom) {
        
        guide.topAnchor.constraintEqualToAnchor(btn.bottomAnchor).active = true;
        guide.rightAnchor.constraintEqualToAnchor(btn.rightAnchor).active = true;
        
      } else if (focusGuidePosition == .Top) {
        
        guide.bottomAnchor.constraintEqualToAnchor(btn.topAnchor).active = true;
        guide.rightAnchor.constraintEqualToAnchor(btn.rightAnchor).active = true;
        
      } else if (focusGuidePosition == .Right) {
        
        guide.topAnchor.constraintEqualToAnchor(btn.topAnchor).active = true;
        guide.leftAnchor.constraintEqualToAnchor(btn.rightAnchor).active = true;
        
      }
      
    }
    
    // Return tuple with button & guides
    return (btn, guides);
    
  }
  
  override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
    super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)
    
    guard let nextFocusedView = context.nextFocusedView else { return; }
    
    context.nextFocusedView?.backgroundColor = UIColor.grayColor();
    context.previouslyFocusedView?.backgroundColor = UIColor.whiteColor();
    
    // Update the heading
    self.focusHeading = context.focusHeading;
    
    switch nextFocusedView {
    case topRightButton:

      self.rightTopFocusGuide.preferredFocusedView = self.topLeftButton;
      self.topRightFocusGuide.preferredFocusedView = self.bottomRightButton;
      break;
      
    case topLeftButton:

      self.leftTopFocusGuide.preferredFocusedView = self.topRightButton;
      self.topLeftFocusGuide.preferredFocusedView = self.bottomLeftButton;
      break;
      
    case bottomLeftButton:
      
      self.leftBottomFocusGuide.preferredFocusedView = self.bottomRightButton;
      self.bottomLeftFocusGuide.preferredFocusedView = self.topLeftButton;
      break;
      
    case bottomRightButton:
      
      self.rightBottomFocusGuide.preferredFocusedView = self.bottomLeftButton;
      self.bottomRightFocusGuide.preferredFocusedView = self.topRightButton;
      break;
      
    default:
      return;
    }
    
  }
  
  // Pass the events to the delegate (required when using UIButtons instead of UIViews)
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let delegate = self.delegate {
      delegate.touchesBegan(touches, withEvent: event);
    }
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let delegate = self.delegate {
      delegate.touchesEnded(touches, withEvent: event);
    }
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let delegate = self.delegate {
      delegate.touchesMoved(touches, withEvent: event);
    }
  }
  
  override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    if let delegate = self.delegate {
      delegate.touchesCancelled(touches, withEvent: event);
    }
  }
  
  override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
    if let delegate = self.delegate {
      delegate.pressesBegan(presses, withEvent: event);
    }
  }
  
  override func pressesCancelled(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
    if let delegate = self.delegate {
      delegate.pressesCancelled(presses, withEvent: event);
    }
  }
  
  override func pressesChanged(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
    if let delegate = self.delegate {
      delegate.pressesChanged(presses, withEvent: event);
    }
  }
  
  override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
    if let delegate = self.delegate {
      delegate.pressesEnded(presses, withEvent: event);
    }
  }
  
}
