//
//  DominantColors.swift
//  DominantColor
//
//  Created by Indragie on 12/20/14.
//  Copyright © 2014 Indragie Karunaratne. All rights reserved.
//

import Foundation
import CoreGraphics
import simd

internal actor RGBAContext {
    
    internal init() {
        
    }
    
    internal func createRGBAContext(_ width: Int, height: Int) -> CGContext {
        return CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8, // bits per component
            bytesPerRow: width * 4, // bytes per row
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue).rawValue
        )!
    }
    
    /// Enumerates over all of the pixels in an RGBA bitmap context
    /// in the order that they are stored in memory, for faster access.
    ///
    /// From: https://www.mikeash.com/pyblog/friday-qa-2012-08-31-obtaining-and-interpreting-image-data.html
    ///
    internal func enumerateRGBAContext(_ context: CGContext, handler: (Int, Int, RGBAPixel) async -> Void) async {
        let (width, height) = (context.width, context.height)
        let data = unsafeBitCast(context.data, to: UnsafeMutablePointer<RGBAPixel>.self)
        for y in 0..<height {
            for x in 0..<width {
                await handler(x, y, data[Int(x + y * width)])
            }
        }
    }
    
}
