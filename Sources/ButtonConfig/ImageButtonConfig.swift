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
    let image: UIImage?
    let itemType: ButtonType
    
    public enum ButtonType: Equatable {
        case button(action: () -> ())
        case menu(menuSections: [MenuSection])
        
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
        
        func menuSections() -> [MenuSection] {
            switch self {
            case .button:
                return []
            case .menu(let menuSections):
                return menuSections
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
        image = nil
    }
    
    /// Initialiser for a button item
    /// - Parameters:
    ///   - image: a UIImage
    ///   - action: the action invoked when the item is selected
    /// - Returns: a ButtonConfig instance
    public init(image: UIImage, action: @escaping () -> ()) {
        id = UUID().uuidString
        itemType = .button(action: action)
        self.iconName = "none"
        self.image = image
    }
    
    /// Initialiser for a sub-menu item
    /// - Parameters:
    ///   - systemImage: a systemImage to use for the icon - if nil, no icon will appear
    ///   - subButtons: the sub-menu items which will apeear when this item is selected
    /// - Returns: a ButtonConfig instance
    public init(systemImage: SystemImageNaming, menuSections: [MenuSection]) {
        id = UUID().uuidString
        itemType = .menu(menuSections: menuSections)
        self.iconName = systemImage
        image = nil
    }
    
    /// Initialiser for a sub-menu item
    /// - Parameters:
    ///   - image: a UIImage
    ///   - subButtons: the sub-menu items which will apeear when this item is selected
    /// - Returns: a ButtonConfig instance
    public init(image: UIImage, menuSections: [MenuSection]) {
        id = UUID().uuidString
        itemType = .menu(menuSections: menuSections)
        self.iconName = "none"
        self.image = image
    }
}


extension ImageButtonConfig {
    
    public var button: UIButton {
        
        switch self.itemType {
        case .button(let action):
            
            let buttonAction = UIAction { _ in
                action()
            }
            let button = UIButton(type: .system, primaryAction: buttonAction)
            button.setImage(image ?? UIImage(systemName: iconName.systemImageName), for: UIControl.State())
            
            return button
            
        case .menu(let menuSections):
            
            let button = UIButton(type: .system)
            button.setImage(image ?? UIImage(systemName: iconName.systemImageName), for: UIControl.State())
            
            let menuItems = menuSections.map { UIMenu(title: "", options: .displayInline, children: $0.menuItems.compactMap { $0.menuItem() })}
            let menu = UIMenu(title: "", children: menuItems)
            
            button.menu = menu
            
            return button
        }
    }
    
    public var barButtonItem: UIBarButtonItem {
        
        switch self.itemType {
        case .button(let action):
            if let image = image {
                return UIBarButtonItem.button(with: image, action: action)
            }
            return UIBarButtonItem.button(with: iconName, action: action)
        case .menu(let menuSections):
            
            let menuItems = menuSections.map { UIMenu(title: "", options: .displayInline, children: $0.menuItems.compactMap { $0.menuItem() })}
            
            let button = UIBarButtonItem(image: image ?? UIImage(systemName: iconName.systemImageName), style: .plain, target: nil, action: nil)
            let menu = UIMenu(title: "", children: menuItems)
            
            button.menu = menu
            
            return button
        }
    }
}
