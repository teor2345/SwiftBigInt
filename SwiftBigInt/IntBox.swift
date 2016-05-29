//
//  IntBox.swift
//  SwiftBigInt
//
//  Created by Tim Wilson-Brown on 29/05/2016.
//  Copyright © 2016 teor.
//  GPL version 3 or later.
//
// A generic class that will box any conforming integer type
// Passes through all operations to the underlying type
// Used for testing purposes

// Implementation Detail: shared protocols required for (U)IntBox values
public protocol _IntegerBoxable: Equatable /* IntegerArithmeticType, BitwiseOperationsType, IntegerLiteralConvertible, CustomStringConvertible */ {

}

// Integers must conform to this protocol to be placed in a UIntBox
public protocol UIntBoxable: _IntegerBoxable /*, _DisallowMixedSignArithmetic */ {

}

// Boxable Types
public protocol Boxable {
  associatedtype BoxedType
  var value: BoxedType { get /* set */ }
}

public struct UIntBox: UIntBoxable, Boxable {
  public var value: UIntMax
}

@warn_unused_result
public func ==(lhs: UIntBox, rhs: UIntBox) -> Bool {
  return lhs.value == rhs.value
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
//   Supply: toIntMax, or perhaps all

// Bitwise
// BitwiseOperationsType: & | ^ ~ allZeroes
//   Breaks Soft Contract: O(1) operations

// Powers
// Integral Powers
// Integral Exponents

// Low Priority

// Powers
// Fractional Powers (Roots)
// Integral Logarithms
// Fractional Exponents, Fractional Logarithms

// Conversion
// SignedIntegerType: toIntMax, init(IntMax)
//   Inherit: IntegerType, SignedNumberType

// Signed Arithmetic
// SignedNumberType: - (negation) - (subtraction)
//   Inherit: Comparable, IntegerLiteralConvertible

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

