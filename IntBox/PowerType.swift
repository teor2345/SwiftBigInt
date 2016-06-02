//
//  PowerType.swift
//  SwiftBigInt
//
//  Created by Tim Wilson-Brown on 31/05/2016.
//  Copyright © 2016 teor.
//  GPL version 3 or later.
//
// The Swift standard library doesn't have a power operator, or an integer-accuracy power function
// We use the power operator ** from http://nshipster.com/swift-operators/
// which is also the operator in Python and other languages

// The same precedence as << and >> for exponential bitshifts
infix operator ** { associativity left precedence 160 }
// The same precedence as other compound assignments
infix operator **= { associativity right precedence 90 }

// A protocol for types that implement the power operator "**"
protocol PowerType {

  // The power function: calculates lhs to the power of rhs
  @warn_unused_result
  func **(lhs: Self, rhs: Self) -> Self
}

// A generic implementation of power compound assignment based on the power operator "**"
func **=<T: PowerType> (inout lhs: T, rhs: T) {
  lhs = lhs ** rhs
}

// Float, Double, and CGFloat already have a global pow function

extension Float: PowerType {}

// The power function: calculates lhs to the power of rhs
@warn_unused_result
func **(lhs: Float, rhs: Float) -> Float {
  return powf(lhs, rhs)
}

extension Double: PowerType {}

// The power function: calculates lhs to the power of rhs
@warn_unused_result
func **(lhs: Double, rhs: Double) -> Double {
  return pow(lhs, rhs)
}

extension CGFloat: PowerType {}

// The power function: calculates lhs to the power of rhs
@warn_unused_result
func **(lhs: CGFloat, rhs: CGFloat) -> CGFloat {
  return pow(lhs, rhs)
}

// A type with exp and log functions, and a multiply "*" operator
// Should only be used on floating-point types for accuracy reasons, but doesn't strictly require them
// We need Exponentable to be IntegerLiteralConvertible so we can use a generic function for simplifying standard exponential identities
protocol Exponentable: FloatingPointType, IntegerLiteralConvertible {
  // There seems to be no way to require a global function in a protocol
  // This means we need to redirect calls from a static function to a global function

  // The exponential function: calculates e**x
  // Use <Module>.exp() to reference the global function within this function
  @warn_unused_result
  static func exp(x: Self) -> Self

  // The natural logarithm function: calculates ln(x) == log_e(x)
  // Use <Module>.log() to reference the global function within this function
  @warn_unused_result
  static func log(x: Self) -> Self

  // The multiplication operator: calculates lhs multiplied by rhs
  @warn_unused_result
  func *(lhs: Self, rhs: Self) -> Self
}

// Speed up basic exponential identities, such as those where lhs or rhs are 0 or 1
// Negative powers always return a zero result
// If there's no known speed-up using only comparison and integer conversions, return nil
func powSimplifyIdentities<T: protocol<Comparable, IntegerLiteralConvertible>>(lhs: T, _ rhs: T) -> T? {

  // Speed up a**0 == 1
  if rhs == 0 {
    return 1
  }

  // Speed up 0**b == 0 and 1**b == 1
  if lhs == 0 || lhs == 1 {
    return lhs
  }

  // Speed up a**1 == a
  if rhs == 1 {
    return lhs
  }

  // Answer a**(-b) with 0
  // It's not accurate if a**b is 0 or 1, but it's close most of the time
  // We really should throw an exception here
  if rhs < 0 {
    return 0
  }

  // There's no speed-up here
  return nil
}

// A generic implementation of the power function "pow" based on floating-point arithmetic
// Accuracy is based on the accuracy of exp, log, and * in the underlying type
// This function doesn't cope well with lhs being negative
func powFloatingPoint<T: Exponentable>(lhs: T, _ rhs: T) -> T {

  // Speed up some standard power identities
  let speedUp = powSimplifyIdentities(lhs, rhs)
  if speedUp != nil {
    return speedUp!
  }

  // We really should catch cases where lhs is negative, because log() can't handle them
  //if lhs < 0 {
  //  throw an error
  //}

  // Using the logarithmic identity:
  // ln(a**b) == b*ln(a)
  // a**b = e**ln(a**b) == e**(b*ln(a))
  return T.exp(rhs * T.log(lhs))
}

// Provide a default global function "pow", based on floating-point arithmetic
func pow<T: Exponentable>(lhs: T, _ rhs: T) -> T {
  return powFloatingPoint(rhs, lhs)
}

// Give Float, Double, and CGFloat the generic pow function as well

extension Float: Exponentable {

  // The exponential function: calculates e**x
  @warn_unused_result
  static func exp(x: Float) -> Float {
    return Darwin.exp(x)
  }

  // The natural logarithm function: calculates ln(x) == log_e(x)
  @warn_unused_result
  static func log(x: Float) -> Float {
    return Darwin.log(x)
  }

  // Float already has a global multiplication operator
}

extension Double: Exponentable {

  // The exponential function: calculates e**x
  @warn_unused_result
  static func exp(x: Double) -> Double {
    return Darwin.exp(x)
  }

  // The natural logarithm function: calculates ln(x) == log_e(x)
  @warn_unused_result
  static func log(x: Double) -> Double {
    return Darwin.log(x)
  }

  // Double already has a global multiplication operator
}

extension CGFloat: Exponentable {

  // The exponential function: calculates e**x
  @warn_unused_result
  static func exp(x: CGFloat) -> CGFloat {
    return CoreGraphics.exp(x)
  }

  // The natural logarithm function: calculates ln(x) == log_e(x)
  @warn_unused_result
  static func log(x: CGFloat) -> CGFloat {
    return CoreGraphics.log(x)
  }

  // CGFloat already has a global multiplication operator
}

// Speed up basic exponential identities, such as those where lhs or rhs are 0 or 1, or lhs is -1
// Negative powers always return a zero result
// If there's no known speed-up using only comparison and integer arithmetic, return nil
func powSimplifyIntegerIdentities<T: protocol<IntegerArithmeticType, IntegerLiteralConvertible>>(lhs: T, _ rhs: T) -> T? {

  // Speed up (-1)**b == +/- 1
  if lhs == -1 {
    if rhs % 2 == 0 {
      return 1
    } else {
      return lhs
    }
  }
  
  // Speed up some standard power identities
  let speedUp = powSimplifyIdentities(lhs, rhs)
  if speedUp != nil {
    return speedUp!
  }

  // There's no speed-up here
  return nil
}

// A generic implementation of the power function "pow" using iterative integer arithmetic for each exponentiation
// Negative powers always return a zero result
// This implementation has exact integer accuracy
func powIntegerIterate<T: protocol<IntegerArithmeticType, IntegerLiteralConvertible>>(lhs: T, _ rhs: T) -> T {
  // The remaining number of exponentiations
  var expCount = rhs
  var result: T = 1

  // Speed up some standard power identities
  let speedUp = powSimplifyIntegerIdentities(lhs, rhs)
  if speedUp != nil {
    return speedUp!
  }

  // Now, the largest possible number of iterations before overflowing is 64 (2**64)
  while expCount > 0 {
    result *= lhs
    expCount -= 1
  }

  return result
}

// A generic implementation of the power function "pow" using integer arithmetic for bitwise exponentiation
// (We could do this with bitwise arithmetic and shifts instead, but that would impose additional protocol requirements)
// Negative powers always return a zero result
// This implementation has exact integer accuracy
func powIntegerBitwise<T: protocol<IntegerArithmeticType, IntegerLiteralConvertible>>(lhs: T, _ rhs: T) -> T {
  // The remaining number of exponentiations
  var expCount = rhs
  var result: T = 1
  var multiplier = lhs

  // Speed up some standard power identities
  let speedUp = powSimplifyIntegerIdentities(lhs, rhs)
  if speedUp != nil {
    return speedUp!
  }

  while expCount > 0 {
    // if the lowest bit in expCount is set, multiply the result by the current multiplier, and unset that bit
    if expCount % 2 == 1 {
      result *= multiplier
      expCount -= 1
      // skip the multiplication below if we have no more exponentiations, otherwise it can overflow
      if expCount == 0 {
        break
      }
    }
    // halve the number of remaining exponentiations, and square the multiplier
    expCount /= 2
    multiplier = multiplier * multiplier
  }

  return result
}

// Provide a default global function "pow", based on integer arithmetic, including division
func pow<T: protocol<IntegerArithmeticType, IntegerLiteralConvertible>>(lhs: T, _ rhs: T) -> T {
  return powIntegerBitwise(lhs, rhs)
}

// Now the integer types have a global pow function
extension UInt:    PowerType {}

// The power function: calculates lhs to the power of rhs
@warn_unused_result
func **(lhs: UInt, rhs: UInt) -> UInt {
  return pow(lhs, rhs)
}

//extension UIntMax: PowerType {} - redundant, UInt64 conforms
extension UInt64:  PowerType {}

// The power function: calculates lhs to the power of rhs
@warn_unused_result
func **(lhs: UInt64, rhs: UInt64) -> UInt64 {
  return pow(lhs, rhs)
}

extension UInt32:  PowerType {}

// The power function: calculates lhs to the power of rhs
@warn_unused_result
func **(lhs: UInt32, rhs: UInt32) -> UInt32 {
  return pow(lhs, rhs)
}

extension UInt16:  PowerType {}

// The power function: calculates lhs to the power of rhs
@warn_unused_result
func **(lhs: UInt16, rhs: UInt16) -> UInt16 {
  return pow(lhs, rhs)
}

extension UInt8:   PowerType {}

// The power function: calculates lhs to the power of rhs
@warn_unused_result
func **(lhs: UInt8, rhs: UInt8) -> UInt8 {
  return pow(lhs, rhs)
}

extension Int:     PowerType {}

// The power function: calculates lhs to the power of rhs
@warn_unused_result
func **(lhs: Int, rhs: Int) -> Int {
  return pow(lhs, rhs)
}

//extension IntMax:  PowerType {} - redundant, Int64 conforms
extension Int64:   PowerType {}

// The power function: calculates lhs to the power of rhs
@warn_unused_result
func **(lhs: Int64, rhs: Int64) -> Int64 {
  return pow(lhs, rhs)
}

extension Int32:   PowerType {}

// The power function: calculates lhs to the power of rhs
@warn_unused_result
func **(lhs: Int32, rhs: Int32) -> Int32 {
  return pow(lhs, rhs)
}

extension Int16:   PowerType {}

// The power function: calculates lhs to the power of rhs
@warn_unused_result
func **(lhs: Int16, rhs: Int16) -> Int16 {
  return pow(lhs, rhs)
}

extension Int8:    PowerType {}

// The power function: calculates lhs to the power of rhs
@warn_unused_result
func **(lhs: Int8, rhs: Int8) -> Int8 {
  return pow(lhs, rhs)
}
