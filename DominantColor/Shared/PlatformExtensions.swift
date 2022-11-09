//
//  PlatformExtensions.swift
//  DominantColor
//
//  Created by Indragie on 12/25/14.
//  Copyright © 2014 Indragie Karunaratne. All rights reserved.
//

public let kMaxSampledPixels: Int = 1000
public let kGroupingAccuracy: GroupingAccuracy = .medium
public let kSeed: UInt64 = 3571
public let kMemoizeConversions: Bool = false

#if os(OSX)
import Cocoa

public extension NSImage {
    
    /// Computes the dominant colors in the receiver
    ///
    /// - parameter maxSampledPixels: Maximum number of pixels to sample in the image.
    ///   If the total number of pixels in the image exceeds this value, it will be
    ///   downsampled to meet the constraint.
    /// - parameter accuracy: Level of accuracy to use when grouping similar colors.
    ///   Higher accuracy will come with a performance tradeoff.
    /// - parameter seed: Seed to use when choosing the initial points for grouping of
    ///   similar colors. The same seed is guaranteed to return the same colors every
    ///   time.
    /// - parameter memoizeConversions: Whether to memoize conversions from RGB to the
    ///   LAB color space (used for grouping similar colors). Memoization will only yield
    ///   better performance for large values of `maxSampledPixels` in images that are
    ///   primarily comprised of flat colors. If this information about the image is not
    ///   known beforehand, it is best to **not** memoize.
    ///
    /// - returns: A list of dominant colors in the image sorted from most dominant to
    ///   least dominant.
    ///
    func dominantColors(
        maxSampledPixels: Int = kMaxSampledPixels,
        accuracy: GroupingAccuracy = kGroupingAccuracy,
        seed: UInt64 = kSeed,
        memoizeConversions: Bool = kMemoizeConversions
    ) async -> [NSColor] {
        let image = cgImage(
            forProposedRect: nil,
            context: nil, hints: nil
        )!
        
        let colors = await image.dominantColorsInImage(
            maxSampledPixels: maxSampledPixels,
            accuracy: accuracy,
            seed: seed,
            memoizeConversions: memoizeConversions
        )
        
        let mappedColors = colors.map({ NSColor(cgColor: $0 )})
        return mappedColors
    }
    
}

#elseif os(iOS) || os(tvOS)
import UIKit

public extension UIImage {
    
    /// Computes the dominant colors in the receiver
    ///
    /// - parameter maxSampledPixels: Maximum number of pixels to sample in the image.
    ///   If the total number of pixels in the image exceeds this value, it will be
    ///   downsampled to meet the constraint.
    /// - parameter accuracy: Level of accuracy to use when grouping similar colors.
    ///   Higher accuracy will come with a performance tradeoff.
    /// - parameter seed: Seed to use when choosing the initial points for grouping of
    ///   similar colors. The same seed is guaranteed to return the same colors every
    ///   time.
    /// - parameter memoizeConversions: Whether to memoize conversions from RGB to the
    ///   LAB color space (used for grouping similar colors). Memoization will only yield
    ///   better performance for large values of `maxSampledPixels` in images that are
    ///   primarily comprised of flat colors. If this information about the image is not
    ///   known beforehand, it is best to **not** memoize.
    ///
    /// - returns: A list of dominant colors in the image sorted from most dominant to
    ///   least dominant.
    ///
    func dominantColors(
        _ maxSampledPixels: Int = kMaxSampledPixels,
        accuracy: GroupingAccuracy = kGroupingAccuracy,
        seed: UInt64 = kSeed,
        memoizeConversions: Bool = kMemoizeConversions
    ) async -> [UIColor] {
        guard let underlyingImage = self.cgImage else { return [] }
        
        let colors = await underlyingImage.dominantColorsInImage(
            maxSampledPixels: maxSampledPixels,
            accuracy: accuracy,
            seed: seed,
            memoizeConversions: memoizeConversions
        )
        
        let mappedColors = colors.map({ UIColor(cgColor: $0 )})
        return mappedColors
    }
    
}

#endif

