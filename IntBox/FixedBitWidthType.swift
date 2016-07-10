//
//  FixedBitWidthType.swift
//  SwiftBigInt
//
//  Created by Tim Wilson-Brown on 30/05/2016.
//  Copyright © 2016 teor - gmail: teor2345
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// Surprisingly, the swift standard library doesn't tell you how many bits are in an integer,
// even though it's part of most type names, and the standard libarary has IntegerArithmeticType and BitwiseOperationsType

public protocol FixedBitWidthType {
  // The width of the type, for fixed-width types only

  static var bitWidth: Int { get }
}

// All integers just need a little nudge to conform to this protocol

// The Swift module documentation says UInt is 64 bits, but the documentation says it's 32 bit on 32 bit platforms
extension UInt:    FixedBitWidthType {
  public static let bitWidth = UInt.bitWidthUnsigned()
}
// Redundant, UInt64 conforms
//extension UIntMax: FixedBitWidthType { public static let bitWidth = UIntMax.bitWidthUnsigned() }
extension UInt64:  FixedBitWidthType { public static let bitWidth = 64 }
extension UInt32:  FixedBitWidthType { public static let bitWidth = 32 }
extension UInt16:  FixedBitWidthType { public static let bitWidth = 16 }
extension UInt8:   FixedBitWidthType { public static let bitWidth =  8 }

// The Swift module documentation says Int is 64 bits, but the documentation says it's 32 bit on 32 bit platforms
extension Int:     FixedBitWidthType {
  // UInt and Int are the same size
  public static let bitWidth = UInt.bitWidthUnsigned()
}
// Redundant, Int64 conforms
// UIntMax and IntMax are the same size
//extension IntMax:  FixedBitWidthType { public static let bitWidth = UIntMax.bitWidthUnsigned() }
extension Int64:   FixedBitWidthType { public static let bitWidth = 64 }
extension Int32:   FixedBitWidthType { public static let bitWidth = 32 }
extension Int16:   FixedBitWidthType { public static let bitWidth = 16 }
extension Int8:    FixedBitWidthType { public static let bitWidth =  8 }

// Default implementations that are somewhat superfluous now we give all types set bit widths
extension FixedBitWidthType where Self: UnsignedIntegerType {

  // Provide a default bitWidth implementation
  @warn_unused_result
  public static func bitWidth() -> Int {
    return bitWidthUnsigned()
  }

  // What's the width of an arbitrary unsigned integer type?
  @warn_unused_result
  public static func bitWidthUnsigned() -> Int {
    let maxT = (~Self.allZeros).toUIntMax()

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
  // There seems to be no way to call this only on types that don't match one of the existing bit widths
  @warn_unused_result
  public static func bitWidthFromUnsignedMax(max: UIntMax) -> Int {
    var bitWidth: Int = 1
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
}
