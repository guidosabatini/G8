# G8 (italian: dʒɔtto)

<a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat"></a>
<img alt="License" src="https://img.shields.io/badge/License-MIT-lightgrey">
<img alt="Platforms" src="https://img.shields.io/badge/platform-ios-lightgrey">
<img alt="Author" src="https://img.shields.io/badge/author-Guido%20Sabatini-green">

**G8** allow to centralize themes and apply styles to your interface and your UIKit objects.
Define uniform styles for all your labels, buttons and other views and apply them when you need.

## Feature

- Define style in a clear and neat way
- Mantain your palettes and base styles in a centrilized place: modify once to update them all!
- Fast and simple reuse of common styles
- Apply or change theme with a single line of code
- Guided way to find customizable UIKit properties, thanks to predefined enums
- Almost all UIKit views managed

![Example](https://raw.githubusercontent.com/SysdataSpA/Giotto/master/example.gif)

## Installation

G8 is available through [Swift Package Manager](https://swift.org/package-manager/)

## Setup

I suggest you to arrange color, font and dimension palettes using one or more nested enums containing static lets. That way, it will be easier to modify your palettes updating all the app theme in one shot, without the use of troublesome and dangerous literals all over.

Example:

```swift
enum ThemeConstants {
    enum Colors {
        static let brand = UIColor(red: 0.4, green: 0.7, blue: 0.1, alpha: 1)
        static let commonText = UIColor(named: "CommonText") // from assets
        static let background = UIColor(white: 0.9, alpha: 1)
    }
    enum FontNames {
        static let regular = "HelveticaNeue-Light"
        static let bold = "HelveticaNeue-Bold"
    }
    enum Fonts {
        static let common = UIFont(name: FontNames.regular, size: 16)
        static let commonBold = UIFont(name: FontNames.bold, size: 16)
    }
}
```

Now you can start defining your styles.

## G8Style

A `G8Style` style is basically a `struct` - who wraps a `[String: Any?]` dictionary - and can be defined as a dictionary itself.
Every `value` in the dictionary contains another `G8Style` or a specific value to assign (e.g. a color, a font, ...).
Every `key` in the dictionary must contain a `String` pointing to:
- a UIKit object if `value` is another style
- a property of the UIKit object if `value` contains a value to set

The `key` can always be a string keypath. **G8** provides the keys to access all managed properties for UIKit views through static enums, in order to limit the use of literals.

Here an example:

```swift
static let viewController: G8Style = [                                          // 1.
    "label1.textColor": UIColor.red,                                            // 2.
    "label2": boldLabel,                                                        // 3.
    "label3": commonLabelColored,
    "label4": [                                                                 // 4.
        G8K.Label.font: UIFont.italicSystemFont(ofSize: 30),                    // 5.
        G8K.Label.textColor: UIColor.darkGray,
        G8K.Label.textAlignment: NSTextAlignment.right,
        G8K.Label.lineBreakMode: NSLineBreakMode.byTruncatingHead
    ],
    "colorView": [
        G8K.View.backgroundColor: ThemeConstants.Colors.background              // 6.
    ],
...
]
```

1. new style instance
2. there must be a property named `label1` with a property named `textColor` on the object to whom the style `viewController` will be applied, and that property should be of `UIColor` type and will be set to  UIColor.red
3. a style named `boldLabel` will be applied to property `label2`
4. this is a inline defined style - use inline styles only if you don't intend to reuse them
5. accessing to property `font` of `label4` - a `UILabel` - using predefined **G8** keys contained in the `G8K` enum, alias of `G8.Keys`
6. the value applied is from the constants palette enum

## How to apply a style

It's very easy to apply a `G8Style` style to any object: starting from a **G8** instance - can be a global one - you can call the   function
```swift
func applyStyle(_ style: G8Style, to object: Any)
```
passing the style and the object.

```swift
var g8 = G8()
g8.applyStyle(DefaultTheme.viewController, to: self)
```

You can of course define the style inline, without using any stored style.

## Logging

The **G8** instance provides a logger: it allows to write on the XCode console infos and errors, to help you debug issues.
Available loggin levels are:
- `error`: **G8** write only errors, as if you are trying to write a property using a wrong type (writing a font on a backgroundColor)
- `warning`: **G8** also writes warnings, like a property who can't be found in the current object
- `verbose`: **G8** writes everything it does: every value applied to a property or every traversed keypath

The default logging level is `warning`. Logging works calling the `print` function.

## Custom `G8ValueApplier`s

**G8** works using a bunch of valueAppliers: it crosses the kaypath string - if any - getting the final object - `label1` in the point 2 of the example code above - and it tries to set the property.
Every time you try to apply a value (not a style) to a property, **G8** gets its type and all of super-types and searches a valueApplier for these types. If any, it searches for a property to set in that valueApplier.
For example, if you have a `UILabel`, the property will be searched in the `UILabel` valueApplier and in the `UIView` valueApplier too.

You can define a new custom `G8ValueApplier` and register it on your **G8** instance the manage your custom views and widgets.
The `G8ValueApplier` struct requires a generic type `T` - the valueApplier managed type - and is instantiated defining the closure that is called to apply a property value on the `T`-type objects. Here's what the closure gives you:
- `value`: the value to be applied to the property
- `object`: the object of type `T`
- `keyString`: the name of the property to be set, as `String`
- `key`: the property to be set, as `G8Key` - a inner **G8** type, can be useful in some specific cases

Tipically, in the closure you may want to do a `switch` on the `keyString` value and call the function
```swift
applyValue<T, O: AnyObject>(_ value: Any, to object: O, at keyPath: ReferenceWritableKeyPath<O, T>)
```
to convert the `keyString` string in a `KeyPath` of `object` to set `value`.
The closure returns a `Bool` indicating if the value has been managed by the current valueApplier or not. This is useful for logging purposes.

You can find many examples of `G8ValueApplier`s in the `G8ValueApplier` struct.
Here an example:

```swift
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
```

Finally, you have to register the newly defined valueApplier to your **G8** instance with either the `add(valueApplier: ValueApplier)` of the `add(valueAppliers: [ValueApplier])` function:
```swift
var g8 = G8()
g8.add(valueApplier: themeableLabel)
```

## License

G8 is available under the MIT license. See the LICENSE file for more info.

