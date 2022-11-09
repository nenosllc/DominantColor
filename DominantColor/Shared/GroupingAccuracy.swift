//
//  GroupingAccuracy.swift
//  DominantColor
//
//  Created by Sam Spencer on 11/9/22.
//  Copyright © 2022 Indragie Karunaratne. All rights reserved.
//

import Foundation

public enum GroupingAccuracy {
    
    /// CIE 76 - Euclidian distance
    case low
    
    /// CIE 94 - Perceptual non-uniformity corrections
    case medium
    
    /// CIE 2000 - Additional corrections for neutral colors, lightness, chroma, and hue
    case high
    
}
