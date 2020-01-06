import Foundation

open class Observable<T> {
    
    public typealias Observer = (T, T?) -> Void
    
    private var observers: [Int: (Observer, DispatchQueue?)] = [:]
    private var uniqueID = (0...).makeIterator()
    
    fileprivate let lock: Lock = Mutex()
    
    fileprivate var _value: T {
        didSet {
            let newValue = _value
            observers.values.forEach { observer, dispatchQueue in
                if let dispatchQueue = dispatchQueue {
                    dispatchQueue.async {
                        observer(newValue, oldValue)
                    }
                } else {
                    observer(newValue, oldValue)
                }
            }
        }
    }
    
    public var wrappedValue: T {
        return _value
    }
      
    fileprivate var _onDispose: () -> Void
    
    public init(_ value: T, onDispose: @escaping () -> Void = {}) {
        self._value = value
        self._onDispose = onDispose
    }
    
    public init(wrappedValue: T) {
        self._value = wrappedValue
        self._onDispose = {}
    }
    
    public func observe(_ queue: DispatchQueue? = nil, _ observer: @escaping Observer) -> Disposable {
        lock.lock()
        defer { lock.unlock() }
        
        let id = uniqueID.next()!
        
        observers[id] = (observer, queue)
        observer(wrappedValue, nil)
        
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
    public func asImmutable() -> Observable<T> {
        return self
    }
    
    public func asObservable() -> Observable<T> {
        return self
    }
}

@propertyWrapper
open class MutableObservable<T>: Observable<T> {
    
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
    
}

