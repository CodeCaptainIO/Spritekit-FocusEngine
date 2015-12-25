//
//  NSObject+CCFocusEngine.m
//  CCFocusForwarderExample
//
//  Created by Sabatino Masala on 21/12/15.
//  Copyright © 2015 Sabatino Masala. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+CCFocusEngine.h"

/*
 
 If you want to enable the muting, set create a preprocessing macro called ENABLE_FOCUS_ENGINE_MUTING.
 Note: This will probably lead to AppStore rejection, so beware.
 
 */
#ifdef ENABLE_FOCUS_ENGINE_MUTING

@implementation NSObject (CCFocusEngine)

+ (void)load {
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    
    SEL sel = NSSelectorFromString(@"_playsSoundOnFocusChange");
    Method original = class_getInstanceMethod(objc_getClass("_UIFocusEngine"), sel);
    Method swizzled = class_getInstanceMethod(self, @selector(swizzledPlaysSound));
    method_exchangeImplementations(original, swizzled);
    
  });
  
}

- (BOOL)swizzledPlaysSound {
  
  return NO;
}

@end

#endif