//
//  FixedBitWidthType.swift
//  SwiftBigInt
//
//  Created by Tim Wilson-Brown on 30/05/2016.
//  Copyright © 2016 teor.
//  GPL version 3 or later.
//

// Surprisingly, the swift standard library doesn't tell you how many bits are in an integer,
// even though it's part of most type names, and the standard libarary has IntegerArithmeticType and BitwiseOperationsType

public protocol FixedBitWidthType {
  // The width of the type, for fixed-width types only

  static var bitWidth: UIntMax { get }
}

// All integers just need a little nudge to conform to this protocol
//extension UIntMax: FixedBitWidthType { public static let bitWidth = bitWidthUnsigned(UIntMax()) } - redundant, UInt64 conforms
// Swift says UInt is 64 bits
extension UInt:    FixedBitWidthType { public static let bitWidth: UIntMax = 64 }

extension UInt64:  FixedBitWidthType { public static let bitWidth: UIntMax = 64 }
extension UInt32:  FixedBitWidthType { public static let bitWidth: UIntMax = 32 }
extension UInt16:  FixedBitWidthType { public static let bitWidth: UIntMax = 16 }
extension UInt8:   FixedBitWidthType { public static let bitWidth: UIntMax =  8 }

//extension IntMax:  FixedBitWidthType { public static let bitWidth = bitWidthUnsigned(IntMax.) } - redundant, Int64 conforms
// Swift says Int is 64 bits
extension Int:     FixedBitWidthType { public static let bitWidth: UIntMax = 64 }

extension Int64:   FixedBitWidthType { public static let bitWidth: UIntMax = 64 }
extension Int32:   FixedBitWidthType { public static let bitWidth: UIntMax = 32 }
extension Int16:   FixedBitWidthType { public static let bitWidth: UIntMax = 16 }
extension Int8:    FixedBitWidthType { public static let bitWidth: UIntMax =  8 }

// Utility functions that are somewhat superfluous now we give all types set bit widths

// What's the width of an arbitrary unsigned integer type?
@warn_unused_result
public func bitWidthUnsigned<T: UnsignedIntegerType>(dummy: T) -> UIntMax {
  let maxT = (~T.allZeros).toUIntMax()

  switch maxT {
  case UInt64.max.toUIntMax():
    return 64
  case UInt32.max.toUIntMax():
    return 32
  case UInt16.max.toUIntMax():
    return 16
  case UInt8.max.toUIntMax():
    return  8
  default:
    // Calculate
    return bitWidthFromUnsignedMax(maxT)
  }
}

// What's the width of an unsigned integer type with this maximum?
// Rounds up bitWidth to the nearest power of two
@warn_unused_result
public func bitWidthFromUnsignedMax(max: UIntMax) -> UIntMax {
  var bitWidth: UIntMax = 1
  var divisor: UIntMax = 2

  // short-circuit one bit holds maximum one
  if max == 1 {
    return 1
  }

  // Don't ever square divisor so much it overflows
  while (max / divisor) / divisor > 0 {
    // square the divisor
    divisor = divisor * divisor
    // double the bit width
    bitWidth = bitWidth * 2
  }

  return bitWidth * 2
}
