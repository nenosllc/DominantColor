//
//  Memoization.swift
//  DominantColor
//
//  Created by Emmanuel Odeke on 2014-12-25.
//  Copyright (c) 2014 Indragie Karunaratne. All rights reserved.
//

/// An optimization technique that makes applications more efficient and hence
/// faster.
/// 
func memoize<T: Hashable, U>(_ f: @escaping (T) async -> U) async -> (T) async -> U {
    var cache = [T : U]()
    
    return { key in
        var value = cache[key]
        if value == nil {
            value = await f(key)
            cache[key] = value
        }
        return value!
    }
}

