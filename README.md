<p align="center">
    <img src="art/header.png" width="890" alt="Observable"/>
</p>

**Observable** is the easiest way to observe values in Swift.

![Swift 3.1](https://img.shields.io/badge/Swift-3.1-orange.svg)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/Observable.svg)](#cocoapods)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)


## How to

### Create an Observable 

```swift
var position = Observable(CGPoint.zero)
```

### Define the Disposable

```swift
var disposable: Disposable?
```

### Start observing

```swift
disposable = position.addObserver { [weak self] newPosition in
    // handle new position
}
```

### Change the value

```swift
position.value = newPosition
```

## Installation

### CocoaPods

**Observable** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Observable'
```

## Suggestions or feedback?

Feel free to create a pull request, open an issue or find [me on Twitter](https://twitter.com/roberthein).

## License

Observable is released under the MIT license. [See LICENSE](https://github.com/roberthein/Observable/blob/master/LICENSE) for details.
