//
//  FixedBitWidthType.swift
//  SwiftBigInt
//
//  Created by Tim Wilson-Brown on 30/05/2016.
//  Copyright © 2016 teor.
//  GPL version 3 or later.
//

import BitwiseShiftType

// Surprisingly, the swift standard library doesn't tell you how many bits are in an integer,
// even though it's part of most type names, and the standard libarary has IntegerArithmeticType and BitwiseOperationsType

public protocol FixedBitWidthType {
  // The width of the type, for fixed-width types only

  static var bitWidth: UInt { get }
}

// All integers just need a little nudge to conform to this protocol
extension UIntMax: FixedBitWidthType { static let bitWidth = bitWidthUnsigned() }
extension UInt:    FixedBitWidthType { static let bitWidth = bitWidthUnsigned() }

extension UInt64:  FixedBitWidthType { static let bitWidth = 64 }
extension UInt32:  FixedBitWidthType { static let bitWidth = 32 }
extension UInt16:  FixedBitWidthType { static let bitWidth = 16 }
extension UInt8:   FixedBitWidthType { static let bitWidth =  8 }

extension IntMax:  FixedBitWidthType { static let bitWidth = bitWidthSigned() }
extension Int:     FixedBitWidthType { static let bitWidth = bitWidthSigned() }

extension Int64:   FixedBitWidthType { static let bitWidth = 64 }
extension Int32:   FixedBitWidthType { static let bitWidth = 32 }
extension Int16:   FixedBitWidthType { static let bitWidth = 16 }
extension Int8:    FixedBitWidthType { static let bitWidth =  8 }

// What's the width of the unsigned integer type?
@warn_unused_result
public func bitWidthUnsigned<T: UnsignedIntegerType>() -> UInt {
  let maxT = ~T.allZeros

  switch maxT {
  case UInt64.max:
    return 64
  case UInt32.max:
    return 32
  case UInt16.max:
    return 16
  case UInt8.max:
    return  8
  default:
    return bitWidthBitShift<T>()
  }
}

// What's the width of the signed integer type?
// Assumes Two's complement
@warn_unused_result
public func bitWidthSigned<T: SignedIntegerType>() -> UInt {
  let minT = ~T.allZeros

  switch minT {
  case Int64.min:
    return 64
  case Int32.min:
    return 32
  case Int16.min:
    return 16
  case Int8.min:
    return  8
  default:
    return bitWidthBitShift<T>()
  }
}

// What's the width of the bitwise-shiftable integer type?
@warn_unused_result
public func bitWidthBitShift<T: BitwiseShiftType>() -> UInt {
  // The shifter values are always equal, but only UInt is Comparable
  var shifterUInt = UInt(1)
  var shifterT = T(1)
  var shifteeT = T(1)
  // There's a Builtin.Int2048 in Swift 2
  let maxShiftLimitUInt = UInt(2048)

  while (shifteeT << shifterT) != 0 {
    /* '<<= 1' means '*= 2', T is only guaranteed to have '<<=' */
    shifterT <<= 1
    shifterUInt <<= 1
    if (shifterUInt > maxShiftLimitUInt) {
      // Yeah, it looks like an unlimited bit width type
      return 0
    }
  }

  return shifterUInt
}

