import Foundation

open class Subject<T>: BaseObservable<T> {
    public func update(value: T) {
        lock.lock()
        defer { lock.unlock() }
        _value = value
    }
}
