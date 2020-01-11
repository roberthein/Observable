<p align="center">
    <img src="art/header.png" width="890" alt="Observable"/>
</p>

**Observable** is the easiest way to observe values in Swift.

## How to
### Create an Observable and MutableObservable 
Using `MutableObservable` you can create and observe event.
Using `Observable` you can observe event, in order to avoid side-effects on our internal API. 
```swift
class SomeViewModel {
    /// Public property, that can be read / observed by external classes (e.g. view controller), but not changed.
    var position: Observable<CGPoint> = {
        return positionSubject
    }
    // Or use the helper method Observable.asObservable()
    // lazy var position = positionSubject.asObservable()

    /// Private property, that can be changed / observed inside this view model.
    private let positionSubject = MutableObservable(CGPoint.zero)
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

### Model Properties as @MutableObservable

Now mark your binded/mapped properties as observable and export public observable

```swift
//Private Observer
@MutableObservable var text: String = "Test"

//add observer

_text.observe { (newValue, oldValue) in
    print(newValue)
}.add(to: &disposable)
        
//Public Observer

var textObserve: ImmutableObservable<String> {
    return _text
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
position.wrappedValue = p
```

### Stop observing new values

```swift
position.observe {
    // This will stop all observers added to `disposal`
    self.disposal.dispose()
}.add(to: &disposal)

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

### Swift Package Manager

**Observable** is available through `Swift Package Manager`.
[Swift Package Manager](https://swift.org/package-manager/) (SwiftPM) is a tool for automating the distribution of Swift code. 
It is integrated into the swift compiler and from Xcode 11, SwiftPM got natively integrated with Xcode.

```swift
dependencies: [
    .package(url: "https://github.com/roberthein/Observable", from: "VERSION")
]
```

## Migrations

### 1.x.y to 2.0.0
- `Observable` is now `MutableObservable`
- `ImmutableObservable` is now `Observable`
- `Observable.asImmutableObservable()` is now `Observable.asObservable()`
- `Observable.value` is now `Observable.wrappedValue`


## Suggestions or feedback?

Feel free to create a pull request, open an issue or find [me on Twitter](https://twitter.com/roberthein).
