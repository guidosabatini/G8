//
//  G8Keys.swift
//  G8
//
//  Created by Guido Sabatini on 15/11/2019.
//

// swiftlint:disable all
/// Shortcut
typealias G8K = G8.Keys

extension G8 {
    
    /// Complete list of the keys natively managed by G8, divided by UIKit classes
    public enum Keys {
        public static let superStyle = G8Key("superStyle")
        public enum View {
            public static let backgroundColor = G8Key("backgroundColor")
            public static let tintColor = G8Key("tintColor")
        }
        public enum Label {
            public static let textColor = G8Key("textColor")
            public static let font = G8Key("font")
            public static let textAlignment = G8Key("textAlignment")
            public static let lineBreakMode = G8Key("lineBreakMode")
        }
        public enum Button {
            public static let titleColor = G8UIControlKey("titleColor")
            public static let titleShadowColor = G8UIControlKey("titleShadowColor")
            public static let titleFont = G8Key("titleFont")
            public static let image = G8UIControlKey("image")
            public static let backgroundImage = G8UIControlKey("backgroundImage")
            public static let backgroundImageFromColor = G8UIControlKey("backgroundImageFromColor")
        }
        public enum Layer {
            public static let shadowColor = G8Key("shadowColor")
            public static let shadowRadius = G8Key("shadowRadius")
            public static let shadowOpacity = G8Key("shadowOpacity")
            public static let shadowOffset = G8Key("shadowOffset")
            public static let borderColor = G8Key("borderColor")
            public static let borderWidth = G8Key("borderWidth")
            public static let backgroundColor = G8Key("backgroundColor")
            public static let cornerRadius = G8Key("cornerRadius")
            public static let opacity = G8Key("opacity")
        }
        public enum SegmentedControl {
            public static let selectedSegmentTintColor = G8Key("selectedSegmentTintColor")
            public static let backgroundImage = G8UIControlKey("backgroundImage")
            public static let backgroundImageFromColor = G8UIControlKey("backgroundImageFromColor")
            public static let textColor = G8UIControlKey("textColor")
            public static let font = G8UIControlKey("font")
        }
        public enum TextField {
            public static let textColor = G8Key("textColor")
            public static let font = G8Key("font")
            public static let textAlignment = G8Key("textAlignment")
            public static let borderStyle = G8Key("borderStyle")
            public static let placeholderColor = G8Key("placeholderColor")
            public static let placeholderFont = G8Key("placeholderFont")
            public static let background = G8Key("background")
            public static let disabledBackground = G8Key("disabledBackground")
        }
        public enum Slider {
            public static let minimumValueImage = G8Key("minimumValueImage")
            public static let maximumValueImage = G8Key("maximumValueImage")
            public static let isContinuous = G8Key("isContinuous")
            public static let minimumTrackTintColor = G8Key("minimumTrackTintColor")
            public static let maximumTrackTintColor = G8Key("maximumTrackTintColor")
            public static let thumbTintColor = G8Key("thumbTintColor")
        }
        public enum Switch {
            public static let onTintColor = G8Key("onTintColor")
            public static let thumbTintColor = G8Key("thumbTintColor")
        }
        public enum Image {
            public static let image = G8Key("image")
            public static let highlightedImage = G8Key("highlightedImage")
        }
        public enum TextView {
            public static let textColor = G8Key("textColor")
            public static let font = G8Key("font")
            public static let textAlignment = G8Key("textAlignment")
        }
        
    }
}
