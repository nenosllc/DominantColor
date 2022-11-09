//
//  DominantColorCalculator.swift
//  DominantColor
//
//  Created by Sam Spencer on 11/9/22.
//  Copyright © 2022 Indragie Karunaratne. All rights reserved.
//

import Foundation
import simd

internal actor DominantColorCalculator {
    
    internal init() {
        
    }
    
    /// Computes the proportionally scaled dimensions such that the
    /// total number of pixels does not exceed the specified limit.
    ///
    internal func scaledDimensionsForPixelLimit(_ limit: Int, width: Int, height: Int) async -> (Int, Int) {
        if (width * height > limit) {
            let ratio = Float(width) / Float(height)
            let maxWidth = sqrtf(ratio * Float(limit))
            return (Int(maxWidth), Int(Float(limit) / maxWidth))
        }
        return (width, height)
    }
    
    internal func distanceForAccuracy(_ accuracy: GroupingAccuracy) async -> (simd_float3, simd_float3) async -> Float {
        let colorDiff = ColorDifference()
        
        switch accuracy {
        case .low: return colorDiff.CIE76SquaredColorDifference
        case .medium: return await colorDiff.CIE94SquaredColorDifference()
        case .high: return await colorDiff.CIE2000SquaredColorDifference()
        }
    }
    
    internal func selectKForElements<T>(_ elements: [T]) async -> Int {
        // Seems like a magic number...
        return 16
    }
    
}
