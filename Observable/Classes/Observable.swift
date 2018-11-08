import Foundation

public final class Observable<T> {

    public typealias Observer = (T, T?) -> Void

    private var observers: [Int: (Observer, DispatchQueue?)] = [:]
    private var uniqueID = (0...).makeIterator()

    public var value: T {
        didSet {
            observers.values.forEach { observer, dispatchQueue in
                
                if let dispatchQueue = dispatchQueue {
                    dispatchQueue.async {
                        observer(self.value, oldValue)
                    }
                } else {
                    observer(value, oldValue)
                }
            }
        }
    }

    public init(_ value: T) {
        self.value = value
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
