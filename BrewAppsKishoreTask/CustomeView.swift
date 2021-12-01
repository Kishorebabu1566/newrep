//
//  CustomeView.swift
//  Digitaurant-Business
//
//  Created by Kishore Babu on 20/05/21.
//


import UIKit
   
@IBDesignable
class CustomView: UIView {

    @IBInspectable
    /// Should the corner be as circle
    public var circleCornerView: Bool {
        get {
            return min(bounds.size.height, bounds.size.width) / 2 == cornerRadiusView
        }
        set {
            cornerRadiusView = newValue ? min(bounds.size.height, bounds.size.width) / 2 : cornerRadiusView
        }
    }
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var cornerRadiusView: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = circleCornerView ? min(bounds.size.height, bounds.size.width) / 2 : newValue
            //abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    @IBInspectable
    /// Border color of view; also inspectable from Storyboard.
    public var borderColorView: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }
    }
    @IBInspectable
    /// Border width of view; also inspectable from Storyboard.
    public var borderWidthView: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable
    /// Shadow color of view; also inspectable from Storyboard.
    public var shadowColorView: UIColor? {
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    @IBInspectable
    /// Shadow offset of view; also inspectable from Storyboard.
    public var shadowOffsetView: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    @IBInspectable
    /// Shadow opacity of view; also inspectable from Storyboard.
    public var shadowOpacityView: Double {
        get {
            return Double(layer.shadowOpacity)
        }
        set {
            layer.shadowOpacity = Float(newValue)
        }
    }
    @IBInspectable
    /// Shadow radius of view; also inspectable from Storyboard.
    public var shadowRadiusView: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowShouldRasterizeView: Bool {
        get {
            return layer.shouldRasterize
        }
        set {
            layer.shouldRasterize = newValue
        }
    }
    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowRasterizationScaleView: CGFloat {
        get {
            return layer.rasterizationScale
        }
        set {
            layer.rasterizationScale = newValue
        }
    }
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var maskToBoundsView: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
}




// MARK: - Properties

public extension UIView {
    /// Size of view.
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.width = newValue.width
            self.height = newValue.height
        }
    }
    /// Width of view.
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    /// Height of view.
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
}

// MARK: - Methods

public extension UIView {
    
    typealias Configuration = (UIView) -> Swift.Void
    
    func config(configurate: Configuration?) {
        configurate?(self)
    }
    
    /// Set some or all corners radiuses of view.
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
        
    }
}



@IBDesignable
class CustomStackView: UIStackView {

    @IBInspectable
    /// Should the corner be as circle
    public var circleCornerView: Bool {
        get {
            return min(bounds.size.height, bounds.size.width) / 2 == cornerRadiusView
        }
        set {
            cornerRadiusView = newValue ? min(bounds.size.height, bounds.size.width) / 2 : cornerRadiusView
        }
    }
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var cornerRadiusView: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = circleCornerView ? min(bounds.size.height, bounds.size.width) / 2 : newValue
            //abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    @IBInspectable
    /// Border color of view; also inspectable from Storyboard.
    public var borderColorView: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }
    }
    @IBInspectable
    /// Border width of view; also inspectable from Storyboard.
    public var borderWidthView: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable
    /// Shadow color of view; also inspectable from Storyboard.
    public var shadowColorView: UIColor? {
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    @IBInspectable
    /// Shadow offset of view; also inspectable from Storyboard.
    public var shadowOffsetView: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    @IBInspectable
    /// Shadow opacity of view; also inspectable from Storyboard.
    public var shadowOpacityView: Double {
        get {
            return Double(layer.shadowOpacity)
        }
        set {
            layer.shadowOpacity = Float(newValue)
        }
    }
    @IBInspectable
    /// Shadow radius of view; also inspectable from Storyboard.
    public var shadowRadiusView: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowShouldRasterizeView: Bool {
        get {
            return layer.shouldRasterize
        }
        set {
            layer.shouldRasterize = newValue
        }
    }
    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowRasterizationScaleView: CGFloat {
        get {
            return layer.rasterizationScale
        }
        set {
            layer.rasterizationScale = newValue
        }
    }
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var maskToBoundsView: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
}

