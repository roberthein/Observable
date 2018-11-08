import Foundation

public final class Observable<T> {

    public typealias Observer = (T, T?) -> Void

    private var observers: [Int: Observer] = [:]
    private var uniqueID = (0...).makeIterator()

    public var value: T {
        didSet {
            observers.values.forEach { $0(value, oldValue) }
        }
    }

    public init(_ value: T) {
        self.value = value
    }

    public func observe(_ observer: @escaping Observer) -> Disposable {
        let id = uniqueID.next()!

        observers[id] = observer
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
