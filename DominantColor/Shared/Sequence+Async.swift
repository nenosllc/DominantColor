//
//  Sequence+Async.swift
//  DominantColor
//
//  Created by Sam Spencer on 11/9/22.
//  Copyright © 2022 Indragie Karunaratne. All rights reserved.
//

import Foundation

internal extension Sequence {
    
    func asyncMap<T>(_ transform: (Element) async throws -> T) async rethrows -> [T] {
        var values = [T]()
        for element in self {
            try await values.append(transform(element))
        }
        return values
    }
    
}
