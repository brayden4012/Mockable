//
//  Array+MockableMethods.swift
//  
//
//  Created by Brayden Harris on 6/8/22.
//

import Foundation

public extension Array where Element: Mockable {
    /// Method conforming to Mockable
    /// - Parameter injectedValues: A `Dictionary` of `PartialKeyPath` and `Any?` used to specify objects to inject at the speicifed key paths.
    /// - Returns: An array containing a single `Mockable` element
    static func mockValue(injectedValues: [PartialKeyPath<[Element]>: Any?]) -> [Element] {
        [Element.mockValue]
    }

    /// Use this method to return a repeating list of a mocked `Element`
    ///
    /// Usage:
    /// ```
    /// struct Car: Mockable {
    ///    var make: String
    ///    var model: String
    ///
    ///    static func mockValue(injectedValues: [PartialKeyPath<Car> : Any?]) -> Car {
    ///        Car(
    ///            make: injectedValues[\.make] as? String ?? "Toyota",
    ///            model: injectedValues[\.model] as? String ?? "Corolla"
    ///        )
    ///    }
    /// }
    ///
    /// let mockCars = [Car].mockValue(numberOfElements: 3, injectedValues: [\.model: "Camry"])
    /// print(mockCars) // Returns an array of 3 Car objects with a model value of "Camry"
    /// ```
    /// **Note: This will not work in conjunction with SwiftUI `ForEach`**
    ///
    /// - Parameters:
    ///   - numberOfElements: The number of elements you want in the `Array`
    ///   - injectedValues: A `Dictionary` of `PartialKeyPath` and `Any?` used to specify objects to inject at the speicifed key paths for each element in the `Array`
    /// - Returns: `Array` containing the specified number of a single, repeated `Mockable` value.
    static func mockValue(numberOfElements: Int, injectedValues: [PartialKeyPath<Element>: Any?] = [:]) -> [Element] {
        Array(repeating: Element.mockValue(injectedValues: injectedValues), count: numberOfElements)
    }

    /// Use this method to return a repeating list of a mocked `Element` with different ID's (for use with SwiftUI `ForEach`)
    ///
    /// Usage:
    /// ```
    /// struct Car: Mockable, Identifiable {
    ///     var id: String
    ///     var make: String
    ///     var model: String
    ///
    ///     static func mockValue(injectedValues: [PartialKeyPath<Car> : Any?]) -> Car {
    ///         Car(
    ///             id: injectedValues[\.id] as? String ?? "123"
    ///             make: injectedValues[\.make] as? String ?? "Toyota",
    ///             model: injectedValues[\.model] as? String ?? "Corolla"
    ///         )
    ///     }
    /// }
    ///
    /// let mockCars = [Car].mockValue(numberOfElements: 3, idPath: \.id, injectedValues: [\.model: "Camry"])
    /// print(mockCars) // Returns an array of 3 Car objects with a model value of "Camry", each with a different `id`
    /// ```
    ///
    /// - Parameters:
    ///   - numberOfElements: The number of elements you want in the `Array`
    ///   - idPath: `KeyPath` of the variable used for `Identifiable` conformance. The value of this `KeyPath` must conform to `IdentifiableValueCastable`
    ///   - injectedValues: A `Dictionary` of `PartialKeyPath` and `Any?` used to specify objects to inject at the speicifed key paths for each element in the `Array`
    /// - Returns: `Array` containing the specified number of a single, repeated `Mockable` value, each with a different id value.
    static func mockValue<Value: IdentifiableValueCastable>(numberOfElements: Int, idPath: KeyPath<Element, Value>, injectedValues: [PartialKeyPath<Element>: Any?] = [:]) -> [Element] where Element: Identifiable {
        var injectedValues = injectedValues
        return (1...numberOfElements).map { offset in
            let value = cast(int: offset, as: Value.self)
            injectedValues[idPath] = value

            return Element.mockValue(injectedValues: injectedValues)
        }
    }

    /// Use this to return an `Array` of a single `Mockable` type with various different injected values
    ///
    /// Usage:
    /// ```
    /// struct Car: Mockable {
    ///     var make: String
    ///     var model: String
    ///
    ///     static func mockValue(injectedValues: [PartialKeyPath<Car> : Any?]) -> Car {
    ///         Car(
    ///             make: injectedValues[\.make] as? String ?? "Toyota",
    ///             model: injectedValues[\.model] as? String ?? "Corolla"
    ///         )
    ///     }
    /// }
    ///
    /// let mockCars = [Car].mockValue(injectedValues:
    ///                                    [:],
    ///                                    [\.model: "Camry"],
    ///                                    [\.make: "Hyundai", \.model: "Elantra"])
    /// print(mockCars) // Returns an array of 3 Car objects with various values
    /// ```
    /// - Parameter injectedValues: A Variadic parameter allowing you to enter any number of `[PartialKeyPath: Any?]` dictionaries
    /// - Returns: An `Array` of `Mockable` objects, using each of the `[PartialKeyPath: Any?]` dictionaries provided
    static func mockValue(injectedValues: [PartialKeyPath<Element>: Any?]...) -> [Element] {
        var array = [Element]()
        injectedValues.forEach {
            array.append(Element.mockValue(injectedValues: $0))
        }
        return array
    }

    private static func cast(int: Int, as identifiableValueType: IdentifiableValueCastable.Type) -> IdentifiableValueCastable {
        return identifiableValueType.castAsIdentifiableValue(int: int)
    }
}
