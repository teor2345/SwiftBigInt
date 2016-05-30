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

    XCTAssertEqual(a.unboxedValue, 0)
  }

  func testMax() {
    let a = UIntBox.max

    XCTAssertEqual(a.unboxedValue, UIntBox.UnboxedType.max)
  }

  func testMin() {
    let a = UIntBox.min

    XCTAssertEqual(a.unboxedValue, UIntBox.UnboxedType.min)
  }

  func testInitUIntBox() {
    let a = UIntBox()
    let b = UIntBox(v: a)
    let c = UIntBox(v: UIntBox.max)
    let d = UIntBox(v: UIntBox.min)

    XCTAssertEqual(a.unboxedValue, 0)
    XCTAssertEqual(b.unboxedValue, 0)
    XCTAssertEqual(c.unboxedValue, UIntBox.UnboxedType.max)
    XCTAssertEqual(d.unboxedValue, UIntBox.UnboxedType.min)
  }

  func testBoxable() {
    let a = UIntBox(7)
    let b = UIntBox(58)
    let c = UIntBox(96)

    XCTAssertEqual(a.unboxedValue, 7)
    XCTAssertEqual(b.unboxedValue, 58)
    XCTAssertEqual(c.unboxedValue, 96)

    let a2 = UIntBox(a.unboxedValue)

    XCTAssertEqual(a2.unboxedValue, 7)

    var a3 = UIntBox(0)

    a3 = UIntBox(a.unboxedValue)
    XCTAssertEqual(a3.unboxedValue, 7)

    a3 = a2
    XCTAssertEqual(a3.unboxedValue, 7)

    // For completeness
    XCTAssertEqual(a.unboxedValue, 7)
    XCTAssertEqual(a2.unboxedValue, 7)
    XCTAssertEqual(a3.unboxedValue, 7)
  }

  func testIntegerLiteralConvertible() {
    _ = UIntBox(0)
    _ = UIntBox(1)
    _ = UIntBox(2)
    _ = UIntBox(63)
    _ = UIntBox(64)
    _ = UIntBox(126)
    _ = UIntBox(127)
  }

  func testCustomStringConvertible() {
    let a = UIntBox(0)
    let b = UIntBox(37)
    let c = UIntBox(104)

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
    let a = UIntBox(4)
    let b = UIntBox(73)
    let c = UIntBox(112)

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
    let a = UIntBox(0)
    let b = UIntBox(0)
    let c = UIntBox(0)

    // Self-Equivalence
    XCTAssert(a == a)
    XCTAssert(b == b)
    XCTAssert(c == c)

    // Transitivity
    XCTAssert(a == b)
    XCTAssert(b == c)
    XCTAssert(a == c)
  }

  func testNotEqual() {
    let a = UIntBox(1)
    let b = UIntBox(2)

    XCTAssert(a != b)
    XCTAssert(b != a)

    // And for completeness
    XCTAssert(a == a)
    XCTAssert(b == b)
  }

  func testLessThan() {
    let a = UIntBox(4)
    let b = UIntBox(5)
    let c = UIntBox(6)
    let c2 = UIntBox(6)

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
    let a = UIntBox(7)
    let b = UIntBox(8)
    let c = UIntBox(9)
    let c2 = UIntBox(9)

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
    let a = UIntBox(31)
    let b = UIntBox(15)
    let c = UIntBox(10)
    let c2 = UIntBox(10)

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
    let a = UIntBox(127)
    let b = UIntBox(84)
    let c = UIntBox(53)
    let c2 = UIntBox(53)

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
    let a = UIntBox(24)
    let b = UIntBox(UIntBox.UnboxedType())
    let c = UIntBox.max

    XCTAssertEqual(a.toUIntMax(), 24)
    XCTAssertEqual(a, 24)

    XCTAssertEqual(b.toUIntMax(), 0)
    XCTAssertEqual(b, 0)

    XCTAssertEqual(c.toUIntMax(), UIntBox.max.unboxedValue)
    XCTAssertEqual(c, UIntBox.max)
  }

  func testToIntMax() {
    let a = UIntBox(24)
    let b = UIntBox(UIntBox.UnboxedType())
    let c = IntMax.max

    XCTAssertEqual(a.toIntMax(), 24)
    XCTAssertEqual(a, 24)

    XCTAssertEqual(b.toIntMax(), 0)
    XCTAssertEqual(b, 0)

    XCTAssertEqual(c.toIntMax(), IntMax.max)
    XCTAssertEqual(c, IntMax.max)
  }

  func testAdd() {
    let a = UIntBox(32)
    let b = UIntBox(85)
    let c = a + b

    XCTAssertEqual(c, 117)

    // For Completeness
    XCTAssertEqual(a, 32)
    XCTAssertEqual(b, 85)
  }

  func testAddWithOverflow() {
    // No Overflow
    let a = UIntBox(32)
    let b = UIntBox(85)
    let (c, cOverflow) = UIntBox.addWithOverflow(a, b)

    XCTAssertEqual(c, 117)
    XCTAssertFalse(cOverflow)

    // For Completeness
    XCTAssertEqual(a, 32)
    XCTAssertEqual(b, 85)

    // Overflow
    let d = UIntBox.max
    let (e, eOverflow) = UIntBox.addWithOverflow(d, d)

    // Two's Complement?
    // Apparently
    XCTAssertEqual(e, UIntBox(v: (UIntBox.max - 1)))
    XCTAssert(eOverflow)
  }

  func testSubtract() {
    let a = UIntBox(32)
    let b = UIntBox(85)
    let c = b - a

    XCTAssertEqual(c, 53)

    // For Completeness
    XCTAssertEqual(a, 32)
    XCTAssertEqual(b, 85)
  }

  func testSubtractWithOverflow() {
    let a = UIntBox(32)
    let b = UIntBox(85)
    let (c, cOverflow) = UIntBox.subtractWithOverflow(b, a)

    XCTAssertEqual(c, 53)
    XCTAssertFalse(cOverflow)

    // For Completeness
    XCTAssertEqual(a, 32)
    XCTAssertEqual(b, 85)

    // Underflow
    let (d, dOverflow) = UIntBox.subtractWithOverflow(a, b)

    // Two's Complement?
    // Apparently
    XCTAssertEqual(d, UIntBox(v: (UIntBox.max - (b - a) + 1)))
    XCTAssert(dOverflow)
  }

  func testMultiply() {
    let a = UIntBox(6)
    let b = UIntBox(7)
    let c = a * b

    XCTAssertEqual(c, 42)

    // For Completeness
    XCTAssertEqual(a, 6)
    XCTAssertEqual(b, 7)
  }

  func testMultiplyWithOverflow() {
    let a = UIntBox(6)
    let b = UIntBox(7)
    let (c, cOverflow) = UIntBox.multiplyWithOverflow(a, b)

    XCTAssertEqual(c, 42)
    XCTAssertFalse(cOverflow)

    // For Completeness
    XCTAssertEqual(a, 6)
    XCTAssertEqual(b, 7)

    // Overflow
    let d = UIntBox.max
    let (e, eOverflow) = UIntBox.multiplyWithOverflow(a, d)

    // Two's Complement?
    // Apparently
    XCTAssertEqual(e, UIntBox(v: (UIntBox.max - a + 1)))
    XCTAssert(eOverflow)
  }

  func testDivide() {
    // Inexact - Round Down
    let a = UIntBox(32)
    let b = UIntBox(85)
    let c = b / a

    XCTAssertEqual(c, 2)

    // For Completeness
    XCTAssertEqual(a, 32)
    XCTAssertEqual(b, 85)

    // Exact
    let d = UIntBox(45)
    let e = UIntBox(5)
    let f = d / e

    XCTAssertEqual(f, 9)
  }

  func testDivideWithOverflow() {
    // Inexact - Round Down
    let a = UIntBox(32)
    let b = UIntBox(85)
    let (c, cOverflow) = UIntBox.divideWithOverflow(b, a)

    XCTAssertEqual(c, 2)
    XCTAssertFalse(cOverflow)

    // For Completeness
    XCTAssertEqual(a, 32)
    XCTAssertEqual(b, 85)

    // Exact
    let d = UIntBox(45)
    let e = UIntBox(5)
    let (f, fOverflow) = UIntBox.divideWithOverflow(d, e)

    XCTAssertEqual(f, 9)
    XCTAssertFalse(fOverflow)

    // Almost all unsigned divisions do not overflow
    let g = UIntBox.max
    let h = UIntBox(1)
    let (i, iOverflow) = UIntBox.divideWithOverflow(g, h)
    let (j, jOverflow) = UIntBox.divideWithOverflow(h, g)

    XCTAssertEqual(i, UIntBox.max)
    XCTAssertFalse(iOverflow)

    XCTAssertEqual(j, 0)
    XCTAssertFalse(jOverflow)

    // Divide by Zero "Overflows"
    let k = UIntBox(0)
    let (l, lOverflow) = UIntBox.divideWithOverflow(k, h)
    let (m, mOverflow) = UIntBox.divideWithOverflow(h, k)

    XCTAssertEqual(l, 0)
    XCTAssertFalse(lOverflow)

    // What is 1/0?
    // 0, apparently
    XCTAssertEqual(m, 0)
    XCTAssert(mOverflow)
  }

  func testRemainder() {
    let a = UIntBox(32)
    let b = UIntBox(85)
    let c = b % a

    XCTAssertEqual(c, 21)

    // For Completeness
    XCTAssertEqual(a, 32)
    XCTAssertEqual(b, 85)
  }

  func testRemainderWithOverflow() {
    let a = UIntBox(32)
    let b = UIntBox(85)
    let (c, cOverflow) = UIntBox.remainderWithOverflow(b, a)

    XCTAssertEqual(c, 21)
    XCTAssertFalse(cOverflow)

    // For Completeness
    XCTAssertEqual(a, 32)
    XCTAssertEqual(b, 85)

    // Exact
    let d = UIntBox(45)
    let e = UIntBox(5)
    let (f, fOverflow) = UIntBox.remainderWithOverflow(d, e)

    XCTAssertEqual(f, 0)
    XCTAssertFalse(fOverflow)

    // Almost all unsigned remainders do not overflow
    let g = UIntBox.max
    let h = UIntBox(1)
    let (i, iOverflow) = UIntBox.remainderWithOverflow(g, h)
    let (j, jOverflow) = UIntBox.remainderWithOverflow(h, g)

    XCTAssertEqual(i, 0)
    XCTAssertFalse(iOverflow)

    XCTAssertEqual(j, 1)
    XCTAssertFalse(jOverflow)

    // Remainder of Divide by Zero "Overflows"
    let k = UIntBox(0)
    let (l, lOverflow) = UIntBox.remainderWithOverflow(k, h)
    let (m, mOverflow) = UIntBox.remainderWithOverflow(h, k)

    XCTAssertEqual(l, 0)
    XCTAssertFalse(lOverflow)

    // What is 1/0?
    // 0 remainder 0, apparently
    XCTAssertEqual(m, 0)
    XCTAssert(mOverflow)
  }
}
