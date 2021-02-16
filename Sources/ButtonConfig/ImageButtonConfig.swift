//
//  ImageButtonConfig.swift
//
//  Created by Franklyn Weber on 12/02/2021.
//

import SwiftUI
import FWCommonProtocols


public struct ImageButtonConfig: Identifiable {
    
    public let id: String
    
    let iconName: SystemImageNaming
    let itemType: ButtonType
    
    public enum ButtonType: Equatable {
        case button(action: () -> ())
        case menu(subMenus: [ButtonConfig])
        
        public static func == (lhs: ButtonType, rhs: ButtonType) -> Bool {
            switch (lhs, rhs) {
            case (.button, .button), (.menu, .menu):
                return true
            default:
                return false
            }
        }
        
        var isButton: Bool {
            if case .button = self {
                return true
            }
            return false
        }
        var isMenu: Bool {
            if case .menu = self {
                return true
            }
            return false
        }
        
        func subButtons(parentId: String) -> [ButtonConfig] {
            switch self {
            case .button:
                return []
            case .menu(let subButtons):
                return subButtons
            }
        }
    }
    
    
    /// Initialiser for a button item
    /// - Parameters:
    ///   - systemImage: a systemImage to use for the icon - if nil, no icon will appear
    ///   - action: the action invoked when the item is selected
    /// - Returns: a ButtonConfig instance
    public init(systemImage: SystemImageNaming, action: @escaping () -> ()) {
        id = UUID().uuidString
        itemType = .button(action: action)
        self.iconName = systemImage
    }
    
    /// Initialiser for a sub-menu item
    /// - Parameters:
    ///   - systemImage: a systemImage to use for the icon - if nil, no icon will appear
    ///   - subButtons: the sub-menu items which will apeear when this item is selected
    /// - Returns: a ButtonConfig instance
    public init(systemImage: SystemImageNaming, menuItems: [ButtonConfig]) {
        id = UUID().uuidString
        itemType = .menu(subMenus: menuItems)
        self.iconName = systemImage
    }
}


extension ImageButtonConfig {
    
    public var barButtonItem: UIBarButtonItem? {
        
        switch self.itemType {
        case .button(let action):
            return UIBarButtonItem.button(with: iconName, action: action)
        case .menu(let subButtons):
            
            let button = UIBarButtonItem(image: UIImage(systemName: iconName.systemImageName), style: .plain, target: nil, action: nil)
            let menu = UIMenu(title: "", children: subButtons.compactMap { $0.menuItem() })
            
            button.menu = menu
            
            return button
        }
    }
}
