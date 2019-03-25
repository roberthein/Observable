import Foundation

public class Subject<T> {
    
    public typealias Observer = (T, T?) -> Void
    
    private var observers: [Int: (Observer, DispatchQueue?)] = [:]
    private var uniqueID = (0...).makeIterator()
    
    let lock: Lock = Mutex()
    var _value: T? {
        didSet {
            let val = _value!
            
            observers.values.forEach { observer, dispatchQueue in
                if let dispatchQueue = dispatchQueue {
                    dispatchQueue.async {
                        observer(val, oldValue)
                    }
                } else {
                    observer(val, oldValue)
                }
            }
        }
    }
    
    public init() {
    }
    
    public func update(value: T) {
        lock.lock()
        defer { lock.unlock() }
        _value = value
    }
    
    public func observe(_ queue: DispatchQueue? = nil, _ observer: @escaping Observer) -> Disposable {
        
        lock.lock()
        let id = uniqueID.next()!
        observers[id] = (observer, queue)
        if let value = _value {
            observer(value, nil)
        }
        lock.unlock()
        
        let disposable = Disposable { [weak self] in
            self?.observers[id] = nil
        }
        
        return disposable
    }
    
    public func removeAllObservers() {
        lock.lock()
        defer { lock.unlock() }
        
        observers.removeAll()
    }
}
