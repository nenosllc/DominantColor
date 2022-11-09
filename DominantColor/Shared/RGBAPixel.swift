//
//  RGBAPixel.swift
//  DominantColor
//
//  Created by Sam Spencer on 11/9/22.
//  Copyright © 2022 Indragie Karunaratne. All rights reserved.
//

import Foundation
import simd

internal struct RGBAPixel {
    let r: UInt8
    let g: UInt8
    let b: UInt8
    let a: UInt8
}

extension RGBAPixel: Hashable, Equatable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(r)
        hasher.combine(g)
        hasher.combine(b)
    }
    
    static func ==(lhs: RGBAPixel, rhs: RGBAPixel) -> Bool {
        return lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b
    }
    
}

internal extension RGBAPixel {
    
    func toRGBVector() -> simd_float3 {
        return simd_float3(
            Float(r) / Float(UInt8.max),
            Float(g) / Float(UInt8.max),
            Float(b) / Float(UInt8.max)
        )
    }
    
}
