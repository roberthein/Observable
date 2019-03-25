import Foundation

public class ImmutableObservable<T>: Subject<T> {
    
    public var value: T {
        lock.lock()
        defer { lock.unlock() }
        return _value!
    }

    private override init() {
    }
    
    public init(_ value: T) {
        super.init()
        _value = value
    }
}

public class Observable<T>: ImmutableObservable<T> {

    public override var value: T {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _value!
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _value = newValue
        }
    }
}
