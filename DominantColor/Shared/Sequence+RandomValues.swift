//
//  Sequence+RandomValues.swift
//  DominantColor
//
//  Created by Sam Spencer on 11/9/22.
//  Copyright © 2022 Indragie Karunaratne. All rights reserved.
//

import Foundation
import GameKit

internal extension Array {
    
    func randomValues(_ num: Int, seed: UInt64) -> [Element] {
        guard self.isEmpty == false else { return self }
        
        let rs = GKMersenneTwisterRandomSource()
        rs.seed = seed
        
        let rd = GKRandomDistribution(randomSource: rs, lowestValue: 0, highestValue: self.count - 1)
        
        var indices = [Int]()
        indices.reserveCapacity(num)
        
        for _ in 0..<num {
            var random = 0
            repeat {
                random = rd.nextInt()
            } while indices.contains(random)
            indices.append(random)
        }
        
        return indices.map { self[$0] }
    }
    
}
