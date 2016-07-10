//
//  IntBox.swift
//  SwiftBigInt
//
//  Created by Tim Wilson-Brown on 29/05/2016.
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
// A generic class that will box any conforming integer type
// Passes through all operations to the underlying type
// Used for testing purposes, and serves as a template for BigInts

// Implementation Detail: shared protocols required for (U)IntBox values
// We might have just been able to get away with using RawRepresentable,
// but that wouldn't have worked for BigInts
public protocol Integral: IntegerArithmeticType, BitwiseOperationsType, IntegerLiteralConvertible, CustomStringConvertible, CustomDebugStringConvertible /* IntegerArithmeticType, BitwiseOperationsType, IntegerLiteralConvertible, CustomStringConvertible, CustomDebugStringConvertible, RawRepresentable */ {

}


// Extra Protocols specific to this framework
public protocol IntegralExtra: BitwiseShiftType, FixedBitWidthType {
  
}

// Integers must conform to this protocol to be placed in a UIntBox
public protocol UIntegral: Integral, IntegralExtra, Hashable, _Incrementable {
  // I wanted to use _DisallowMixedSignArithmetic, but it has a hidden dependency on _BuiltinIntegerLiteralConvertible via _IntegerType
  // _BuiltinIntegerLiteralConvertible can never be satisfied in user code, because it requires init(Builtin.Int2048), and Builtin is not accessible from user code
}

// Types that can be 'boxed' into a struct
public protocol Boxable {
  // The type that is in the box
  associatedtype UnboxedType
  // The value that is in the box
  var unboxedValue: UnboxedType { get /* set */ }
}

// A type that boxes UIntMax
public struct UIntBox: UIntegral {

  // Boxable
  //
  // The type that is in the box
  public typealias UnboxedType = UIntMax
  // The value that is in the box
  public var unboxedValue: UIntBox.UnboxedType

  // init from UIntBox
  //
  // Create an instance initialized to `value`.
  // This initialiser's value must have an external name, otherwise it conflicts with the IntegerLiteralConvertible initialiser
  // Given the choice, I would prefer to have to prefix UIntBox values with v: (value), than integer literal values with integerLiteral:
  public init(v value: UIntBox) {
    unboxedValue = value.unboxedValue
  }
}

extension UIntBox /* Like UInt64 */ {

  // Create an instance initialized to zero.
  public init() {
    unboxedValue = 0
  }

  // Create an instance initialized to `value`, a builtin 2048-bit signed type
  // Only usable by the swift standard library
  // At some point, we should roll our own equivalent initialiser
  //public init(_builtinIntegerLiteral value: Builtin.Int2048)

  // The maximum possible value that can be stored in a UIntBox
  // max is not relevant for BigInts
  public static var max: UIntBox {
    return UIntBox(UnboxedType.max)
  }

  // The minimum possible value that can be stored in a UIntBox
  // min is not relevant for BigInts
  public static var min: UIntBox {
    return UIntBox(UnboxedType.min)
  }
}

extension UIntBox: IntegerLiteralConvertible {
  /// Conforming types can be initialized with integer literals.

  public typealias IntegerLiteralType = UIntBox.UnboxedType

  /// Create an instance initialized to `value`.
  public init(integerLiteral value: UIntBox.IntegerLiteralType) {
    unboxedValue = value
  }
}

extension UIntBox /* : partial UnsignedIntegerType conformance */ {
  /// A set of common requirements for Swift's unsigned integer types.

  /// Represent this number using Swift's widest native unsigned
  /// integer type.
  @warn_unused_result
  public func toUIntMax() -> UIntMax {
    return unboxedValue
  }

  /// Convert from Swift's widest unsigned integer type, trapping on
  /// overflow.
  public init(_ value: UIntMax) {
    unboxedValue = value
  }
}

extension UIntBox: CustomStringConvertible {
  /// A type with a customized textual representation.

  /// A textual representation of `self`.
  public var description: String {
    return String(unboxedValue)
  }
}

extension UIntBox: CustomDebugStringConvertible {
  /// A type with a customized textual representation suitable for
  /// debugging purposes.

  /// A textual representation of `self`, suitable for debugging.
  public var debugDescription: String {
    let classText = String(UIntBox) + "(" + String(UnboxedType) + ")"
    return classText + ": " + String(reflecting: unboxedValue)
  }
}

// Equatable
//
/// Instances of conforming types can be compared for value equality
/// using operators `==` and `!=`.
///
/// When adopting `Equatable`, only the `==` operator is required to be
/// implemented.  The standard library provides an implementation for `!=`.
///
/// Returns `true` if `lhs` is equal to `rhs`.
///
/// **Equality implies substitutability**.  When `x == y`, `x` and
/// `y` are interchangeable in any code that only depends on their
/// values.
///
/// Class instance identity as distinguished by triple-equals `===`
/// is notably not part of an instance's value.  Exposing other
/// non-value aspects of `Equatable` types is discouraged, and any
/// that *are* exposed should be explicitly pointed out in
/// documentation.
@warn_unused_result
public func ==(lhs: UIntBox, rhs: UIntBox) -> Bool {
  return lhs.unboxedValue == rhs.unboxedValue
}

// Comparable
//
/// Instances of conforming types can be compared using relational
/// operators, which define a [strict total order](http://en.wikipedia.org/wiki/Total_order#Strict_total_order).
///
/// A type conforming to `Comparable` need only supply the `<` and
/// `==` operators; default implementations of `<=`, `>`, `>=`, and
/// `!=` are supplied by the standard library:
@warn_unused_result
public func <(lhs: UIntBox, rhs: UIntBox) -> Bool {
  return lhs.unboxedValue < rhs.unboxedValue
}

extension UIntBox: IntegerArithmeticType {
  /// The common requirements for types that support integer arithmetic.

  /// Explicitly convert to `IntMax`, trapping on overflow (except in
  /// -Ounchecked builds).
  @warn_unused_result
  public func toIntMax() -> IntMax {
    return IntMax(unboxedValue)
  }

  /// Adds `lhs` and `rhs`, returning the result and a `Bool` that is
  /// `true` iff the operation caused an arithmetic overflow.
  @warn_unused_result
  public static func addWithOverflow(lhs: UIntBox, _ rhs: UIntBox) -> (UIntBox, overflow: Bool) {
    let (result, overflow) = UnboxedType.addWithOverflow(lhs.unboxedValue, rhs.unboxedValue)
    // Can we skip the boxing if overflow is true?
    // Does Swift have defined semantics for overflow?
    return (UIntBox(result), overflow)
  }

  /// Subtracts `lhs` and `rhs`, returning the result and a `Bool` that is
  /// `true` iff the operation caused an arithmetic overflow.
  @warn_unused_result
  public static func subtractWithOverflow(lhs: UIntBox, _ rhs: UIntBox) -> (UIntBox, overflow: Bool) {
    let (result, overflow) = UnboxedType.subtractWithOverflow(lhs.unboxedValue, rhs.unboxedValue)
    // Can we skip the boxing if overflow is true?
    // Does Swift have defined semantics for overflow?
    return (UIntBox(result), overflow)
  }

  /// Multiplies `lhs` and `rhs`, returning the result and a `Bool` that is
  /// `true` iff the operation caused an arithmetic overflow.
  @warn_unused_result
  public static func multiplyWithOverflow(lhs: UIntBox, _ rhs: UIntBox) -> (UIntBox, overflow: Bool) {
    let (result, overflow) = UnboxedType.multiplyWithOverflow(lhs.unboxedValue, rhs.unboxedValue)
    // Can we skip the boxing if overflow is true?
    // Does Swift have defined semantics for overflow?
    return (UIntBox(result), overflow)
  }

  /// Divides `lhs` and `rhs`, returning the result and a `Bool` that is
  /// `true` iff the operation caused an arithmetic overflow.
  @warn_unused_result
  public static func divideWithOverflow(lhs: UIntBox, _ rhs: UIntBox) -> (UIntBox, overflow: Bool) {
    let (result, overflow) = UnboxedType.divideWithOverflow(lhs.unboxedValue, rhs.unboxedValue)
    // Can we skip the boxing if overflow is true?
    // Does Swift have defined semantics for overflow?
    return (UIntBox(result), overflow)
  }

  /// Divides `lhs` and `rhs`, returning the remainder and a `Bool` that is
  /// `true` iff the operation caused an arithmetic overflow.
  @warn_unused_result
  public static func remainderWithOverflow(lhs: UIntBox, _ rhs: UIntBox) -> (UIntBox, overflow: Bool) {
    let (result, overflow) = UnboxedType.remainderWithOverflow(lhs.unboxedValue, rhs.unboxedValue)
    // Can we skip the boxing if overflow is true?
    // Does Swift have defined semantics for overflow?
    return (UIntBox(result), overflow)
  }
}

/// Adds `lhs` and `rhs`, returning the result and trapping in case of
/// arithmetic overflow (except in -Ounchecked builds).
@warn_unused_result
public func +(lhs: UIntBox, rhs: UIntBox) -> UIntBox {
  return UIntBox(lhs.unboxedValue + rhs.unboxedValue)
}

/// Subtracts `lhs` and `rhs`, returning the result and trapping in case of
/// arithmetic overflow (except in -Ounchecked builds).
@warn_unused_result
public func -(lhs: UIntBox, rhs: UIntBox) -> UIntBox {
  return UIntBox(lhs.unboxedValue - rhs.unboxedValue)
}

/// Multiplies `lhs` and `rhs`, returning the result and trapping in case of
/// arithmetic overflow (except in -Ounchecked builds).
@warn_unused_result
public func *(lhs: UIntBox, rhs: UIntBox) -> UIntBox {
  return UIntBox(lhs.unboxedValue * rhs.unboxedValue)
}

/// Divides `lhs` and `rhs`, returning the result and trapping in case of
/// arithmetic overflow (except in -Ounchecked builds).
@warn_unused_result
public func /(lhs: UIntBox, rhs: UIntBox) -> UIntBox {
  return UIntBox(lhs.unboxedValue / rhs.unboxedValue)
}

/// Divides `lhs` and `rhs`, returning the remainder and trapping in case of
/// arithmetic overflow (except in -Ounchecked builds).
@warn_unused_result
public func %(lhs: UIntBox, rhs: UIntBox) -> UIntBox {
  return UIntBox(lhs.unboxedValue % rhs.unboxedValue)
}

extension UIntBox: BitwiseOperationsType {
  /// A set type with O(1) standard bitwise operators.
  // O(1) complexity can not be achieved for BigInts.

  /// The empty bitset.
  ///
  /// Also the [identity element](http://en.wikipedia.org/wiki/Identity_element) for `|` and
  /// `^`, and the [fixed point](http://en.wikipedia.org/wiki/Fixed_point_(mathematics)) for
  /// `&`.
  //
  // BigInts have multiple valid representations of the empty bitset.
  public static var allZeros: UIntBox {
    return UIntBox(0)
  }
}

/// Returns the intersection of bits set in `lhs` and `rhs`.
///
/// - Complexity: O(1).
// O(1) complexity can not be achieved for BigInts.
//
// BigInts have multiple valid representations of the intersection of two bitsets.
@warn_unused_result
public func &(lhs: UIntBox, rhs: UIntBox) -> UIntBox {
  return UIntBox(lhs.unboxedValue & rhs.unboxedValue)
}

/// Returns the union of bits set in `lhs` and `rhs`.
///
/// - Complexity: O(1).
// O(1) complexity can not be achieved for BigInts.
//
// BigInts have multiple valid representations of the union of two bitsets.
@warn_unused_result
public func |(lhs: UIntBox, rhs: UIntBox) -> UIntBox {
  return UIntBox(lhs.unboxedValue | rhs.unboxedValue)
}

/// Returns the bits that are set in exactly one of `lhs` and `rhs`.
///
/// - Complexity: O(1).
// O(1) complexity can not be achieved for BigInts.
//
// BigInts have multiple valid representations of the xor of two bitsets.
@warn_unused_result
public func ^(lhs: UIntBox, rhs: UIntBox) -> UIntBox {
  return UIntBox(lhs.unboxedValue ^ rhs.unboxedValue)
}

/// Returns `x ^ ~Self.allZeros`.
///
/// - Complexity: O(1).
// O(1) complexity can not be achieved for BigInts.
//
// BigInts have multiple valid representations of the complement of a bitset.
@warn_unused_result
prefix public func ~(x: UIntBox) -> UIntBox {
  return UIntBox(~x.unboxedValue)
}

// The generic version of this function is @warn_unused_result
// Implement our own to silence warnings
public func &=(inout lhs: UIntBox, rhs: UIntBox) {
  lhs = lhs & rhs
}

// The generic version of this function is @warn_unused_result
// Implement our own to silence warnings
public func |=(inout lhs: UIntBox, rhs: UIntBox) {
  lhs = lhs | rhs
}

// The generic version of this function is @warn_unused_result
// Implement our own to silence warnings
public func ^=(inout lhs: UIntBox, rhs: UIntBox) {
  lhs = lhs ^ rhs
}

// Surprisingly, the swift standard library doesn't have a bitwise shift protocol,
// even though it has IntegerArithmeticType and BitwiseOperationsType
extension UIntBox: BitwiseShiftType {}

@warn_unused_result
public func <<(lhs: UIntBox, rhs: UIntBox) -> UIntBox {
  return UIntBox(lhs.unboxedValue << rhs.unboxedValue)
}

@warn_unused_result
public func >>(lhs: UIntBox, rhs: UIntBox) -> UIntBox {
  return UIntBox(lhs.unboxedValue >> rhs.unboxedValue)
}

@warn_unused_result
public func <<(lhs: UIntBox, rhs: UIntMax) -> UIntBox {
  return UIntBox(lhs.unboxedValue << rhs)
}

@warn_unused_result
public func >>(lhs: UIntBox, rhs: UIntMax) -> UIntBox {
  return UIntBox(lhs.unboxedValue >> rhs)
}

// Surprisingly, the swift standard library doesn't tell you how many bits are in an integer,
// even though it's part of most type names, and the standard libarary has IntegerArithmeticType and BitwiseOperationsType
extension UIntBox: FixedBitWidthType { public static let bitWidth = UnboxedType.bitWidth }

// The Swift standard library doesn't have a power operator, or an integer-accuracy power function
// We use the power operator ** from http://nshipster.com/swift-operators/
extension UIntBox:    PowerType {}

// The power function: calculates lhs to the power of rhs
@warn_unused_result
func **(lhs: UIntBox, rhs: UIntBox) -> UIntBox {
  return pow(lhs, rhs)
}

extension UIntBox: Hashable {
  /// Instances of conforming types provide an integer `hashValue` and
  /// can be used as `Dictionary` keys.

  /// The hash value.
  ///
  /// **Axiom:** `x == y` implies `x.hashValue == y.hashValue`.
  public var hashValue: Int {
    return unboxedValue.hashValue
  }
}

extension UIntBox: _Incrementable {
  /// This protocol is an implementation detail of `ForwardIndexType`; do
  /// not use it directly.
  // Oops!

  /// Returns the next consecutive value in a discrete sequence of
  /// `Self` values.
  ///
  /// - Requires: `self` has a well-defined successor.
  @warn_unused_result
  public func successor() -> UIntBox {
    return UIntBox(self.unboxedValue.successor())
  }
}

// Essential

// Conversion
// IntegerLiteralConvertible: init(IntegerLiteralType), IntegerLiteralType
// CustomStringConvertible: description
// UnsignedIntegerType: toUIntMax, init(UIntMax)
//   Inherit: _DisallowMixedSignArithmetic, IntegerType

// Comparison
// Equatable: == !=
//   Supply: ==
// Comparable: < > <= >=
//   Inherit: Equatable
//   Supply: <

// Arithmetic
// _IntegerArithmeticType: addWithOverflow, subtractWithOverflow, multiplyWithOverflow, divideWithOverflow, remainderWithOverflow
// IntegerArithmeticType: + - (subtraction) * / % toIntMax
//   Inherit: Comparable, _IntegerArithmeticType
//   Supply: all
//   Not Mentioned: compound assignment operators (+= etc), which are automatically supplied

// Bitwise
// BitwiseOperationsType: & | ^ ~ allZeroes
//   Breaks Soft Contract: O(1) operations
//   Not Mentioned: compound assignment operators (|= etc), which are automatically supplied

// Powers
// Integral Powers / Exponents

// Low Priority

// Powers
// Fractional Powers (Roots)
// Integral Logarithms
// Fractional Exponents, Fractional Logarithms

// Set Bit Count

// Conversion
// SignedIntegerType: toIntMax, init(IntMax)
//   Inherit: IntegerType, SignedNumberType

// Signed Arithmetic
// SignedNumberType: - (negation) - (subtraction)
//   Inherit: Comparable, IntegerLiteralConvertible
//   Not mentioned: + (unary plus)

// Array Indexes
// _Incrementable: successor (++ ?)
//   Inherit: Equatable
// ForwardIndexType: Distance, distanceTo, advancedBy
//   Inherit: _Incrementable
// BidirectionalIndexType: predecessor (-- ?)
//   Inherit: ForwardIndexType
// Strideable: Stride, distanceTo, advancedBy
//   Inherit: Comparable
// RandomAccessIndexType: distanceTo, advancedBy
//   Inherit: BidirectionalIndexType, Strideable
//   Breaks Soft Contract: calculate differences in O(1)

// Dictionary Indexes
// Hashable: hashValue
//   Inherit: Equatable

// Will Not Implement

// BooleanType:
// "Expanding this set to include types that represent more than simple boolean values is discouraged."

