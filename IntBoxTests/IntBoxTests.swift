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

  func testBoxable() {
    let a = UIntBox(integerLiteral: 7)
    let b = UIntBox(integerLiteral: 58)
    let c = UIntBox(integerLiteral: 96)

    XCTAssert(a.unboxedValue == 7)
    XCTAssert(b.unboxedValue == 58)
    XCTAssert(c.unboxedValue == 96)

    let a2 = UIntBox(integerLiteral: a.unboxedValue)

    XCTAssert(a2.unboxedValue == 7)

    var a3 = UIntBox(integerLiteral: 0)

    a3 = UIntBox(integerLiteral: a.unboxedValue)
    XCTAssert(a3.unboxedValue == 7)

    a3 = a2
    XCTAssert(a3.unboxedValue == 7)

    // For completeness
    XCTAssert(a.unboxedValue == 7)
    XCTAssert(a2.unboxedValue == 7)
    XCTAssert(a3.unboxedValue == 7)
  }

  func testCustomStringConvertible() {
    let a = UIntBox(integerLiteral: 0)
    let b = UIntBox(integerLiteral: 37)
    let c = UIntBox(integerLiteral: 104)

    let aStr = String(a)
    let bStr = String(b)
    let cStr = String(c)

    XCTAssertFalse(aStr.isEmpty)
    XCTAssertFalse(bStr.isEmpty)
    XCTAssertFalse(cStr.isEmpty)

    // We expect each string to contain the unboxed value
    // (Even if there aren't many other constraints we can test)
    XCTAssert(aStr.containsString(String(a.unboxedValue)))
    XCTAssert(bStr.containsString(String(b.unboxedValue)))
    XCTAssert(cStr.containsString(String(c.unboxedValue)))

    // Testing by inspection
    print(a.unboxedValue, "boxed string:", aStr)
    print(b.unboxedValue, "boxed string:", bStr)
    print(c.unboxedValue, "boxed string:", cStr)
  }

  func testCustomDebugStringConvertible() {
    let a = UIntBox(integerLiteral: 4)
    let b = UIntBox(integerLiteral: 73)
    let c = UIntBox(integerLiteral: 112)

    let aDebugStr = String(reflecting: a)
    let bDebugStr = String(reflecting: b)
    let cDebugStr = String(reflecting: c)

    XCTAssertFalse(aDebugStr.isEmpty)
    XCTAssertFalse(bDebugStr.isEmpty)
    XCTAssertFalse(cDebugStr.isEmpty)

    // We expect each string to contain the unboxed value
    // (Even if there aren't many other constraints we can test)
    XCTAssert(aDebugStr.containsString(String(a.unboxedValue)))
    XCTAssert(bDebugStr.containsString(String(b.unboxedValue)))
    XCTAssert(cDebugStr.containsString(String(c.unboxedValue)))

    // Testing by inspection
    print(a.unboxedValue, "boxed debug string:", aDebugStr)
    print(b.unboxedValue, "boxed debug string:", bDebugStr)
    print(c.unboxedValue, "boxed debug string:", cDebugStr)
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
    let c = UIntBox(integerLiteral: 6)
    let c2 = UIntBox(integerLiteral: 6)

    // Transitivity
    XCTAssert(a < b)
    XCTAssert(b < c)
    XCTAssert(a < c)

    // Interchangeability
    XCTAssert(b < c2)

    // Anti-Commutivity
    XCTAssertFalse(b < a)
    XCTAssertFalse(c2 < a)

    // Anti-Reflexivity
    XCTAssertFalse(a < a)
    XCTAssertFalse(b < b)
    XCTAssertFalse(c < c)
    XCTAssertFalse(c2 < c2)

    // Interchangeability
    XCTAssertFalse(c < c2)
    XCTAssertFalse(c2 < c)
  }

  func testLessThanOrEqualTo() {
    let a = UIntBox(integerLiteral: 7)
    let b = UIntBox(integerLiteral: 8)
    let c = UIntBox(integerLiteral: 9)
    let c2 = UIntBox(integerLiteral: 9)

    // Transitivity
    XCTAssert(a <= b)
    XCTAssert(b <= c)
    XCTAssert(a <= c)

    // Interchangeability
    XCTAssert(b <= c2)

    // Anti-Commutivity
    XCTAssertFalse(b <= a)
    XCTAssertFalse(c2 <= a)

    // Reflexivity
    XCTAssert(a <= a)
    XCTAssert(b <= b)
    XCTAssert(c <= c)
    XCTAssert(c2 <= c2)

    // Interchangeability
    XCTAssert(c <= c2)
    XCTAssert(c2 <= c)
  }

  func testGreaterThan() {
    let a = UIntBox(integerLiteral: 31)
    let b = UIntBox(integerLiteral: 15)
    let c = UIntBox(integerLiteral: 10)
    let c2 = UIntBox(integerLiteral: 10)

    // Transitivity
    XCTAssert(a > b)
    XCTAssert(b > c)
    XCTAssert(a > c)

    // Interchangeability
    XCTAssert(b > c2)

    // Anti-Commutivity
    XCTAssertFalse(b > a)
    XCTAssertFalse(c2 > a)

    // Anti-Reflexivity
    XCTAssertFalse(a > a)
    XCTAssertFalse(b > b)
    XCTAssertFalse(c > c)
    XCTAssertFalse(c2 > c2)

    // Interchangeability
    XCTAssertFalse(c > c2)
    XCTAssertFalse(c2 > c)
  }

  func testGreaterThanOrEqualTo() {
    let a = UIntBox(integerLiteral: 127)
    let b = UIntBox(integerLiteral: 84)
    let c = UIntBox(integerLiteral: 53)
    let c2 = UIntBox(integerLiteral: 53)

    // Transitivity
    XCTAssert(a >= b)
    XCTAssert(b >= c)
    XCTAssert(a >= c)

    // Interchangeability
    XCTAssert(b >= c2)

    // Anti-Commutivity
    XCTAssertFalse(b >= a)
    XCTAssertFalse(c2 >= a)

    // Reflexivity
    XCTAssert(a >= a)
    XCTAssert(b >= b)
    XCTAssert(c >= c)
    XCTAssert(c2 >= c2)

    // Interchangeability
    XCTAssert(c >= c2)
    XCTAssert(c2 >= c)
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
