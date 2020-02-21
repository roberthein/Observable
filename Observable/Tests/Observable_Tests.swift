//
//  Observable_Tests.swift
//  Observable.Tests
//
//  Created by Eduardo Domene Junior on 06.01.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import Observable

class Observable_Tests: XCTestCase {
    private var disposal: Disposal!
    
    override func setUp() {
        super.setUp()
        disposal = Disposal()
    }
    
    override func tearDown() {
        disposal = nil
        super.tearDown()
    }
    
    func test_whenSubscribing_shouldEmitCurrentValue() {
        let exp = expectation(description: "")
        let observable = Observable(0)
        var newValueResult: Int?
        
        observable.observe { newValue, _ in
            newValueResult = newValue
            exp.fulfill()
        }.add(to: &disposal)
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(newValueResult, 0)
        XCTAssert(true)
    }
    
    func test_whenSubscribingUsingMainThread_shouldEmitCurrentValue() {
        let exp = expectation(description: "")
        let observable = Observable(0)
        var newValueResult: Int?
        
        observable.observe(.main) { newValue, _ in
            newValueResult = newValue
            exp.fulfill()
        }.add(to: &disposal)
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(newValueResult, 0)
        XCTAssert(true)
    }
    
    func test_whenSubscribingUsingBackgroundThread_shouldEmitCurrentValue() {
        let exp = expectation(description: "")
        let observable = Observable(0)
        var newValueResult: Int?
        
        observable.observe(.global()) { newValue, _ in
            newValueResult = newValue
            exp.fulfill()
        }.add(to: &disposal)
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(newValueResult, 0)
        XCTAssert(true)
    }
    
    func test_whenUpdatingValue_shouldReturnNewValue() {
        let exp = expectation(description: "")
        exp.expectedFulfillmentCount = 2
        let observable = MutableObservable(0)
        var newValueResult: Int?
        
        observable.observe { newValue, _ in
            newValueResult = newValue
            exp.fulfill()
        }.add(to: &disposal)
        
        observable.wrappedValue = 1
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(newValueResult, 1)
        XCTAssert(true)
    }
    
    func test_whenUpdatingValueUsingMainThread_shouldReturnNewValue() {
        let exp = expectation(description: "")
        exp.expectedFulfillmentCount = 2
        let observable = MutableObservable(0)
        var newValueResult: Int?
        
        observable.observe(.main) { newValue, _ in
            newValueResult = newValue
            exp.fulfill()
        }.add(to: &disposal)
        
        observable.wrappedValue = 1
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(newValueResult, 1)
        XCTAssert(true)
    }
    
    func test_whenUpdatingValueUsingBackgroundThread_shouldReturnNewValue() {
        let exp = expectation(description: "")
        exp.expectedFulfillmentCount = 2
        let observable = MutableObservable(0)
        var newValueResult: Int?
        
        observable.observe(.global()) { newValue, _ in
            newValueResult = newValue
            exp.fulfill()
        }.add(to: &disposal)
        
        observable.wrappedValue = 1
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(newValueResult, 1)
        XCTAssert(true)
    }
    
    func test_whenUpdatingValue_shouldReturnOldValue() {
        let exp = expectation(description: "")
        exp.expectedFulfillmentCount = 2
        let observable = MutableObservable(0)
        var oldValueResult: Int?
        
        observable.observe { _, oldValue in
            oldValueResult = oldValue
            exp.fulfill()
        }.add(to: &disposal)
        
        observable.wrappedValue = 1
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(oldValueResult, 0)
        XCTAssert(true)
    }
    
    func test_whenUpdatingValueUsingMainThread_shouldReturnOldValue() {
        let exp = expectation(description: "")
        exp.expectedFulfillmentCount = 2
        let observable = MutableObservable(0)
        var oldValueResult: Int?
        
        observable.observe(.main) { _, oldValue in
            oldValueResult = oldValue
            exp.fulfill()
        }.add(to: &disposal)
        
        observable.wrappedValue = 1
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(oldValueResult, 0)
        XCTAssert(true)
    }
    
    func test_whenUpdatingValueUsingBackgroundThread_shouldReturnOldValue() {
        let exp = expectation(description: "")
        exp.expectedFulfillmentCount = 2
        let observable = MutableObservable(0)
        var oldValueResult: Int?
        
        observable.observe(.global()) { _, oldValue in
            oldValueResult = oldValue
            exp.fulfill()
        }.add(to: &disposal)
        
        observable.wrappedValue = 1
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(oldValueResult, 0)
        XCTAssert(true)
    }
    
    func test_whenUpdatingValueNestedUsingMainThread_shouldSucceed() {
        let exp = expectation(description: "")
        let observable = MutableObservable(0)
        
        observable.observe(.main) { _, _ in
            observable.removeAllObservers()
            observable.wrappedValue = 1
            exp.fulfill()
        }.add(to: &disposal)
        
        wait(for: [exp], timeout: 1.0)
        XCTAssert(true)
    }
    
    func test_whenUpdatingValueNestedUsingBackgroundThread_shouldSucceed() {
        let exp = expectation(description: "")
        let observable = MutableObservable(0)
        
        observable.observe(.global()) { _, _ in
            observable.removeAllObservers()
            observable.wrappedValue = 1
            exp.fulfill()
        }.add(to: &disposal)
        
        wait(for: [exp], timeout: 1.0)
        XCTAssert(true)
    }
    
    func test_whenDisposeDisposal_shouldCallOnDispose() {
        let exp = expectation(description: "")
        let observable = MutableObservable(0) {
            exp.fulfill()
        }

        observable.observe { _, _ in
        
        }.add(to: &disposal)

        observable.wrappedValue = 1
        disposal.dispose()

        wait(for: [exp], timeout: 1.0)
        XCTAssert(true)
    }
    
    func test_whenUpdatingValueFromObserver_shouldNotDeadLock() {
        let exp = expectation(description: "")
        exp.expectedFulfillmentCount = 4
        let observable = MutableObservable(0)
        var lastValueResult: Int?
        
        observable.observe { newValue, _ in
            lastValueResult = newValue
            exp.fulfill()
            if newValue < 3 {
                observable.wrappedValue = newValue + 1
            }
        }.add(to: &disposal)
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(lastValueResult, 3)
        XCTAssert(true)
    }

    // MARK: - Using Singleton
    func test_whenUsingDispatchMain_shouldSucceed() {
        let exp = expectation(description: "")
        let singleton = Singleton.shared
        let callback: (() -> Void) = {
            exp.fulfill()
        }
        var aClass: AClass?
        
        singleton.observable.observe { _, _ in
            singleton.observable.removeAllObservers()
            DispatchQueue.main.async {
                aClass = AClass(callback: callback)
            }
        }.add(to: &disposal)
        
        print(aClass.debugDescription)
        wait(for: [exp], timeout: 1.0)
        XCTAssert(true)
    }
    
    func test_whenPassingDispatchMain_shouldSucceed() {
        let exp = expectation(description: "")
        let singleton = Singleton.shared
        let callback: (() -> Void) = {
            exp.fulfill()
        }
        var aClass: AClass?
        
        singleton.observable.observe(DispatchQueue.main) { _, _ in
            singleton.observable.removeAllObservers()
            aClass = AClass(callback: callback)
        }.add(to: &disposal)
        
        print(aClass.debugDescription)
        wait(for: [exp], timeout: 2.0)
        XCTAssert(true)
    }
    
    func test_whenUsingDispatchGlobal_shouldSucceed() {
        let exp = expectation(description: "")
        let singleton = Singleton.shared
        let callback: (() -> Void) = {
            exp.fulfill()
        }
        var aClass: AClass?
        
        singleton.observable.observe(DispatchQueue.global()) { _, _ in
            singleton.observable.removeAllObservers()
            aClass = AClass(callback: callback)
        }.add(to: &disposal)
        
        print(aClass.debugDescription)
        wait(for: [exp], timeout: 1.0)
        XCTAssert(true)
    }
    
    class AClass {
        var disposal = Disposal()
        
        init(callback: @escaping () -> Void) {
            let singleton = Singleton.shared
            singleton.observable.observe { _, _ in
                callback()
            }.add(to: &disposal)
        }
    }
    
    class Singleton {
        static let shared = Singleton()
        var observable = MutableObservable(0)
        private init() {}
    }
}
