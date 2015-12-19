# Spritekit-FocusEngine for tvOS

Blogpost: http://www.codecaptain.io/webdevelopment/focus-engine-for-spritekit-tvos/245

Since SpriteKit didn't come with a focus engine, this example shows you how to 'forward' focus to a Spritekit scene.

# Usage

Import the following 2 files:
- CCEventForwardingButton.swift
- CCFocusForwarder.swift

In viewDidLoad, create an instance of the `CCFocusForwarder` and add it to your view.
```swift
override func viewDidLoad() {
	let forwarder: CCFocusForwarder = CCFocusForwarder();
	self.view.addSubview(forwarder);
}
```
Implement the `CCFocusForwarderDelegate`.
```swift
func focusForwarderDidMove(focusHeading: UIFocusHeading);
```
Set the delegate of the forwarder.
```swift
forwarder.delegate = self;
```

Handle movement in `focusForwarderDidMove(focusHeading: UIFocusHeading)`

```swift
func focusForwarderDidMove(focusHeading: UIFocusHeading) {

  if (focusHeading == UIFocusHeading.Right) {
    print("Moving Right");
  } else if (focusHeading == UIFocusHeading.Left) {
    print("Moving Left");
  } else if (focusHeading == UIFocusHeading.Up) {
    print("Moving Up");
  } else if (focusHeading == UIFocusHeading.Down) {
    print("Moving Down");
  }
  
}
```

# Example

The example displays a deck of cards on screen through which you can scroll with the remote. Click to flip a card.
This example could serve as a base for a 'memory' game.

![Focus 
example](https://raw.githubusercontent.com/CodeCaptainIO/Spritekit-FocusEngine/033d3fbed8ff7a06a0885c12b7dc89395b95bd4c/screenshots/tv.png)

Assets are are provided by [Kenney](https://twitter.com/KenneyWings).

# Remarks

Disabling the standard 'beep' sound is unfortunately not possible at this moment since Apple didn't expose that API.
Take a look at private class _UIFocusEngine, which has a property _playsSoundOnFocusChange.
https://github.com/neonichu/tvOS-headers/blob/b27d60eb4c2ab73c3473fcdc9219c6406ac1b885/UIKit/_UIFocusEngine.h

# TODO

- Possibility to change sounds (UIView has a different sound than UIButton)
- Block scrolling in a certain direction
