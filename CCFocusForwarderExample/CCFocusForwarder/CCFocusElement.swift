//
//  CCForwardingButton.swift
//  CCFocusForwarding
//
//  Created by Sabatino Masala on 19/12/15.
//  Copyright © 2015 Sabatino Masala. All rights reserved.
//

import UIKit

class CCFocusElement: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame);
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!;
  }
  
  override func canBecomeFocused() -> Bool {
    return true;
  }
    
}
