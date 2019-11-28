//
//  NumberConvertible.swift
//  G8
//
//  Created by Guido Sabatini on 27/11/2019.
//  Thanks to Nadohs (https://github.com/Nadohs/Cast-Free-Arithmetic-in-Swift)
//

// swiftlint:disable all
import CoreGraphics //For CGFloat

typealias PreferredType = Double

enum NumberConvertibleError: Error {
    case conversionError
}

protocol NumberConvertible {
    init(_ value: Int)
    init(_ value: Float)
    init(_ value: Double)
    init(_ value: CGFloat)
    init(_ value: UInt8)
    init(_ value: Int8)
    init(_ value: UInt16)
    init(_ value: Int16)
    init(_ value: UInt32)
    init(_ value: Int32)
    init(_ value: UInt64)
    init(_ value: Int64)
    init(_ value: UInt)
}

extension NumberConvertible {
    
    func convert<T: NumberConvertible>() throws -> T {
        switch self {
        case let x as CGFloat:
            return T(x)
        case let x as Float:
            return T(x)
        case let x as Int:
            return T(x)
        case let x as Double:
            return T(x)
        case let x as UInt8:
            return T(x)
        case let x as Int8:
            return T(x)
        case let x as UInt16:
            return T(x)
        case let x as Int16:
            return T(x)
        case let x as UInt32:
            return T(x)
        case let x as Int32:
            return T(x)
        case let x as UInt64:
            return T(x)
        case let x as Int64:
            return T(x)
        case let x as UInt:
            return T(x)
        default:
            throw NumberConvertibleError.conversionError
        }
    }
    
}

extension CGFloat : NumberConvertible {}
extension Double  : NumberConvertible {}
extension Float   : NumberConvertible {}
extension Int     : NumberConvertible {}
extension UInt8   : NumberConvertible {}
extension Int8    : NumberConvertible {}
extension UInt16  : NumberConvertible {}
extension Int16   : NumberConvertible {}
extension UInt32  : NumberConvertible {}
extension Int32   : NumberConvertible {}
extension UInt64  : NumberConvertible {}
extension Int64   : NumberConvertible {}
extension UInt    : NumberConvertible {}
