import Foundation

// https://cocoawithlove.com/blog/2016/06/02/threads-and-mutexes.html
// http://www.vadimbulavin.com/atomic-properties/
// https://stackoverflow.com/a/47345863/976628
internal protocol Lock {
    func lock()
    func unlock()
}

extension NSRecursiveLock: Lock {}
