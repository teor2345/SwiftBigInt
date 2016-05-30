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

  func testInitEmpty() {
    let a = UIntBox()

    XCTAssert(a.unboxedValue == 0)
  }

  func testMax() {
    let a = UIntBox.max

    XCTAssert(a.unboxedValue == UIntBox.UnboxedType.max)
  }

  func testMin() {
    let a = UIntBox.min

    XCTAssert(a.unboxedValue == UIntBox.UnboxedType.min)
  }

  func testInitUIntBox() {
    let a = UIntBox()
    let b = UIntBox(a)
    let c = UIntBox(UIntBox.max)
    let d = UIntBox(UIntBox.min)

    XCTAssert(a.unboxedValue == 0)
    XCTAssert(b.unboxedValue == 0)
    XCTAssert(c.unboxedValue == UIntBox.UnboxedType.max)
    XCTAssert(d.unboxedValue == UIntBox.UnboxedType.min)
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

  func testIntegerLiteralConvertible() {
    _ = UIntBox(integerLiteral: 0)
    _ = UIntBox(integerLiteral: 1)
    _ = UIntBox(integerLiteral: 2)
    _ = UIntBox(integerLiteral: 63)
    _ = UIntBox(integerLiteral: 64)
    _ = UIntBox(integerLiteral: 126)
    _ = UIntBox(integerLiteral: 127)
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

  func testToUIntMax() {
    let a = UIntBox(integerLiteral: 24)
    let b = UIntBox(integerLiteral: UIntBox.UnboxedType())
    let c = UIntBox.max

    XCTAssert(a.toUIntMax() == 24)
    XCTAssert(a == 24)

    XCTAssert(b.toUIntMax() == 0)
    XCTAssert(b == 0)

    XCTAssert(c.toUIntMax() == UIntBox.max.unboxedValue)
    XCTAssert(c == UIntBox.max)
  }

  func testToIntMax() {
    let a = UIntBox(integerLiteral: 24)
    let b = UIntBox(integerLiteral: UIntBox.UnboxedType())
    let c = IntMax.max

    XCTAssert(a.toIntMax() == 24)
    XCTAssert(a == 24)

    XCTAssert(b.toIntMax() == 0)
    XCTAssert(b == 0)

    XCTAssert(c.toIntMax() == IntMax.max)
    XCTAssert(c == IntMax.max)
  }

  func testAdd() {
    let a = UIntBox(integerLiteral: 32)
    let b = UIntBox(integerLiteral: 85)
    let c = a + b

    XCTAssert(c == 117)

    // For Completeness
    XCTAssert(a == 32)
    XCTAssert(b == 85)
  }

  func testAddWithOverflow() {
    // No Overflow
    let a = UIntBox(integerLiteral: 32)
    let b = UIntBox(integerLiteral: 85)
    let (c, cOverflow) = UIntBox.addWithOverflow(a, b)

    XCTAssert(c == 117)
    XCTAssertFalse(cOverflow)

    // For Completeness
    XCTAssert(a == 32)
    XCTAssert(b == 85)

    // Overflow
    let d = UIntBox.max
    let (e, eOverflow) = UIntBox.addWithOverflow(d, d)

    // Two's Complement?
    // Apparently
    XCTAssert(e == UIntBox(UIntBox.max - 1))
    XCTAssert(eOverflow)
  }

  func testSubtract() {
    let a = UIntBox(integerLiteral: 32)
    let b = UIntBox(integerLiteral: 85)
    let c = b - a

    XCTAssert(c == 53)

    // For Completeness
    XCTAssert(a == 32)
    XCTAssert(b == 85)
  }

  func testSubtractWithOverflow() {
    let a = UIntBox(integerLiteral: 32)
    let b = UIntBox(integerLiteral: 85)
    let (c, cOverflow) = UIntBox.subtractWithOverflow(b, a)

    XCTAssert(c == 53)
    XCTAssertFalse(cOverflow)

    // For Completeness
    XCTAssert(a == 32)
    XCTAssert(b == 85)

    // Underflow
    let (d, dOverflow) = UIntBox.subtractWithOverflow(a, b)

    // Two's Complement?
    // Apparently
    XCTAssert(d == UIntBox(UIntBox.max - (b - a) + 1))
    XCTAssert(dOverflow)
  }

  func testMultiply() {
    let a = UIntBox(integerLiteral: 6)
    let b = UIntBox(integerLiteral: 7)
    let c = a * b

    XCTAssert(c == 42)

    // For Completeness
    XCTAssert(a == 6)
    XCTAssert(b == 7)
  }

  func testMultiplyWithOverflow() {
    let a = UIntBox(integerLiteral: 6)
    let b = UIntBox(integerLiteral: 7)
    let (c, cOverflow) = UIntBox.multiplyWithOverflow(a, b)

    XCTAssert(c == 42)
    XCTAssertFalse(cOverflow)

    // For Completeness
    XCTAssert(a == 6)
    XCTAssert(b == 7)

    // Overflow
    let d = UIntBox.max
    let (e, eOverflow) = UIntBox.multiplyWithOverflow(a, d)

    // Two's Complement?
    // Apparently
    XCTAssert(e == UIntBox(UIntBox.max - a + 1))
    XCTAssert(eOverflow)
  }

  func testDivide() {
    // Inexact - Round Down
    let a = UIntBox(integerLiteral: 32)
    let b = UIntBox(integerLiteral: 85)
    let c = b / a

    XCTAssert(c == 2)

    // For Completeness
    XCTAssert(a == 32)
    XCTAssert(b == 85)

    // Exact
    let d = UIntBox(integerLiteral: 45)
    let e = UIntBox(integerLiteral: 5)
    let f = d / e

    XCTAssert(f == 9)
  }

  func testDivideWithOverflow() {
    // Inexact - Round Down
    let a = UIntBox(integerLiteral: 32)
    let b = UIntBox(integerLiteral: 85)
    let (c, cOverflow) = UIntBox.divideWithOverflow(b, a)

    XCTAssert(c == 2)
    XCTAssertFalse(cOverflow)

    // For Completeness
    XCTAssert(a == 32)
    XCTAssert(b == 85)

    // Exact
    let d = UIntBox(integerLiteral: 45)
    let e = UIntBox(integerLiteral: 5)
    let (f, fOverflow) = UIntBox.divideWithOverflow(d, e)

    XCTAssert(f == 9)
    XCTAssertFalse(fOverflow)

    // Almost all unsigned divisions do not overflow
    let g = UIntBox.max
    let h = UIntBox(integerLiteral: 1)
    let (i, iOverflow) = UIntBox.divideWithOverflow(g, h)
    let (j, jOverflow) = UIntBox.divideWithOverflow(h, g)

    XCTAssert(i == UIntBox.max)
    XCTAssertFalse(iOverflow)

    XCTAssert(j == 0)
    XCTAssertFalse(jOverflow)

    // Divide by Zero "Overflows"
    let k = UIntBox(integerLiteral: 0)
    let (l, lOverflow) = UIntBox.divideWithOverflow(k, h)
    let (m, mOverflow) = UIntBox.divideWithOverflow(h, k)

    XCTAssert(l == 0)
    XCTAssertFalse(lOverflow)

    // What is 1/0?
    // 0, apparently
    XCTAssert(m == 0)
    XCTAssert(mOverflow)
  }

  func testRemainder() {
    let a = UIntBox(integerLiteral: 32)
    let b = UIntBox(integerLiteral: 85)
    let c = b % a

    XCTAssert(c == 21)

    // For Completeness
    XCTAssert(a == 32)
    XCTAssert(b == 85)
  }

  func testRemainderWithOverflow() {
    let a = UIntBox(integerLiteral: 32)
    let b = UIntBox(integerLiteral: 85)
    let (c, cOverflow) = UIntBox.remainderWithOverflow(b, a)

    XCTAssert(c == 21)
    XCTAssertFalse(cOverflow)

    // For Completeness
    XCTAssert(a == 32)
    XCTAssert(b == 85)

    // Exact
    let d = UIntBox(integerLiteral: 45)
    let e = UIntBox(integerLiteral: 5)
    let (f, fOverflow) = UIntBox.remainderWithOverflow(d, e)

    XCTAssert(f == 0)
    XCTAssertFalse(fOverflow)

    // Almost all unsigned remainders do not overflow
    let g = UIntBox.max
    let h = UIntBox(integerLiteral: 1)
    let (i, iOverflow) = UIntBox.remainderWithOverflow(g, h)
    let (j, jOverflow) = UIntBox.remainderWithOverflow(h, g)

    XCTAssert(i == 0)
    XCTAssertFalse(iOverflow)

    XCTAssert(j == 1)
    XCTAssertFalse(jOverflow)

    // Remainder of Divide by Zero "Overflows"
    let k = UIntBox(integerLiteral: 0)
    let (l, lOverflow) = UIntBox.remainderWithOverflow(k, h)
    let (m, mOverflow) = UIntBox.remainderWithOverflow(h, k)

    XCTAssert(l == 0)
    XCTAssertFalse(lOverflow)

    // What is 1/0?
    // 0 remainder 0, apparently
    XCTAssert(m == 0)
    XCTAssert(mOverflow)
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
