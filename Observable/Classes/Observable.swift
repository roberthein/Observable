import Foundation

public struct Observable<T> {
    
    public typealias Observer = (T) -> Void
    private var observers: [(Observer, AnyObject)] = []
    
    public var value: T {
        didSet {
            observers.forEach { $0.0(value) }
        }
    }
    
    public init(_ value: T) {
        self.value = value
    }
    
    public mutating func addObserver(_ object: AnyObject, _ observer: @escaping Observer) {
        removeObserver(object)
        observers.append((observer, object))
        observers.forEach { $0.0(value) }
    }
    
    public mutating func removeObserver(_ object: AnyObject) {
        observers = observers.filter { $0.1 !== object }
    }
    
    public mutating func removeAllObservers() {
        observers.removeAll()
    }
}
