//
//  G8Style.swift
//  G8
//
//  Created by Guido Sabatini on 22/11/2019.
//  Thanks to Lorenzo Rossi
//

// swiftlint:disable all
// Protocol
public protocol G8KeyConvertible {
    func g8Key() -> G8Key
}

/// Ability tu use a G8Key as G8Style key
extension G8Key: G8KeyConvertible {
    public func g8Key() -> G8Key {
        return self
    }
}

/// Ability tu use a String as G8Style key
extension String: G8KeyConvertible {
    public func g8Key() -> G8Key {
        return G8Key(self)
    }
}

// Custom Dictionary
public struct G8Style {
    
    /// Inner structure
    private var dictionary: [G8Key: Any?] = [:]
    
    /// Initializer
    init(_ dictionary: [G8Key: Any?]) {
        self.dictionary = dictionary
    }
    
    /// To access inner values by subscription like a dictionary
    subscript(key: String) -> Any? {
        get {
            if let value = dictionary[G8Key(key)] {
                return value
            } else {
                return nil
            }
        }
        set {
            dictionary[G8Key(key)] = newValue
        }
    }
    
    /// Forwarding filter function to inner structure
    func filter(_ isIncluded: (_ key: G8Key,_ value: Any) throws -> Bool) rethrows -> G8Style {
        let filtered = try dictionary.filter(isIncluded)
        let style = G8Style(filtered)
        return style
    }
    
    /// Forwarding forEach function to inner structure
    func forEach(_ body: ((key: Key, value: Value)) throws -> Void) rethrows {
        try dictionary.forEach(body)
    }
}

/// Initialization like a normal dictionary (parenthesys notation)
extension G8Style: ExpressibleByDictionaryLiteral {
    public typealias Key = G8KeyConvertible
    public typealias Value = Any?

    public init(dictionaryLiteral elements: (Key, Any?)...) {
        for (key, value) in elements {
            dictionary[key.g8Key()] = value
        }
    }
}

/// Ability to print internal structure
extension G8Style: CustomStringConvertible {
    public var description: String {
        return dictionary.description
    }
}
