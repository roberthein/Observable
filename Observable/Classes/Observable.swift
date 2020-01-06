import Foundation

public class ImmutableObservable<T> {
    
    public typealias Observer = (T, T?) -> Void
    
    private var observers: [Int: (Observer, DispatchQueue?)] = [:]
    private var uniqueID = (0...).makeIterator()
    
    fileprivate let lock: Lock = Mutex()
    
    fileprivate var _value: T {
        didSet {
            let newValue = _value
            observers.values.forEach { observer, dispatchQueue in
                notify(observer: observer, dispatchQueue, oldValue: oldValue)
            }
        }
    }
  
    public var value: T {
        return _value
    }
      
    fileprivate var _onDispose: () -> Void
    
    public init(_ value: T, onDispose: @escaping () -> Void = {}) {
        self._value = value
        self._onDispose = onDispose
    }
    
    public func observe(_ queue: DispatchQueue? = nil, _ observer: @escaping Observer) -> Disposable {
        lock.lock()
        defer { lock.unlock() }
        
        let id = uniqueID.next()!
        
        observers[id] = (observer, queue)
        notify(observer: observer, queue, oldValue: nil)
        
        let disposable = Disposable { [weak self] in
            self?.observers[id] = nil
            self?._onDispose()
        }
        
        return disposable
    }
    
    public func removeAllObservers() {
        observers.removeAll()
    }
    
    public func asImmutable() -> ImmutableObservable<T> {
        return self
    }
    
    fileprivate func notify(observer: @escaping Observer, _ queue: DispatchQueue? = nil, oldValue: T?) {
        if let queue = queue {
            queue.async {
                observer(self.value, oldValue)
            }
        } else {
            observer(value, oldValue)
        }
    }
}

public class Observable<T>: ImmutableObservable<T> {
    
    public override var value: T {
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
