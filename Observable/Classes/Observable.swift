import Foundation

@available(*, deprecated, renamed: "Observable", message: "`Observable` was renamed to `MutableObservable` and `ImmutableObservable` was renamed to `Observable`. An `Observable` can only read and observe changes on the `wrappedValue`. If you want to change the `wrappedValue` please use a `MutableObservable`instead.")
public typealias ImmutableObservable = Observable

public class Observable<T> {
    
    public typealias Observer = (T, T?) -> Void
    
    private var observers: [Int: (Observer, DispatchQueue?)] = [:]
    private var uniqueID = (0...).makeIterator()
    
    fileprivate let lock = NSRecursiveLock()
    
    fileprivate var _value: T {
        didSet {
            let newValue = _value
            observers.values.forEach { observer, dispatchQueue in
                notify(observer: observer, queue: dispatchQueue, value: newValue, oldValue: oldValue)
            }
        }
    }
    
    public var wrappedValue: T {
        return _value
    }
    
    public var value: T {
        @available(*, deprecated, renamed: "wrappedValue")
        get {
            return _value
        }
        @available(*, deprecated, message: "The `value` in the `Observable` class is read only. If you want and change the `value` please use a `MutableObservable` instead.")
        set {
            lock.lock()
            defer { lock.unlock() }
            _value = newValue
        }
    }
      
    fileprivate var _onDispose: () -> Void
    
    public init(_ value: T, onDispose: @escaping () -> Void = {}) {
        _value = value
        _onDispose = onDispose
    }
    
    public init(wrappedValue: T) {
        _value = wrappedValue
        _onDispose = {}
    }
    
    public func observe(_ queue: DispatchQueue? = nil, _ observer: @escaping Observer) -> Disposable {
        lock.lock()
        defer { lock.unlock() }
        
        let id = uniqueID.next()!
        
        observers[id] = (observer, queue)
        notify(observer: observer, queue: queue, value: wrappedValue)
        
        let disposable = Disposable { [weak self] in
            self?.observers[id] = nil
            self?._onDispose()
        }
        
        return disposable
    }
    
    public func removeAllObservers() {
        observers.removeAll()
    }
    
    @available(*, deprecated, renamed: "asObservable")
    public func asImmutable() -> ImmutableObservable<T> {
        return self
    }
    
    public func asObservable() -> Observable<T> {
        return self
    }
    
    fileprivate func notify(observer: @escaping Observer, queue: DispatchQueue? = nil, value: T, oldValue: T? = nil) {
        if let queue = queue {
            queue.async {
                observer(value, oldValue)
            }
        } else {
            observer(value, oldValue)
        }
    }
}

@propertyWrapper
public class MutableObservable<T>: Observable<T> {
    
    override public var wrappedValue: T {
        get {
            return _value
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _value = newValue
        }
    }
    
    @available(*, deprecated, renamed: "wrappedValue")
    override public var value: T {
        get {
            return _value
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _value = newValue
        }
    }
}
