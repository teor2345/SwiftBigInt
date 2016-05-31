//
//  BitwiseShiftType.swift
//  SwiftBigInt
//
//  Created by Tim Wilson-Brown on 30/05/2016.
//  Copyright © 2016 teor.
//  GPL version 3 or later.
//
// Surprisingly, the swift standard library doesn't have a bitwise shift protocol,
// even though it has IntegerArithmeticType and BitwiseOperationsType

public protocol BitwiseShiftType {

  // A bitwise right shift, according to the semantics of the underlying type
  // Unsigned integers, including BigInts, undergo a logical shift
  // Signed integers undergo a shift, but replicate the sign bit to the rightmost bit
  // If we need to, we can define this behavioural difference as an enum on the protocol
  @warn_unused_result
  func >>(lhs: Self, rhs: Self) -> Self

  // A bitwise left shift, according to the semantics of the underlying type
  // All integers, including BigInts, undergo a logical shift
  @warn_unused_result
  func <<(lhs: Self, rhs: Self) -> Self
}

// A generic implementation of bitwise right shift compound assignment
public func >>=<T: BitwiseShiftType>(inout lhs: T, rhs: T) {
  lhs = lhs >> rhs
}

// A generic implementation of bitwise left shift compound assignment
public func <<=<T: BitwiseShiftType>(inout lhs: T, rhs: T) {
  lhs = lhs << rhs
}

// All integers already conform to this protocol
//extension UIntMax: BitwiseShiftType {} - redundant, UInt64 conforms
extension UInt:    BitwiseShiftType {}

extension UInt64:  BitwiseShiftType {}
extension UInt32:  BitwiseShiftType {}
extension UInt16:  BitwiseShiftType {}
extension UInt8:   BitwiseShiftType {}

//extension IntMax:  BitwiseShiftType {} - redundant, Int64 conforms
extension Int:     BitwiseShiftType {}

extension Int64:   BitwiseShiftType {}
extension Int32:   BitwiseShiftType {}
extension Int16:   BitwiseShiftType {}
extension Int8:    BitwiseShiftType {}
