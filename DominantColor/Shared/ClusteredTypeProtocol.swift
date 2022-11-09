//
//  ClusteredTypeProtocol.swift
//  DominantColor
//
//  Created by Sam Spencer on 11/9/22.
//  Copyright © 2022 Indragie Karunaratne. All rights reserved.
//

import Foundation

/// Represents a type that can be clustered using the k-means clustering
/// algorithm.
///
protocol ClusteredType {
    
    /// Used to compute average values to determine the cluster centroids.
    ///
    static func +(lhs: Self, rhs: Self) -> Self
    
    /// Used to compute average values to determine the cluster centroids.
    ///
    static func /(lhs: Self, rhs: Int) -> Self
    
    /// Identity value such that `x + identity = x`. Typically the `0` vector.
    ///
    static var identity: Self { get }
    
}

struct Cluster<T : ClusteredType> {
    let centroid: T
    let size: Int
}
