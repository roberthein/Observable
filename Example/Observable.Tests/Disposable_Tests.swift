//
//  Disposable_Tests.swift
//  
//
//  Created by Bruno Coelho on 12/01/2020.
//

import XCTest
import Observable

class Disposable_Tests: XCTestCase {
    private var disposal: Disposal!
    
    override func setUp() {
        super.setUp()
        disposal = Disposal()
    }
    
    override func tearDown() {
        disposal = nil
        super.tearDown()
    }
    
    func test_whenSubscribing_shouldEmitOnlyTheFirstValue() {
        let exp = expectation(description: "")
        let observable = MutableObservable(0)
        var lastEmmitedValue: Int?
        
        observable.observe { newValue, _ in
            lastEmmitedValue = newValue
            exp.fulfill()
        }.add(to: &disposal)
        
        disposal.dispose()
        observable.wrappedValue = 1
        observable.wrappedValue = 2
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(lastEmmitedValue, 0)
        XCTAssert(true)
    }
    
    func test_whenSubscribingUsingMainThread_shouldEmitOnlyTheFirstValue() {
        let exp = expectation(description: "")
        let observable = MutableObservable(0)
        var lastEmmitedValue: Int?
        
        observable.observe(.main) { newValue, _ in
            lastEmmitedValue = newValue
            exp.fulfill()
        }.add(to: &disposal)
        
        disposal.dispose()
        observable.wrappedValue = 1
        observable.wrappedValue = 2
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(lastEmmitedValue, 0)
        XCTAssert(true)
    }
    
    func test_whenSubscribingUsingBackgroundThread_shouldEmitOnlyTheFirstValue() {
        let exp = expectation(description: "")
        let observable = MutableObservable(0)
        var lastEmmitedValue: Int?
        
        observable.observe(.global()) { newValue, _ in
            lastEmmitedValue = newValue
            exp.fulfill()
        }.add(to: &disposal)
        
        disposal.dispose()
        observable.wrappedValue = 1
        observable.wrappedValue = 2
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(lastEmmitedValue, 0)
        XCTAssert(true)
    }
    
    func test_whenSubscribing_shouldEmitTwoValues() {
        let exp = expectation(description: "")
        exp.expectedFulfillmentCount = 2
        let observable = MutableObservable(0)
        var lastEmmitedValue: Int?
        
        observable.observe { newValue, _ in
            lastEmmitedValue = newValue
            exp.fulfill()
        }.add(to: &disposal)
        
        observable.wrappedValue = 1
        disposal.dispose()
        observable.wrappedValue = 2
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(lastEmmitedValue, 1)
        XCTAssert(true)
    }
    
    func test_whenSubscribingUsingMainThread_shouldEmitTwoValues() {
        let exp = expectation(description: "")
        exp.expectedFulfillmentCount = 2
        let observable = MutableObservable(0)
        var lastEmmitedValue: Int?
        
        observable.observe(.main) { newValue, _ in
            lastEmmitedValue = newValue
            exp.fulfill()
        }.add(to: &disposal)
        
        observable.wrappedValue = 1
        disposal.dispose()
        observable.wrappedValue = 2
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(lastEmmitedValue, 1)
        XCTAssert(true)
    }
    
    func test_whenSubscribingUsingBackgroundThread_shouldEmitTwoValues() {
        let exp = expectation(description: "")
        exp.expectedFulfillmentCount = 2
        let observable = MutableObservable(0)
        var lastEmmitedValue: Int?
        
        observable.observe(.global()) { newValue, _ in
            lastEmmitedValue = newValue
            exp.fulfill()
        }.add(to: &disposal)
        
        observable.wrappedValue = 1
        disposal.dispose()
        observable.wrappedValue = 2
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(lastEmmitedValue, 1)
        XCTAssert(true)
    }
}
