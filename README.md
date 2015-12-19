# Spritekit-FocusEngine for tvOS
A focus forwarder for use with SpriteKit.

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

# Example

The example displays a deck of cards on screen through which you can scroll with the remote. Click to flip a card.
This example could serve as a base for a 'memory' game.

Assets are are provided by [Kenney](https://twitter.com/KenneyWings).

Enjoy!
