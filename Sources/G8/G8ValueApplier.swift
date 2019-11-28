//
//  G8Appliers.swift
//  G8
//
//  Created by Guido Sabatini on 15/11/2019.
//

// swiftlint:disable all
import UIKit

public protocol ValueApplier {
    var type: Any.Type { get }
    func castingApply(_ value: Any, _ object: Any, _ keyString: String, _ key: G8Key) -> (Bool)
}

/// Struct containing all possible value applications to a T type object 
public struct G8ValueApplier<T>: ValueApplier {
    
    /// type of the object
    public var type: Any.Type = T.self
    /// closure that will eventually apply the value contained in G8Style at a given key (property) of a given object
    public var apply: (_ value: Any, _ object: T, _ keyString: String, _ key: G8Key) -> (Bool)
    
    /// internal casting function
    public func castingApply(_ value: Any, _ object: Any, _ keyString: String, _ key: G8Key) -> (Bool) {
        guard let castedObject = object as? T else { return false }
        return apply(value, castedObject, keyString, key)
    }
}

/// All natively defined value appliers
/// They manage all G8Keys defined keys
extension G8 {
    
    /// Applier for UIView sub-classes
    public static let themeableView = G8ValueApplier<UIView> { (value, object, keyString, key) in
        switch keyString {
        case G8K.View.backgroundColor.stringValue:
            applyValue(value, to: object, at: \.backgroundColor)
        case G8K.View.tintColor.stringValue:
            applyValue(value, to: object, at: \.tintColor)
        default:
            return false
        }
        return true
    }
    
    /// Applier for UILabel sub-classes
    public static let themeableLabel = G8ValueApplier<UILabel> { (value, object, keyString, key) in
        switch keyString {
        case G8K.Label.textColor.stringValue:
            applyValue(value, to: object, at: \.textColor)
        case G8K.Label.font.stringValue:
            applyValue(value, to: object, at: \.font)
        case G8K.Label.textAlignment.stringValue:
            applyValue(value, to: object, at: \.textAlignment)
        case G8K.Label.lineBreakMode.stringValue:
            applyValue(value, to: object, at: \.lineBreakMode)
        default:
            return false
        }
        return true
    }
    
    /// Applier for UIButton sub-classes
    public static let themeableButton = G8ValueApplier<UIButton> { (value, object, keyString, key) in
        let controlKey = key as? G8UIControlKey
        let string: String
        if let controlKey = key as? G8UIControlKey {
            string = controlKey.stringValueWithoutModifiers
        } else {
            string = key.stringValue
        }
        switch string {
        case G8K.Button.titleColor.stringValue:
            guard let color = value as? UIColor, let controlKey = controlKey else { return false }
            controlKey.uiControlStates().forEach { state in
                object.setTitleColor(color, for: state)
            }
        case G8K.Button.titleShadowColor.stringValue:
            guard let color = value as? UIColor, let controlKey = controlKey else { return false }
            controlKey.uiControlStates().forEach { state in
                object.setTitleShadowColor(color, for: state)
            }
        case G8K.Button.image.stringValue:
            guard let image = value as? UIImage, let controlKey = controlKey else { return false }
            controlKey.uiControlStates().forEach { state in
                object.setImage(image, for: state)
            }
        case G8K.Button.backgroundImage.stringValue:
            guard let image = value as? UIImage, let controlKey = controlKey else { return false }
            controlKey.uiControlStates().forEach { state in
                object.setBackgroundImage(image, for: state)
            }
        case G8K.Button.titleFont.stringValue:
            applyValue(value, to: object.titleLabel, at: \.font)
        case G8K.Button.backgroundImageFromColor.stringValue:
            guard let color = value as? UIColor, let image = G8.image(from: color), let controlKey = controlKey else { return false }
            controlKey.uiControlStates().forEach { state in
                object.setBackgroundImage(image, for: state)
            }
        default:
            return false
        }
        return true
    }
    
    /// Applier for CALayer sub-classes
    public static let themeableLayer = G8ValueApplier<CALayer> { (value, object, keyString, key) in
        switch keyString {
        case G8K.Layer.shadowColor.stringValue:
            applyValue(value, to: object, at: \.shadowColor)
        case G8K.Layer.shadowRadius.stringValue:
            applyValue(G8.cgFloat(from: value), to: object, at: \.shadowRadius)
        case G8K.Layer.shadowOpacity.stringValue:
            applyValue(G8.float(from: value), to: object, at: \.shadowOpacity)
        case G8K.Layer.shadowOffset.stringValue:
            applyValue(value, to: object, at: \.shadowOffset)
        case G8K.Layer.borderColor.stringValue:
            applyValue(value, to: object, at: \.borderColor)
        case G8K.Layer.borderWidth.stringValue:
            applyValue(G8.cgFloat(from: value), to: object, at: \.borderWidth)
        case G8K.Layer.backgroundColor.stringValue:
            applyValue(value, to: object, at: \.backgroundColor)
        case G8K.Layer.cornerRadius.stringValue:
            applyValue(G8.cgFloat(from: value), to: object, at: \.cornerRadius)
        case G8K.Layer.opacity.stringValue:
            applyValue(G8.float(from: value), to: object, at: \.opacity)
        default:
            return false
        }
        return true
    }
    
    /// Applier for UISegmentedControl sub-classes
    public static let themeableSegmentedControl = G8ValueApplier<UISegmentedControl> { (value, object, keyString, key) in
        let string: String
        if let controlKey = key as? G8UIControlKey {
            string = controlKey.stringValueWithoutModifiers
        } else {
            string = key.stringValue
        }
        switch string {
        case G8K.SegmentedControl.selectedSegmentTintColor.stringValue:
            if #available(iOS 13.0, *) {
                applyValue(value, to: object, at: \.selectedSegmentTintColor)
            }
        case G8K.SegmentedControl.backgroundImage.stringValue:
            guard let image = value as? UIImage, let controlKey = key as? G8UIControlKey else { return false }
            controlKey.uiControlStates().forEach { state in
                object.setBackgroundImage(image, for: state, barMetrics: .default)
            }
        case G8K.SegmentedControl.backgroundImageFromColor.stringValue:
            guard let color = value as? UIColor, let image = image(from: color), let controlKey = key as? G8UIControlKey else { return false }
            controlKey.uiControlStates().forEach { state in
                object.setBackgroundImage(image, for: state, barMetrics: .default)
            }
        case G8K.SegmentedControl.font.stringValue:
            guard let font = value as? UIFont, let controlKey = key as? G8UIControlKey else { return false }
            controlKey.uiControlStates().forEach { state in
                if var attributes = object.titleTextAttributes(for: state) {
                    attributes[NSAttributedString.Key.font] = font
                    object.setTitleTextAttributes(attributes, for: state)
                } else {
                    object.setTitleTextAttributes([NSAttributedString.Key.font: font], for: state)
                }
            }
        case G8K.SegmentedControl.textColor.stringValue:
            guard let color = value as? UIColor, let controlKey = key as? G8UIControlKey else { return false }
            controlKey.uiControlStates().forEach { state in
                if var attributes = object.titleTextAttributes(for: state) {
                    attributes[NSAttributedString.Key.foregroundColor] = color
                    object.setTitleTextAttributes(attributes, for: state)
                } else {
                    object.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: state)
                }
            }
        default:
            return false
        }
        return true
    }
    
    /// Applier for UITextField sub-classes
    public static let themeableTextField = G8ValueApplier<UITextField> { (value, object, keyString, key) in
        switch keyString {
        case G8K.TextField.textColor.stringValue:
            applyValue(value, to: object, at: \.textColor)
        case G8K.TextField.font.stringValue:
            applyValue(value, to: object, at: \.font)
        case G8K.TextField.textAlignment.stringValue:
            applyValue(value, to: object, at: \.textAlignment)
        case G8K.TextField.borderStyle.stringValue:
            applyValue(value, to: object, at: \.borderStyle)
        case G8K.TextField.placeholderColor.stringValue:
            guard let color = value as? UIColor else { return false }
            if let attributedString = object.attributedPlaceholder, attributedString.length > 0 {
                let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
                mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location: 0, length: attributedString.length))
                object.attributedPlaceholder = mutableAttributedString
                return true
            }
            if let placeholder = object.placeholder, placeholder.count > 0 {
                let attributedString = NSAttributedString(string: placeholder, attributes: [
                    NSAttributedString.Key.foregroundColor: color
                ])
                object.attributedPlaceholder = attributedString
                return true
            }
            return false
        case G8K.TextField.placeholderFont.stringValue:
            guard let font = value as? UIFont else { return false }
            if let attributedString = object.attributedPlaceholder, attributedString.length > 0 {
                let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
                mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: attributedString.length))
                object.attributedPlaceholder = mutableAttributedString
                return true
            }
            if let placeholder = object.placeholder, placeholder.count > 0 {
                let attributedString = NSAttributedString(string: placeholder, attributes: [
                    NSAttributedString.Key.font: font
                ])
                object.attributedPlaceholder = attributedString
                return true
            }
            return false
        case G8K.TextField.background.stringValue:
            applyValue(value, to: object, at: \.background)
        case G8K.TextField.disabledBackground.stringValue:
            applyValue(value, to: object, at: \.disabledBackground)
        default:
            return false
        }
        return true
    }
    
    /// Applier for UISlider sub-classes
    public static let themeableSlider = G8ValueApplier<UISlider> { (value, object, keyString, key) in
        switch keyString {
        case G8K.Slider.minimumValueImage.stringValue:
            applyValue(value, to: object, at: \.minimumValueImage)
        case G8K.Slider.maximumValueImage.stringValue:
            applyValue(value, to: object, at: \.maximumValueImage)
        case G8K.Slider.isContinuous.stringValue:
            applyValue(value, to: object, at: \.isContinuous)
        case G8K.Slider.minimumTrackTintColor.stringValue:
            applyValue(value, to: object, at: \.minimumTrackTintColor)
        case G8K.Slider.maximumTrackTintColor.stringValue:
            applyValue(value, to: object, at: \.maximumTrackTintColor)
        case G8K.Slider.thumbTintColor.stringValue:
            applyValue(value, to: object, at: \.thumbTintColor)
        default:
            return false
        }
        return true
    }
    
    /// Applier for UISwitch sub-classes
    public static let themeableSwitch = G8ValueApplier<UISwitch> { (value, object, keyString, key) in
        switch keyString {
        case G8K.Switch.onTintColor.stringValue:
            applyValue(value, to: object, at: \.onTintColor)
        case G8K.Switch.thumbTintColor.stringValue:
            applyValue(value, to: object, at: \.thumbTintColor)
        default:
            return false
        }
        return true
    }
    
    /// Applier for UIImageView sub-classes
    public static let themeableImageView = G8ValueApplier<UIImageView> { (value, object, keyString, key) in
        switch keyString {
        case G8K.Image.image.stringValue:
            applyValue(value, to: object, at: \.image)
        case G8K.Image.highlightedImage.stringValue:
            applyValue(value, to: object, at: \.highlightedImage)
        default:
            return false
        }
        return true
    }
    
    /// Applier for UITextView sub-classes
    public static let themeableTextView = G8ValueApplier<UITextView> { (value, object, keyString, key) in
        switch keyString {
        case G8K.TextView.textColor.stringValue:
            applyValue(value, to: object, at: \.textColor)
        case G8K.TextView.font.stringValue:
            applyValue(value, to: object, at: \.font)
        case G8K.TextView.textAlignment.stringValue:
            applyValue(value, to: object, at: \.textAlignment)
        default:
            return false
        }
        return true
    }
    
}

extension G8 {
    /**
        Utility to create a 10x10 image from a UIColor
        - Parameter color the image color
        - Returns: a 10x10 uniform image with the given color
     */
    public static func image(from color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 10.0, height: 10.0)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return image
    }
    
    /**
        Utility to try to convert an Any value to a cgColor value
        - Parameter any the input value
        - Returns: an Any output representing a CGColor if conversion is possible, otherwise representing the input value
     */
    static func cgColor(from any: Any) -> Any {
        if let color = any as? UIColor {
            return color.cgColor
        }
        return any
    }
    
    /**
        Utility to try to convert an Any value to a Float value
        - Parameter any the input value
        - Returns: an Any output representing a Float if conversion is possible, otherwise representing the input value
     */
    static func float(from any: Any) -> Any {
        if let numberConvertible = any as? NumberConvertible, let float: Float = try? numberConvertible.convert() {
            return float
        }
        return any
    }
    
    /**
        Utility to try to convert an Any value to a CGFloat value
        - Parameter any the input value
        - Returns: an Any output representing a CGFloat if conversion is possible, otherwise representing the input value
     */
    static func cgFloat(from any: Any) -> Any {
        if let numberConvertible = any as? NumberConvertible, let cgFloat: CGFloat = try? numberConvertible.convert() {
            return cgFloat
        }
        return any
    }
}
