//
//  KMeans.swift
//  DominantColor
//
//  Created by Indragie on 12/20/14.
//  Copyright (c) 2014 Indragie Karunaratne. All rights reserved.
//

import Darwin
import GameKit

internal actor KMeans {
    
    /// k-means clustering algorithm from [Northwestern University](http://users.eecs.northwestern.edu/~wkliao/Kmeans/).
    ///
    internal func kmeans<T : ClusteredType>(
        _ points: [T],
        k: Int,
        seed: UInt64,
        distance: ((T, T) async -> Float),
        threshold: Float = 0.0001
    ) async -> [Cluster<T>] {
        let n = points.count
        assert(k <= n, "k cannot be larger than the total number of points")
        
        var centroids = points.randomValues(k, seed: seed)
        var memberships = [Int](repeating: -1, count: n)
        var clusterSizes = [Int](repeating: 0, count: k)
        
        var error: Float = 0
        var previousError: Float = 0
        
        repeat {
            error = 0
            var newCentroids = [T](repeating: T.identity, count: k)
            var newClusterSizes = [Int](repeating: 0, count: k)
            
            for i in 0..<n {
                let point = points[i]
                let clusterIndex = await findNearestCluster(point, centroids: centroids, k: k, distance: distance)
                if memberships[i] != clusterIndex {
                    error += 1
                    memberships[i] = clusterIndex
                }
                newClusterSizes[clusterIndex] += 1
                newCentroids[clusterIndex] = newCentroids[clusterIndex] + point
            }
            
            for i in 0..<k {
                let size = newClusterSizes[i]
                if size > 0 {
                    centroids[i] = newCentroids[i] / size
                }
            }
            
            clusterSizes = newClusterSizes
            previousError = error
        } while abs(error - previousError) > threshold
        
        let value = zip(centroids, clusterSizes).map {
            Cluster(centroid: $0, size: $1)
        }
        
        return value
    }
    
    private func findNearestCluster<T : ClusteredType>(
        _ point: T,
        centroids: [T],
        k: Int,
        distance: (T, T) async -> Float
    ) async -> Int {
        var minDistance = Float.infinity
        var clusterIndex = 0
        for i in 0..<k {
            let distance = await distance(point, centroids[i])
            if distance < minDistance {
                minDistance = distance
                clusterIndex = i
            }
        }
        return clusterIndex
    }
    
}
