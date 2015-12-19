//
//  CCForwardingButton.swift
//  CCFocusForwarding
//
//  Created by Sabatino Masala on 19/12/15.
//  Copyright © 2015 Sabatino Masala. All rights reserved.
//

import UIKit

// We forward these methods to the delegate so it can respond to them
protocol CCEventForwardingDelegate {
  func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?);
  func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?);
  func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?);
  func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?);
  
  func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?);
  func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?);
  func pressesChanged(presses: Set<UIPress>, withEvent event: UIPressesEvent?);
  func pressesCancelled(presses: Set<UIPress>, withEvent event: UIPressesEvent?);
  
}

class CCEventForwardingButton: UIView {
  
  var delegate: CCEventForwardingDelegate?;
  
  override init(frame: CGRect) {
    super.init(frame: frame);
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!;
  }
  
  override func canBecomeFocused() -> Bool {
    return true
  }
  
  // Forwarding (when CCEventFowardingButton is of type UIButton, we must forward these events)
  
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
