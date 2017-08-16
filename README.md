<p align="center">
    <img src="art/header.png" width="890" alt="Observable"/>
</p>

**tl;dr** *Create observable, add observer and observe...*

**Observable** is a reactive library before it becomes complicated (or interesting)


## How to

### Create an Observable

```swift
var position = Observable(CGPoint.zero)
```

### Start observing

```swift
position.addObserver(self) { newPosition in
    // handle new position
}
```

### Change the value

```swift
position.value = newPosition
```

### Stop observing

```swift
position.removeObserver(self)
```

## Installation

### CocoaPods

**Observable** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Observable'
```

## Suggestions or feedback?

Feel free to create a pull request, open an issue or find me [on Twitter](https://twitter.com/roberthein).
