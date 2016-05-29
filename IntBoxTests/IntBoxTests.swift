//
//  IntBoxTests.swift
//  IntBoxTests
//
//  Created by Tim Wilson-Brown on 30/05/2016.
//  Copyright © 2016 teor.
//  GPL version 3 or later.
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

  func testLessThan() {
    let a = UIntBox(value: 4)
    let b = UIntBox(value: 5)
    let c1 = UIntBox(value: 6)
    let c2 = UIntBox(value: 6)

    // Transitivity
    XCTAssert(a < b)
    XCTAssert(b < c1)
    XCTAssert(a < c1)

    // Interchangeability
    XCTAssert(b < c2)

    // Anti-Commutivity
    XCTAssertFalse(b < a)
    XCTAssertFalse(c2 < a)

    // Anti-Reflexivity
    XCTAssertFalse(a < a)
    XCTAssertFalse(b < b)
    XCTAssertFalse(c1 < c1)
    XCTAssertFalse(c2 < c2)

    // Interchangeability
    XCTAssertFalse(c1 < c2)
    XCTAssertFalse(c2 < c1)
  }

  func testLessThanOrEqualTo() {
    let a = UIntBox(value: 7)
    let b = UIntBox(value: 8)
    let c1 = UIntBox(value: 9)
    let c2 = UIntBox(value: 9)

    // Transitivity
    XCTAssert(a <= b)
    XCTAssert(b <= c1)
    XCTAssert(a <= c1)

    // Interchangeability
    XCTAssert(b <= c2)

    // Anti-Commutivity
    XCTAssertFalse(b <= a)
    XCTAssertFalse(c2 <= a)

    // Reflexivity
    XCTAssert(a <= a)
    XCTAssert(b <= b)
    XCTAssert(c1 <= c1)
    XCTAssert(c2 <= c2)

    // Interchangeability
    XCTAssert(c1 <= c2)
    XCTAssert(c2 <= c1)
  }

  func testGreaterThan() {
    let a = UIntBox(value: 31)
    let b = UIntBox(value: 15)
    let c1 = UIntBox(value: 10)
    let c2 = UIntBox(value: 10)

    // Transitivity
    XCTAssert(a > b)
    XCTAssert(b > c1)
    XCTAssert(a > c1)

    // Interchangeability
    XCTAssert(b > c2)

    // Anti-Commutivity
    XCTAssertFalse(b > a)
    XCTAssertFalse(c2 > a)

    // Anti-Reflexivity
    XCTAssertFalse(a > a)
    XCTAssertFalse(b > b)
    XCTAssertFalse(c1 > c1)
    XCTAssertFalse(c2 > c2)

    // Interchangeability
    XCTAssertFalse(c1 > c2)
    XCTAssertFalse(c2 > c1)
  }

  func testGreaterThanOrEqualTo() {
    let a = UIntBox(value: 127)
    let b = UIntBox(value: 84)
    let c1 = UIntBox(value: 53)
    let c2 = UIntBox(value: 53)

    // Transitivity
    XCTAssert(a >= b)
    XCTAssert(b >= c1)
    XCTAssert(a >= c1)

    // Interchangeability
    XCTAssert(b >= c2)

    // Anti-Commutivity
    XCTAssertFalse(b >= a)
    XCTAssertFalse(c2 >= a)

    // Reflexivity
    XCTAssert(a >= a)
    XCTAssert(b >= b)
    XCTAssert(c1 >= c1)
    XCTAssert(c2 >= c2)

    // Interchangeability
    XCTAssert(c1 >= c2)
    XCTAssert(c2 >= c1)
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
