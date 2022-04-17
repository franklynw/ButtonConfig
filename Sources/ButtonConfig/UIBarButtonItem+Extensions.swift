//
//  UIBarButtonItem+Extensions.swift
//
//
//  Created by Franklyn Weber on 13/02/2021.
//

import UIKit
import FWCommonProtocols


private var actionAssociationKey: UInt8 = 0

public extension UIBarButtonItem {
    
    private var _action: (() -> ())? {
        get {
            return objc_getAssociatedObject(self, &actionAssociationKey) as? () -> ()
        }
        set {
            objc_setAssociatedObject(self, &actionAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    static func button(with imageName: SystemImageNaming, action: @escaping () -> ()) -> UIBarButtonItem {
        
        let button = UIBarButtonItem(image: UIImage(systemName: imageName.systemImageName), style: .plain, target: self, action: #selector(buttonPressed))
        button._action = action
        
        return button
    }
    
    static func button(with image: UIImage, action: @escaping () -> ()) -> UIBarButtonItem {
        
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(buttonPressed))
        button._action = action
        
        return button
    }
    
    @objc
    private static func buttonPressed(_ sender: UIBarButtonItem) {
        sender._action?()
    }
}
