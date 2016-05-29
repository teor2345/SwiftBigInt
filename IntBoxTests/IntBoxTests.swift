//
//  IntBoxTests.swift
//  IntBoxTests
//
//  Created by Tim Wilson-Brown on 30/05/2016.
//  Copyright © 2016 teor. All rights reserved.
//

import XCTest
@testable import IntBox

class IntBoxTests: XCTestCase {
    
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testEqual() {
    let a = UIntBox(value: 0)
    let b = UIntBox(value: 0)
    let c = UIntBox(value: 0)
    // Self-Equivalence
    XCTAssert(a == a)
    XCTAssertEqual(b == b, true)
    XCTAssertNotEqual(c == c, false)
    // Transitivity
    XCTAssert(a == b)
    XCTAssert(b == c)
    XCTAssert(a == c)
  }

  func testNotEqual() {
    let a = UIntBox(value: 1)
    let b = UIntBox(value: 2)

    XCTAssert(a != b)
    XCTAssert(b != a)

    // And for completeness
    XCTAssert(a == a)
    XCTAssert(b == b)
  }

/*
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measureBlock {
      // Put the code you want to measure the time of here.
    }
  }
*/

}
