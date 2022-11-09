//
//  CGImage+DominantColors.swift
//  DominantColor
//
//  Created by Sam Spencer on 11/9/22.
//  Copyright © 2022 Indragie Karunaratne. All rights reserved.
//

import CoreGraphics
import Foundation
import simd

internal extension CGImage {
    
    /// Computes the dominant colors in an image
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
    ///   known beforehand, it is best to not memoize.
    ///
    /// - returns: A list of dominant colors in the image sorted from most dominant to
    ///   least dominant.
    ///
    func dominantColorsInImage(
        maxSampledPixels: Int,
        accuracy: GroupingAccuracy,
        seed: UInt64,
        memoizeConversions: Bool
    ) async -> [CGColor] {
        let calculator = DominantColorCalculator()
        let rgbaContext = RGBAContext()
        let colorSpaceConverter = ColorSpaceConverter()
        let kMeansProcessor = KMeans()
        
        let (scaledWidth, scaledHeight) = await calculator.scaledDimensionsForPixelLimit(
            maxSampledPixels,
            width: width,
            height: height
        )
        
        // Downsample the image if necessary, so that the total number of pixels sampled
        // does not exceed the specified maximum.
        //
        let context = await rgbaContext.createRGBAContext(scaledWidth, height: scaledHeight)
        context.draw(self, in: CGRect(x: 0, y: 0, width: Int(scaledWidth), height: Int(scaledHeight)))
        
        // Get the RGB colors from the bitmap context, ignoring any pixels that have alpha
        // transparency. Also convert the colors to the LAB color space.
        //
        var labValues = [simd_float3]()
        labValues.reserveCapacity(Int(scaledWidth * scaledHeight))
        
        let RGBToLAB: (RGBAPixel) async -> simd_float3 = await {
            let f: (RGBAPixel) async -> simd_float3 = {
                await colorSpaceConverter.IN_RGBToLAB($0.toRGBVector())
            }
            if memoizeConversions == true {
                return await memoize(f)
            } else {
                return f
            }
        }()
        
        await rgbaContext.enumerateRGBAContext(context) { _, _, pixel in
            if pixel.a == UInt8.max {
                async let rgbLab = RGBToLAB(pixel)
                labValues.append(await rgbLab)
            }
        }
        
        // Cluster the colors using the k-means algorithm.
        //
        let k = 16 // Magic number for now instead of: async let k = calculator.selectKForElements(labValues)
        async let distance = calculator.distanceForAccuracy(accuracy)
        var clusters = await kMeansProcessor.kmeans(labValues, k: k, seed: seed, distance: await distance)
        
        // Sort the clusters by size in descending order so that the most dominant colors
        // come first.
        //
        clusters.sort { $0.size > $1.size }
        
        let colorClusters = await clusters.asyncMap { cluster in
            async let rgbColor = colorSpaceConverter.IN_LABToRGB(cluster.centroid)
            return await rgbColor.fromRGBVectorToCGColor()
        }
        
        return colorClusters
    }
    
}
