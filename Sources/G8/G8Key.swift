//
//  G8Key.swift
//  G8
//
//  Created by Guido Sabatini on 15/11/2019.
//

// swiftlint:disable all
import UIKit

/**
    Class representing a key for G8Style dictionary
 */
open class G8Key: Hashable {
    /// For Comparable conformity
    public static func == (lhs: G8Key, rhs: G8Key) -> Bool {
        return lhs.stringValue == rhs.stringValue
    }
    /// For Hashable conformity
    public func hash(into hasher: inout Hasher) {
        hasher.combine(stringValue)
    }
    
    /// Wrapped variable
    public var stringValue: String
    /// Initializer
    public init(_ stringValue: String) {
        self.stringValue = stringValue
    }

    /**
        Getting the internal keyPath separated in components
        
        - Returns: an array of String components
     */
    public func components() -> [String] {
        return stringValue.components(separatedBy: ".")
    }
    
    /**
        Getting the last component of the internam keyPath
        
        - Returns: last String component
     */
    public func lastComponent() -> String {
        return components().last ?? ""
    }
    
    /**
        Getting the internal keyPath with last component removed
        
        - Returns: a string representing a keyPath omitting the last component
     */
    public func keyPathToLast() -> String? {
        return components().dropLast().joined(separator: ".")
    }
}

/**
   Class representing a key for G8Style dictionary, with the ability to set UIControl modifiers
*/
open class G8UIControlKey: G8Key {
    let separator = ":" 
    public enum Modifier: String {
        case normal
        case selected
        case highlighted
        case disabled
        case focused
        case application
    }
    
    /// The internal key, without modifiers
    public var stringValueWithoutModifiers: String {
        return stringValue.components(separatedBy: separator).first ?? ""
    }
    /// Apply "normal" modifier and get the modified key
    public var normal: G8UIControlKey {
        return add(modifier: .normal)
    }
    /// Apply "selected" modifier and get the modified key
    public var selected: G8UIControlKey {
        return add(modifier: .selected)
    }
    /// Apply "highlighted" modifier and get the modified key
    public var highlighted: G8UIControlKey {
        return add(modifier: .highlighted)
    }
    /// Apply "disabled" modifier and get the modified key
    public var disabled: G8UIControlKey {
        return add(modifier: .disabled)
    }
    /// Apply "disabled" modifier and get the modified key
    public var focused: G8UIControlKey {
        return add(modifier: .focused)
    }
    /// Apply "application" modifier and get the modified key
    public var application: G8UIControlKey {
        return add(modifier: .application)
    }
    
    func add(modifier: Modifier) -> G8UIControlKey {
        let key = self.stringValue + separator + modifier.rawValue
        return G8UIControlKey(key)
    }
    func isModified() -> Bool {
        return stringValue.contains(separator)
    }
    func hasModifier(_ modifier: Modifier) -> Bool {
        return stringValue.contains(separator + modifier.rawValue)
    }
    /**
        Converts modifiers in UIControl.State modifiers
     
        - Returns: an array of correspponding UIControl.State enum values
     */
    func uiControlStates() -> [UIControl.State] {
        var result = [UIControl.State]()
        if hasModifier(.normal) || !isModified() {
            result.append(.normal)
        }
        if hasModifier(.disabled) {
            result.append(.disabled)
        }
        if hasModifier(.focused) {
            result.append(.focused)
        }
        if hasModifier(.highlighted) {
            result.append(.highlighted)
        }
        if hasModifier(.selected) {
            result.append(.selected)
        }
        if hasModifier(.application) {
            result.append(.application)
        }
        return result
    }
}
