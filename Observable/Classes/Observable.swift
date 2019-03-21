import Foundation

public class ImmutableObservable<T> {

    public typealias Observer = (T, T?) -> Void

    private var observers: [Int: (Observer, DispatchQueue?)] = [:]
    private var uniqueID = (0...).makeIterator()

    fileprivate let readWriteQueue: DispatchQueue = DispatchQueue(label: "Observable.ReadWriteQueue")
    fileprivate let observersQueue: DispatchQueue = DispatchQueue(label: "Observable.ObserversQueue")

    fileprivate var _value: T {
        didSet {
            observersQueue.async {
                self.observers.values.forEach { observer, dispatchQueue in
                    if let dispatchQueue = dispatchQueue {
                        dispatchQueue.async {
                            observer(self.value, oldValue)
                        }
                    } else {
                        observer(self.value, oldValue)
                    }
                }
            }
        }
    }

    public var value: T {
        return readWriteQueue.sync {
            return _value
        }
    }

    public init(_ value: T) {
        self._value = value
    }

    public func observe(_ queue: DispatchQueue? = nil, _ observer: @escaping Observer) -> Disposable {
        let id = uniqueID.next()!
        
        observers[id] = (observer, queue)
        observer(value, nil)
        
        let disposable = Disposable { [weak self] in
            self?.observers[id] = nil
        }
        
        return disposable
    }

    public func removeAllObservers() {
        observers.removeAll()
    }
}

public class Observable<T>: ImmutableObservable<T> {

    public override var value: T {
        get {
            return readWriteQueue.sync {
                return _value
            }
        }
        set {
            readWriteQueue.async {
                self._value = newValue
            }
        }
    }
}
