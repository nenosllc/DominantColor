//
//  INVector3SwiftExtensions.swift
//  DominantColor
//
//  Created by Indragie on 12/24/14.
//  Copyright (c) 2014 Indragie Karunaratne. All rights reserved.
//

import CoreGraphics
import Foundation
import simd

@inlinable func SIMDMathDegreesToRadians(_ degrees: Float) -> Float {
    return degrees * (Float.pi / 180.0)
}

@inlinable func SIMDMathRadiansToDegrees(_ radians: Float) -> Float {
    return radians * (180.0 / Float.pi)
}

extension simd_float3: ClusteredType {
    
    func unpack() -> (Float, Float, Float) {
        return (x, y, z)
    }
    
    static var identity: simd_float3 {
        return simd_float3(0, 0, 0)
    }
    
    static func +(lhs: simd_float3, rhs: simd_float3) -> simd_float3 {
        return simd_float3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }
    
    static func /(lhs: simd_float3, rhs: Float) -> simd_float3 {
        return simd_float3(lhs.x / rhs, lhs.y / rhs, lhs.z / rhs)
    }
    
    static func /(lhs: simd_float3, rhs: Int) -> simd_float3 {
        return lhs / Float(rhs)
    }
    
    func fromRGBVectorToCGColor() -> CGColor {
        return CGColor(
            colorSpace: CGColorSpaceCreateDeviceRGB(),
            components: [
                CGFloat(x),
                CGFloat(y),
                CGFloat(z),
                1.0
            ]
        )!
    }
    
}
