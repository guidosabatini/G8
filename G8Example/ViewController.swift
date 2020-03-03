//
//  ViewController.swift
//  G8Example
//
//  Created by Guido Sabatini on 28/11/2019.
//

import UIKit
import G8

class ViewController: UIViewController {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var svitch: UISwitch!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var textview: UITextView!
    
    var g8 = G8()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        textfield.placeholder = "placeholder"
    }

    @IBAction func applyAction(_ sender: Any) {
        g8.applyStyle(DefaultTheme.viewController, to: self)
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        button1.isSelected = !button1.isSelected
    }
    
    @IBAction func button2Action(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(identifier: "vc") {
            navigationController?.setViewControllers([viewController], animated: true)
        }
    }
    
    deinit {
        print("DEINIT")
    }
}

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

enum DefaultTheme {
    static let commonLabel: G8Style = [
        G8K.Label.textColor: ThemeConstants.Colors.commonText,
        G8K.Label.font: ThemeConstants.Fonts.common
    ]
    static let boldLabel: G8Style = [
        G8K.superStyle: commonLabel,
        G8K.Label.font: ThemeConstants.Fonts.commonBold,
        G8K.View.backgroundColor: ThemeConstants.Colors.brand
    ]
    static let viewController: G8Style = [
        "label1.textColor": UIColor.red,
        "label2": boldLabel,
        "label3": commonLabelColored,
        "label4": [
            G8K.Label.font: UIFont.italicSystemFont(ofSize: 30),
            G8K.Label.textColor: UIColor.darkGray,
            G8K.Label.textAlignment: NSTextAlignment.right,
            G8K.Label.lineBreakMode: NSLineBreakMode.byTruncatingHead
        ],
        "colorView": [
            G8K.View.backgroundColor: ThemeConstants.Colors.background
        ],
        /*
        // alternative ways
        "colorView.backgroundColor": ThemeConstants.Colors.background,
        "colorView.\(GK.View.backgroundColor)": ThemeConstants.Colors.background,
         */
        "button1": [
            G8K.Button.titleFont: UIFont.italicSystemFont(ofSize: 16),
            G8K.Button.titleColor: UIColor.green,
            G8K.Button.titleColor.selected.highlighted.disabled: UIColor.red
        ],
        "button2": [
            G8K.View.tintColor: UIColor.red,
            G8K.Button.image: UIImage(named: "palette"),
            G8K.Button.backgroundImageFromColor: UIColor.lightGray,
            G8K.Button.titleColor: UIColor.blue,
            G8K.Button.titleFont: UIFont.systemFont(ofSize: 20)
        ],
        "innerView.layer": [
            G8K.Layer.backgroundColor: UIColor.red.cgColor,
            G8K.Layer.borderColor: UIColor.black.cgColor,
            G8K.Layer.borderWidth: 2.0,
            G8K.Layer.cornerRadius: 5.0,
            G8K.Layer.opacity: 0.7,
            G8K.Layer.shadowColor: UIColor.yellow.cgColor,
            G8K.Layer.shadowOffset: CGSize(width: 10, height: 10),
            G8K.Layer.shadowOpacity: 1.0,
            G8K.Layer.shadowRadius: 5.0
        ],
        "segmentedControl": [
            G8K.SegmentedControl.backgroundImageFromColor: UIColor.green,
            G8K.SegmentedControl.backgroundImageFromColor.selected: UIColor.red,
            G8K.SegmentedControl.font: UIFont.systemFont(ofSize: 10),
            G8K.SegmentedControl.font.selected: UIFont.boldSystemFont(ofSize: 15),
            G8K.SegmentedControl.selectedSegmentTintColor: UIColor.blue,
            G8K.SegmentedControl.textColor: UIColor.purple,
            G8K.SegmentedControl.textColor.selected: UIColor.white
        ],
        "textfield": [
            G8K.TextField.textColor: UIColor.darkGray,
            G8K.TextField.font: UIFont.italicSystemFont(ofSize: 20),
            G8K.TextField.textAlignment: NSTextAlignment.center,
            G8K.TextField.borderStyle: UITextField.BorderStyle.bezel,
            G8K.TextField.placeholderColor: UIColor.yellow,
            G8K.TextField.placeholderFont: UIFont.boldSystemFont(ofSize: 10)
        ],
        "slider": [
            G8K.Slider.minimumValueImage: UIImage(named: "home"),
            G8K.Slider.maximumValueImage: UIImage(named: "ninja"),
            G8K.Slider.minimumTrackTintColor: UIColor.red,
            G8K.Slider.maximumTrackTintColor: UIColor.green,
            G8K.Slider.thumbTintColor: UIColor.blue
        ],
        "svitch": [
            G8K.Switch.onTintColor: UIColor.blue,
            G8K.Switch.thumbTintColor: UIColor.green
        ],
        "imageview": [
            G8K.Image.image: UIImage(named: "ninja"),
            G8K.View.tintColor: UIColor.red,
            G8K.Image.highlightedImage: UIImage(named: "home")
        ],
        "textview": [
            G8K.TextView.textColor: UIColor.purple,
            G8K.TextView.font: UIFont.italicSystemFont(ofSize: 12),
            G8K.TextView.textAlignment: NSTextAlignment.justified
        ]
        
    ]
}

extension DefaultTheme {
    static let commonLabelColored: G8Style = [
        G8K.superStyle: commonLabel,
        G8K.Label.textColor: ThemeConstants.Colors.brand,
    ]
}
