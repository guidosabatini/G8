//
//  G8.swift
//  G8
//
//  Created by Guido Sabatini on 29/10/2019.
//

// swiftlint:disable all
import UIKit

public struct G8 {
    
    public init() {
        valueAppliers = [G8.themeableLayer,
                         G8.themeableView, 
                         G8.themeableLabel,
                         G8.themeableButton,
                         G8.themeableSegmentedControl, 
                         G8.themeableTextField,
                         G8.themeableSlider,
                         G8.themeableSwitch,
                         G8.themeableImageView,
                         G8.themeableTextView]
    }
    
    /// global log level setting for G8
    public static var logLevel: LogLevel = .warning
    private var valueAppliers = [ValueApplier]()
    
    /**
        Add a new custom ValueApplier to G8. All the subsequent calls to applyStyle(:to:) will consider also this applier
     
        - Parameter valueApplier: the valueApplier to add
    */
    public mutating func add(valueApplier: ValueApplier) {
        valueAppliers.append(valueApplier)
    }
    
    /**
        Add an array of custom ValueAppliers to G8. All the subsequent calls to applyStyle(:to:) will consider also these appliers
     
        - Parameter valueApplier: the valueApplier to add
    */
    public mutating func add(valueAppliers: [ValueApplier]) {
        self.valueAppliers.append(contentsOf: valueAppliers)
    }
    
    /**
        Will apply the given style to the given object, searching for paths (keys) and assigning values or sub-styles (values)
     
        - Parameter style: the style to apply, a dictionary wrapper where the key represents the sub-object or the property to customize and the value represents the sub-style or the value for the customization
        - Parameter object: the root object
     */
    public func applyStyle(_ style: G8Style, to object: Any) {
        G8.log("Applying style \(style) to object \(String.typeName(input: object))", level: .verbose)
        // searching for superstyles
        let superStyles = style.filter { (key, value) -> Bool in
            key.stringValue == G8K.superStyle.stringValue
        }
        superStyles.forEach { (key, value) in
            if let subStyle = value as? G8Style {
                applyStyle(subStyle, to: object)
            } else {
                G8.log("The value at key \(key) for object \(String.typeName(input: object)) isn't a valid G8Style object", level: .warning)
            }
        }
        // then standard styles are managed
        let standardStyles = style.filter { (key, value) -> Bool in
            key.stringValue != G8K.superStyle.stringValue
        }
        standardStyles.forEach { (key, value) in
            let subStyle: G8Style?
            if let dictionary = value as? [G8Key: Any] {
                // substyle could be defined as dictionary instead of G8Style instance
                subStyle = G8Style(dictionary)
            } else {
                // try a casting to G8Style
                subStyle = value as? G8Style
            }
            if let subStyle = subStyle {
                // value associated to key is a G8Style -> trying to find the correct object (crossing the keypath passed as key)
                guard let subObject = try? G8.findObject(named: key.g8Key().stringValue, in: object) else {
                    G8.log("Cannot find keyPath \"\(key.g8Key().stringValue)\" on object \(String.typeName(input: object))", level: .warning)
                    return
                }
                applyStyle(subStyle, to: subObject)
            } else {
                // applying value to object pointed by the keypath, considering that last part of keypath is the property to customize
                var finalObject = object
                if let keyPathToLast = key.g8Key().keyPathToLast(), keyPathToLast.count > 0 {
                    guard let o = try? G8.findObject(named: keyPathToLast, in: object) else {
                        G8.log("Cannot find keyPath \"\(keyPathToLast)\" on object \(String.typeName(input: object))", level: .warning)
                        return
                    }
                    finalObject = o
                }
                guard let value = value else {
                    G8.log("Canno apply empty value to key \"\(key.g8Key().lastComponent())\" on object \(String.typeName(input: object))", level: .warning)
                    return
                }
                applyValue(value, to: finalObject, at: key.g8Key())
            }
        }
    }
    
}

// MARK: Static functions

extension G8 {
    
    /**
        Will try to apply a specific value to an optional object at the given keyPath, checking first if all types are compatible
        
        - Parameter value the value to apply; its type should be valid for the given object/keyPath, otherwise il won't be aplied
        - Parameter object the object to customize
        - Parameter keyPath the keyPath in which the value will be written onto object
     */
    public static func applyValue<T, O: AnyObject>(_ value: Any, to object: O?, at keyPath: ReferenceWritableKeyPath<O, T>) {
        guard let unwrapped = object else {
            G8.log("Cannot assign value \(String.typeName(input: value)) to nil object for keyPath \(keyPath)", level: .error)
            return
        }
        applyValue(value, to: unwrapped, at: keyPath)
    }
    
    /**
        Will try to apply a specific value to a non optional object at the given keyPath, checking first if all types are compatible
        
        - Parameter value the value to apply; its type should be valid for the given object/keyPath, otherwise il won't be aplied
        - Parameter object the object to customize
        - Parameter keyPath the keyPath in which the value will be written onto object
     */
    public static func applyValue<T, O: AnyObject>(_ value: Any, to object: O, at keyPath: ReferenceWritableKeyPath<O, T>) {
        guard let casted = value as? T else {
            G8.log("Cannot cast \(String.typeName(input: value)) to \(String.typeName(input: T.self)) for keyPath \(keyPath)", level: .error)
            return
        }
        object[keyPath: keyPath] = casted
    }
    
    /// Available log levels for G8
    public enum LogLevel: Int {
        case verbose
        case warning
        case error
        
        var icon: String {
            switch self {
            case .verbose:
                return "📢"
            case .warning:
                return "⚠️"
            case .error:
                return "💥"
            }
        }
    }
    
    /// Centralized log function
    static func log(_ string: String?, level: LogLevel) {
        if level.rawValue >= logLevel.rawValue, let s = string {
            print("🎨\(level.icon) G8 \(level.icon)🎨: \(s)")
        }
    }
}

// MARK: Private functions

extension G8 {
    
    /// Will apply a value to an object at a given G8Key
    private func applyValue(_ value: Any, to object: Any, at key: G8Key) {
        G8.log("Applying value of type \(String.typeName(input: value)) to object of type \(String.typeName(input: object)) at key \(key.lastComponent())", level: .verbose)
        let appliers = valueAppliers.filter { (valueApplier) -> Bool in
            return G8.canCast(object, toType: valueApplier.type)
        }
        G8.log("Found \(appliers.count) appliers", level: .verbose)
        var applied = false
        for applier in appliers {
            if applier.castingApply(value, object, key.lastComponent(), key) {
                G8.log("Applied value from \(String.typeName(input: applier))", level: .verbose)
                applied = true
            }
        }
        if !applied {
            G8.log("Key \"\(key.lastComponent())\" unsupported on object of type \(String.typeName(input: object)) for value \(String.typeName(input: value))", level: .warning)
            if value is Dictionary<AnyHashable, Any> {
                G8.log("Did you forget to wrap a dictionary in a G8Style object?", level: .warning)
            }
        }
    }
    
    /// Check if an object can be casted to a specific type (object or one of its supertypes are of that type) 
    private static func canCast(_ object: Any, toType destType: Any.Type) -> Bool {
        // unwrapping optionals
        guard let firstMirror = mirrorUnwrappingOptional(of: object) else { return false }
        // searching in the array of superclasses if one matches with the given one
        return sequence(
            first: firstMirror, next: { $0.superclassMirror }
        ).contains { $0.subjectType == destType }
    }
    
    /// Cross sub-objects in object using the named string as a keyPath
    private static func findObject(named: String, in object: Any) throws -> Any {
        // unwrapping optionals
        guard let mirror = mirrorUnwrappingOptional(of: object) else { throw G8Error.findKeyPathError }
        var components = named.split(separator: ".")
        guard components.count > 0 else { throw G8Error.findKeyPathError }
        // searching in properties of the object for one with che given name (component[0])
        for child in mirror.children {
            if child.label == String(components[0]) {
                if (components.count > 1) {
                    // if the keyPath continues, go recursively
                    components.removeFirst()
                    return try findObject(named: components.joined(separator: "."), in: child.value)
                } else {
                    // else, object found
                    G8.log("Found object named \(named) in object of type \(String.typeName(input: object))", level: .verbose)
                    return child.value
                }
            }
        }
        // if the strategy fails, fallback to value(forKeyPath:). A lot of UIKit objects hide properties from reflection
        if let nsObject = object as? NSObject, let value = nsObject.value(forKeyPath: named) {
            G8.log("Cannot extract object named \(named) in object of type \(String.typeName(input: object)). Switching to value(forKeyPath", level: .verbose)
            return value
        }
        // property not found in object hierarchy
        G8.log("Cannot find object named \(named) in object of type \(String.typeName(input: object))", level: .warning)
        throw G8Error.findKeyPathError
    }
    
    /// Get mirror of an object unwrapping optional
    private static func mirrorUnwrappingOptional(of object: Any) -> Mirror? {
        let mirror = Mirror(reflecting: object)
        if mirror.displayStyle == .optional {
            // unwrapping optionals
            if let firstChild = mirror.children.first {
                // internal value of optional (Optional.some)
                return mirrorUnwrappingOptional(of: firstChild.value)
            } else {
                return nil
            }
        }
        return mirror
    }
}

/// Errors
extension G8 {
    enum G8Error: Error {
        case genericError
        case castingError
        case findKeyPathError
    }
}

/// Utility for logging purpose
extension String {
    static func typeName(input: Any) -> String {
        return String(describing: input.self)
    }
}
