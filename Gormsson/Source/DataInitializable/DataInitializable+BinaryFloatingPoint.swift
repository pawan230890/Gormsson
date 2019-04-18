//
//  DataInitializable+BinaryFloatingPoint.swift
//  Gormsson
//
//  Created by Damien Noël Dubuisson on 15/04/2019.
//  Copyright © 2019 Loïc GRIFFIE. All rights reserved.
//

import Foundation

extension Double: DataInitializable {
    /// Initialize the object from octets' array
    public init?(with octets: [UInt8]) {
        self = Double(bitPattern: UInt64(with: octets))
    }
}

extension Float: DataInitializable {
    /// Initialize the object from octets' array
    public init?(with octets: [UInt8]) {
        self = Float(bitPattern: UInt32(with: octets))
    }
}

//Float, Float80, Double

#if !os(Windows) && (arch(i386) || arch(x86_64))
// From: https://en.wikipedia.org/wiki/Extended_precision#x86_extended_precision_format
// _Untested_
extension Float80: DataInitializable {
    /// Initialize the object from octets' array
    public init?(with octets: [UInt8]) {
        guard octets.count >= 6 else {
            self = nil
            return
        }
        let signAndExponent = UInt16(with: octets[0...1])
        let intergerPartAndFraction = UInt64(with: octets[2...5])
        self = Float80(sign: FloatingPointSign(rawValue: signAndExponent & 0b1000_0000_0000_0000) ?? .plus,
                       exponentBitPattern: UInt(signAndExponent & 0b0111_1111_1111_1111),
                       significandBitPattern: intergerPartAndFraction)
    }
}
#endif