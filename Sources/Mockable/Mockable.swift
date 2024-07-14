//
//  Mockable.swift
//
//
//  Created by Brayden Harris on 3/17/22.
//

import Combine
import Foundation

public protocol Mockable {
    static func mockValue(injectedValues: [PartialKeyPath<Self>: Any?]) -> Self
}

public extension Mockable {
    static var mockValue: Self {
        return Self.mockValue(injectedValues: [:])
    }

    var wrappedInResultPublisher: AnyPublisher<Self, Error> {
        Result.Publisher(self).eraseToAnyPublisher()
    }
}
