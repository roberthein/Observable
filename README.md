<p align="center">
    <img src="art/header.png" width="890" alt="Observable"/>
</p>

**Observable** is the easiest way to observe values in Swift.

## How to

### Create an Observable 

```swift
var position = Observable(CGPoint.zero)
```

### Create an ImmutableObservable 
Using `ImmutableObservable` we can create an "readonly"-Observable, in order to avoid side-effects on our internal API. 

```swift
class SomeViewModel {
    /// Public property, that can be read / observed by external classes (e.g. view controller), but not changed.
    var position: ImmutableObservable<CGPoint> = {
        return positionSubject
    }
    // Or use the helper method Observable.asImmutable()
    // lazy var position = positionSubject.asImmutable()

    /// Private property, that can be changed / observed inside this view model.
    private let positionSubject = Observable(CGPoint.zero)
}
```

### Create Observer with custom onDispose functionality

In some cases Observables require resources while they're active that must be cleaned up when they're disposed of.  To handle such cases you can pass an optional block to the Observable initializer to be executed when the Observable is disposed of.

```swift
url.startAccessingSecurityScopedResource()
let observable = Observable([URL]()) {
    url.stopAccessingSecurityScopedResource()
}
```

### Add an observer

```swift
position.observe { p in
    // handle new position
}
```

### Add an observer and specify the DispatchQueue

```swift
position.observe(DispatchQueue.main) { p in
// handle new position
}
```

### Change the value

```swift
position.value = p
```

## Memory management

For a single observer you can store the returned `Disposable` to a variable

```swift
disposable = position.observe { p in

```

For multiple observers you can add the disposable to a `Disposal` variable

```swift
position.observe { }.add(to: &disposal)
```

And always weakify `self` when referencing `self` inside your observer

```swift
position.observe { [weak self] position in
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
