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

  func testIntegerLiteralConvertible() {
    _ = UIntBox(integerLiteral: 0)
    _ = UIntBox(integerLiteral: 1)
    _ = UIntBox(integerLiteral: 2)
    _ = UIntBox(integerLiteral: 63)
    _ = UIntBox(integerLiteral: 64)
    _ = UIntBox(integerLiteral: 126)
    _ = UIntBox(integerLiteral: 127)
  }

  func testEqual() {
    let a = UIntBox(integerLiteral: 0)
    let b = UIntBox(integerLiteral: 0)
    let c = UIntBox(integerLiteral: 0)

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
    let a = UIntBox(integerLiteral: 1)
    let b = UIntBox(integerLiteral: 2)

    XCTAssert(a != b)
    XCTAssert(b != a)

    // And for completeness
    XCTAssert(a == a)
    XCTAssert(b == b)
  }

  func testLessThan() {
    let a = UIntBox(integerLiteral: 4)
    let b = UIntBox(integerLiteral: 5)
    let c1 = UIntBox(integerLiteral: 6)
    let c2 = UIntBox(integerLiteral: 6)

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
    let a = UIntBox(integerLiteral: 7)
    let b = UIntBox(integerLiteral: 8)
    let c1 = UIntBox(integerLiteral: 9)
    let c2 = UIntBox(integerLiteral: 9)

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
    let a = UIntBox(integerLiteral: 31)
    let b = UIntBox(integerLiteral: 15)
    let c1 = UIntBox(integerLiteral: 10)
    let c2 = UIntBox(integerLiteral: 10)

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
    let a = UIntBox(integerLiteral: 127)
    let b = UIntBox(integerLiteral: 84)
    let c1 = UIntBox(integerLiteral: 53)
    let c2 = UIntBox(integerLiteral: 53)

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
