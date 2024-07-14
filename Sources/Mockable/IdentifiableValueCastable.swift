//
//  IdentifiableValueCastable.swift
//  
//
//  Created by Brayden Harris on 6/9/22.
//

import Foundation

public protocol IdentifiableValueCastable {
    static func castAsIdentifiableValue(int: Int) -> Self
}

extension Int: IdentifiableValueCastable {
    public static func castAsIdentifiableValue(int: Int) -> Int {
        return int
    }
}

extension String: IdentifiableValueCastable {
    public static func castAsIdentifiableValue(int: Int) -> String {
        return String(int)
    }
}

extension UUID: IdentifiableValueCastable {
    public static func castAsIdentifiableValue(int: Int) -> UUID {
        return UUID()
    }
}
