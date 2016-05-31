//
//  IntBoxTests.swift
//  IntBoxTests
//
//  Created by Tim Wilson-Brown on 30/05/2016.
//  Copyright © 2016 teor.
//  GPL version 3 or later.
//
// Unit tests for UIntBox

import XCTest
@testable import IntBox

class IntBoxTests: XCTestCase {

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

    // Overflow wraps?
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

    // Overflow wraps?
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

    // Overflow wraps?
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

  func testArithmeticCompoundAssignment() {
    var a = UIntBox(0)

    a += 1
    XCTAssertEqual(a, 1)

    a *= 5
    XCTAssertEqual(a, 5)

    a -= 1
    XCTAssertEqual(a, 4)

    a /= 2
    XCTAssertEqual(a, 2)

    a += 1
    a %= 2
    XCTAssertEqual(a, 1)
  }

  func testAllZeroes() {
    XCTAssertEqual(UIntBox.allZeros, 0)
  }

  func testAnd() {
    // Same Value
    XCTAssertEqual(UIntBox(1) & UIntBox(1), UIntBox(1))

    // Zero
    XCTAssertEqual(UIntBox(32) & UIntBox.allZeros, UIntBox.allZeros)

    // Distinct Bits
    XCTAssertEqual(UIntBox(2) & UIntBox(4), UIntBox.allZeros)

    // Bitmask
    XCTAssertEqual(UIntBox(15) & UIntBox(8), UIntBox(8))

    // Mismatching Bits
    XCTAssertEqual(UIntBox(5) & UIntBox(22), UIntBox(4))

    // Complement
    XCTAssertEqual(~UIntBox(1) & UIntBox(1), UIntBox.allZeros)
  }

  func testOr() {
    // Same Value
    XCTAssertEqual(UIntBox(1) | UIntBox(1), UIntBox(1))

    // Zero
    XCTAssertEqual(UIntBox(32) | UIntBox.allZeros, UIntBox(32))

    // Distinct Bits
    XCTAssertEqual(UIntBox(2) | UIntBox(4), UIntBox(6))

    // Bitmask
    XCTAssertEqual(UIntBox(15) | UIntBox(8), UIntBox(15))

    // Mismatching Bits
    XCTAssertEqual(UIntBox(5) | UIntBox(22), UIntBox(23))

    // Complement
    XCTAssertEqual(~UIntBox(2) | UIntBox(2), ~UIntBox.allZeros)
  }

  func testXor() {
    // Same Value
    XCTAssertEqual(UIntBox(1) ^ UIntBox(1), UIntBox.allZeros)

    // Zero
    XCTAssertEqual(UIntBox(32) ^ UIntBox.allZeros, UIntBox(32))

    // Distinct Bits
    XCTAssertEqual(UIntBox(2) ^ UIntBox(4), UIntBox(6))

    // Bitmask
    XCTAssertEqual(UIntBox(15) ^ UIntBox(8), UIntBox(7))

    // Mismatching Bits
    XCTAssertEqual(UIntBox(5) ^ UIntBox(22), UIntBox(19))

    // Complement
    XCTAssertEqual(~UIntBox(4) ^ UIntBox(4), ~UIntBox.allZeros)
  }

  func testNot() {
    XCTAssertEqual(~UIntBox(64) & UIntBox(64), UIntBox.allZeros)
    XCTAssertEqual(~UIntBox(128) | UIntBox(128), ~UIntBox.allZeros)
    XCTAssertEqual(~UIntBox(256) ^ UIntBox(256), ~UIntBox.allZeros)

    // All bits is greater than no bits?
    // Apparently
    XCTAssertGreaterThan(~UIntBox.allZeros, UIntBox.allZeros)

    // All bits is the maximum?
    // Apparently
    XCTAssertEqual(~UIntBox(1), UIntBox.max - 1)
    XCTAssertEqual(~UIntBox.allZeros, UIntBox.max)
  }

  func testBitwiseCompoundAssignment() {
    var a = UIntBox(0)

    // the generic bitwise compound assignment operators are @warn_unused_result, but they do not return a result
    // we define a type-specific version to silence this warning
    a |= 1
    XCTAssertEqual(a, 1)

    // the generic bitwise compound assignment operators are @warn_unused_result, but they do not return a result
    // we define a type-specific version to silence this warning
    a &= 5
    XCTAssertEqual(a, 1)

    // the generic bitwise compound assignment operators are @warn_unused_result, but they do not return a result
    // we define a type-specific version to silence this warning
    a ^= 2
    XCTAssertEqual(a, 3)
  }

  func testBitWidth() {
    // UIntBox
    XCTAssertEqual(UIntBox.bitWidth, UIntMax.bitWidth)

    // Standard Integers
    XCTAssertEqual(UIntMax.bitWidth, 64)
    XCTAssertEqual(UInt.bitWidth, 64)
    XCTAssertEqual(UInt64.bitWidth, 64)
    XCTAssertEqual(UInt32.bitWidth, 32)
    XCTAssertEqual(UInt16.bitWidth, 16)
    XCTAssertEqual(UInt8.bitWidth,   8)

    XCTAssertEqual(IntMax.bitWidth, 64)
    XCTAssertEqual(Int.bitWidth, 64)
    XCTAssertEqual(Int64.bitWidth, 64)
    XCTAssertEqual(Int32.bitWidth, 32)
    XCTAssertEqual(Int16.bitWidth, 16)
    XCTAssertEqual(Int8.bitWidth,   8)

    // Unsigned integer bitWidth lookup
    XCTAssertEqual(UInt.bitWidthUnsigned(), UInt.bitWidth)

    XCTAssertEqual(CUnsignedChar.bitWidthUnsigned(), UInt8.bitWidth)
    XCTAssertEqual(CUnsignedShort.bitWidthUnsigned(), UInt16.bitWidth)
    XCTAssertEqual(CUnsignedInt.bitWidthUnsigned(), UInt32.bitWidth)
    XCTAssertEqual(CUnsignedLong.bitWidthUnsigned(), UInt.bitWidth)
    XCTAssertEqual(CUnsignedLongLong.bitWidthUnsigned(), UInt64.bitWidth)

    // Unsigned integer bitWidth calculation from max
    XCTAssertEqual(UInt8.bitWidthFromUnsignedMax(UInt8.max.toUIntMax()),    8)
    XCTAssertEqual(UInt16.bitWidthFromUnsignedMax(UInt16.max.toUIntMax()), 16)
    XCTAssertEqual(UInt32.bitWidthFromUnsignedMax(UInt32.max.toUIntMax()), 32)
    XCTAssertEqual(UInt64.bitWidthFromUnsignedMax(UInt64.max.toUIntMax()), 64)

    XCTAssertEqual(UInt64.bitWidthFromUnsignedMax(1),  1)
    XCTAssertEqual(UInt64.bitWidthFromUnsignedMax(3),  2)
    XCTAssertEqual(UInt64.bitWidthFromUnsignedMax(15), 4)

    XCTAssertEqual(UInt64.bitWidthFromUnsignedMax(UInt8.max.toUIntMax()/2),       8)
    XCTAssertEqual(UInt64.bitWidthFromUnsignedMax(UInt16.max.toUIntMax()/4),     16)
    XCTAssertEqual(UInt64.bitWidthFromUnsignedMax(UInt32.max.toUIntMax()/456),   32)
    XCTAssertEqual(UInt64.bitWidthFromUnsignedMax(UInt64.max.toUIntMax()/10240), 64)
  }

  func testBitwiseRightShift() {
    // Powers of 2
    XCTAssertEqual(UIntBox(7) >> 1, 3)
    XCTAssertEqual(UIntBox(8) >> 2, 2)

    // Zeroes
    XCTAssertEqual(UIntBox(1) >> 0, 1)
    XCTAssertEqual(UIntBox(0) >> 1, 0)
    XCTAssertEqual(UIntBox(0) >> 0, 0)
    XCTAssertEqual(UIntBox(1) >> 1, 0)

    // Shift off end
    XCTAssertEqual(((~UIntBox.allZeros) >> (UIntBox.bitWidth/2)) >> (UIntBox.bitWidth/2), 0)
    // A ridiculously large shiftee
    XCTAssertEqual(UIntBox.max >> (UIntBox.bitWidth/2), 4294967295)

    // fatal error: shift amount is larger than type size in bits
    //XCTAssertEqual(UIntBox(125) >> UIntBox.max, 0)
  }

  func testBitwiseLeftShift() {
    // Powers of 2
    XCTAssertEqual(UIntBox(1) << 1, 2)
    XCTAssertEqual(UIntBox(1) << 4, 16)

    // Zeroes
    XCTAssertEqual(UIntBox(1) << 0, 1)
    XCTAssertEqual(UIntBox(0) << 1, 0)
    XCTAssertEqual(UIntBox(0) << 0, 0)

    // Shift off end
    XCTAssertEqual((UIntBox(1) << (UIntBox.bitWidth/2)) << (UIntBox.bitWidth/2), 0)
    // A ridiculously large shiftee
    XCTAssertEqual(UIntBox.max << (UIntBox.bitWidth/2), 18446744069414584320)

    // fatal error: shift amount is larger than type size in bits
    //XCTAssertEqual(UIntBox(1) << UIntBox.bitWidth, 0)
    //XCTAssertEqual(UIntBox(23) << UIntBox.max, 0)
  }

  func testBitwiseShiftCompoundAssignment() {
    var a = UIntBox(1)

    a <<= 2
    XCTAssertEqual(a, 4)

    a >>= 1
    XCTAssertEqual(a, 2)
  }

  // return the closest representable UIntMax value
  func toUIntMaxSaturatingWithFloat(x: Float) -> UIntMax {
    if x >= Float(UIntMax.max) {
      return UIntMax.max
    }
    if x <= Float(UIntMax.min) {
      return UIntMax.min
    }
    return UIntMax(x)
  }

  // return the closest representable UIntMax value
  func toUIntMaxSaturatingWithDouble(x: Double) -> UIntMax {
    if x >= Double(UIntMax.max) {
      return UIntMax.max
    }
    if x <= Double(UIntMax.min) {
      return UIntMax.min
    }
    return UIntMax(x)
  }

  // return the absolute value of the difference of lhs and rhs
  func absDiff(lhs: UIntMax, _ rhs: UIntMax) -> UIntMax {
    let maxVal = lhs > rhs ? lhs : rhs
    let minVal = lhs <= rhs ? lhs : rhs
    return maxVal - minVal
  }

  // check if pow(lhs, rhs) equals result
  // Uses appropriate accuracy for floating-point calculations
  func powerTest(lhs: UIntMax, _ rhs: UIntMax, result: UIntMax) {

    // Floating point powers are accurate to the limit of precision
    XCTAssertEqual(powf(Float(lhs), Float(rhs)), Float(result))
    XCTAssertEqual(pow(Float(lhs), Float(rhs)), Float(result))
    XCTAssertEqual(Float(lhs) ** Float(rhs), Float(result))
    var tempF = Float(lhs)
    tempF **= Float(rhs)
    XCTAssertEqual(tempF, Float(result))
    // But what if we ask for integer-accuracy?
    let bitWidthF:      UIntMax = 32
    let precisionBitsF: UIntMax = 24
    // Keep the top (24 + 32) bits of result, shifting them into the lowest (24 + 32) bits
    let precisionF: UIntMax = result >> (bitWidthF - precisionBitsF)
    XCTAssertEqualWithAccuracy(Float(absDiff(result, toUIntMaxSaturatingWithFloat(pow(Float(lhs), Float(rhs))))), 0.0, accuracy: Float(precisionF))

    // Floating point powers are accurate to the limit of precision
    XCTAssertEqual(pow(Double(lhs), Double(rhs)), Double(result))
    XCTAssertEqual(Double(lhs) ** Double(rhs), Double(result))
    var tempD = Double(lhs)
    tempD **= Double(rhs)
    XCTAssertEqual(tempD, Double(result))
    // But what if we ask for integer-accuracy?
    let bitWidthD:      UIntMax = 64
    let precisionBitsD: UIntMax = 53
    // Keep the top 53 bits of result, shifting them into the lowest 53 bits
    let precisionD: UIntMax = result >> (bitWidthD - precisionBitsD)
    XCTAssertEqualWithAccuracy(Double(absDiff(result, toUIntMaxSaturatingWithDouble(pow(Double(lhs), Double(rhs))))), 0.0, accuracy: Double(precisionD))

    // Floating point powers are accurate to the limit of precision
    XCTAssertEqual(pow(CGFloat(lhs), CGFloat(rhs)), CGFloat(result))
    XCTAssertEqual(CGFloat(lhs) ** CGFloat(rhs), CGFloat(result))
    var tempC = CGFloat(lhs)
    tempC **= CGFloat(rhs)
    XCTAssertEqual(tempC, CGFloat(result))
    // The CGFloat results should be the same as either the Float or Double results, depending on platform

    // Integer powers
    XCTAssertEqual(pow(lhs, rhs), result)
    XCTAssertEqual(lhs ** rhs, result)
    var tempU = lhs
    tempU **= rhs
    XCTAssertEqual(tempU, result)
    // Will this be too slow for large powers?
    XCTAssertEqual(powIntegerBitwise(lhs, rhs), result)
    XCTAssertEqual(powIntegerIterate(lhs, rhs), result)

    // UIntBox powers
    XCTAssertEqual(pow(UIntBox(lhs), UIntBox(rhs)), UIntBox(result))
    XCTAssertEqual(UIntBox(lhs) ** UIntBox(rhs), UIntBox(result))
    var tempB = UIntBox(lhs)
    tempB **= UIntBox(rhs)
    XCTAssertEqual(tempB, UIntBox(result))
    XCTAssertEqual(powIntegerBitwise(UIntBox(lhs), UIntBox(rhs)), UIntBox(result))
    // Will this be too slow for large powers?
    XCTAssertEqual(powIntegerIterate(UIntBox(lhs), UIntBox(rhs)), UIntBox(result))
    // But what if we ask for integer-accuracy?
    XCTAssertEqual(pow(UIntBox(lhs), UIntBox(rhs)).unboxedValue, result)
  }

  func testPower() {
    // Simple Cases
    powerTest( 2, 3, result:     8)
    powerTest( 5, 2, result:    25)
    powerTest(10, 4, result: 10000)

    // Ones and Zeroes
    powerTest(1, 1, result: 1)
    powerTest(1, 0, result: 1)
    powerTest(0, 1, result: 0)
    // And 0 ** 0 is?
    // 1, apparently
    powerTest(0, 0, result: 1)

    // Zeroes
    powerTest( 2, 0, result: 1)
    powerTest(10, 0, result: 1)

    // Large Numbers
    powerTest(2, 20, result: (1024 * 1024))
    // Float precision is 24
    powerTest(2, 23, result: (1 << 23))
    powerTest(2, 24, result: (1 << 24))
    powerTest(2, 25, result: (1 << 25))
    // Double precision is 53
    powerTest(2, 52, result: (1 << 52))
    powerTest(2, 53, result: (1 << 53))
    powerTest(2, 54, result: (1 << 54))
    // Maxima
    powerTest(2, 63, result: (1 << 63))
    let pow3_4:  UIntMax = 3 * 3 * 3 * 3
    let pow3_13: UIntMax = 3 * pow3_4 * pow3_4 * pow3_4
    let pow3_39: UIntMax = pow3_13 * pow3_13 * pow3_13
    powerTest(3, 39, result: pow3_39)
    powerTest(4, 31, result: (1 << 62))
    let pow5_3:  UIntMax = 5 * 5 * 5
    let pow5_9:  UIntMax = pow5_3 * pow5_3 * pow5_3
    let pow5_27: UIntMax = pow5_9 * pow5_9 * pow5_9
    powerTest(5, 27, result: pow5_27)
    let pow6_4:  UIntMax = 6 * 6 * 6 * 6
    let pow6_8:  UIntMax = pow6_4 * pow6_4
    let pow6_24: UIntMax = pow6_8 * pow6_8 * pow6_8
    powerTest(6, 24, result: pow6_24)
    let pow7_3:  UIntMax = 7 * 7 * 7
    let pow7_7:  UIntMax = 7 * pow7_3 * pow7_3
    let pow7_22: UIntMax = 7 * pow7_7 * pow7_7 * pow7_7
    powerTest(7, 22, result: pow7_22)

    // Large / Small Numbers
    powerTest(UIntMax.max, 0, result: 1)
    powerTest(UIntMax.max, 1, result: UIntMax.max)
    powerTest(0, UIntMax.max, result: 0)
    powerTest(1, UIntMax.max, result: 1)
  }

  func testHashable() {
    XCTAssertEqual(UIntBox(0).hashValue, UIntBox(0).hashValue)

    // It's possible some hash values will collide, so check a few
    if UIntBox(1).hashValue != UIntBox(2).hashValue {
      XCTAssertNotEqual(UIntBox(1), UIntBox(2))
    }

    if UIntBox(3).hashValue != UIntBox(4).hashValue {
      XCTAssertNotEqual(UIntBox(3), UIntBox(4))
    }

    if UIntBox(5).hashValue != UIntBox(6).hashValue {
      XCTAssertNotEqual(UIntBox(5), UIntBox(6))
    }
  }

  func testSuccessor() {
    XCTAssertEqual(UIntBox(0).successor(), 1)
    XCTAssertEqual(UIntBox(1).successor(), 2)
    XCTAssertEqual(UIntBox(3).successor().successor(), 5)

    // Overflow wraps?
    // Apparently
    XCTAssertEqual(UIntBox.max.successor(), 0)
  }
}
