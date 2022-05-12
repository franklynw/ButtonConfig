//
//  ImageButtonConfig.swift
//
//  Created by Franklyn Weber on 12/02/2021.
//

import SwiftUI
import FWCommonProtocols
import FWMenu


public struct ImageButtonConfig: Identifiable {
    
    public let id: String
    
    let iconName: SystemImageNaming
    let image: UIImage?
    let itemType: ButtonType
    
    public enum ButtonType: Equatable {
        case button(action: () -> ())
        case menu(menuSections: [MenuSection])
        case fwMenu(menuType: FWMenuType = .standard, menuSections: () -> [FWMenuSection])
        
        public static func == (lhs: ButtonType, rhs: ButtonType) -> Bool {
            switch (lhs, rhs) {
            case (.button, .button), (.menu, .menu), (.fwMenu, fwMenu):
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
            case .button, .fwMenu:
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
    ///   - menuSections: the sub-menu items which will apeear when this item is selected
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
    ///   - menuSections: the sub-menu items which will apeear when this item is selected
    /// - Returns: a ButtonConfig instance
    public init(image: UIImage, menuSections: [MenuSection]) {
        id = UUID().uuidString
        itemType = .menu(menuSections: menuSections)
        self.iconName = "none"
        self.image = image
    }
    
    /// Initialiser for a sub-menu item
    /// - Parameters:
    ///   - systemImage: a systemImage to use for the icon - if nil, no icon will appear
    ///   - menuSections: closure returning the sub-menu items which will apeear when this item is selected
    /// - Returns: a ButtonConfig instance
    public init(systemImage: SystemImageNaming, menuType: FWMenuType = .standard, menuSections: @escaping () -> [FWMenuSection]) {
        id = UUID().uuidString
        itemType = .fwMenu(menuType: menuType, menuSections: menuSections)
        self.iconName = systemImage
        image = nil
    }
    
    /// Initialiser for a sub-menu item
    /// - Parameters:
    ///   - image: a UIImage
    ///   - menuSections: closure returning the sub-menu items which will apeear when this item is selected
    /// - Returns: a ButtonConfig instance
    public init(image: UIImage, menuType: FWMenuType = .standard, menuSections: @escaping () -> [FWMenuSection]) {
        id = UUID().uuidString
        itemType = .fwMenu(menuType: menuType, menuSections: menuSections)
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
            
        case .fwMenu:
            
            var button: UIButton!
            
            let buttonAction = UIAction { _ in
                let buttonRect = button.convert(button.frame, to: nil)
                MenuPresenter.present(parent: self, with: buttonRect)
            }
            button = UIButton(type: .system, primaryAction: buttonAction)
            button.setImage(image ?? UIImage(systemName: iconName.systemImageName), for: UIControl.State())
            
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
            
        case .fwMenu:
            
            let action = {
                MenuPresenter.presentFromNavBar(parent: self, withRelativeX: 0.5)
            }
            
            if let image = image {
                return UIBarButtonItem.button(with: image, action: action)
            }
            
            return UIBarButtonItem.button(with: iconName, action: action)
        }
    }
    
    public func configureButton(_ button: UIButton, additionalAction: (() -> ())? = nil) {
        
        switch self.itemType {
        case .button(let action):
            
            let buttonAction = UIAction { _ in
                action()
                additionalAction?()
            }
            button.addAction(buttonAction, for: .touchUpInside)
            button.setImage(image ?? UIImage(systemName: iconName.systemImageName), for: UIControl.State())
            
        case .menu(let menuSections):
            
            button.setImage(image ?? UIImage(systemName: iconName.systemImageName), for: UIControl.State())
            
            let menuItems = menuSections.map { UIMenu(title: "", options: .displayInline, children: $0.menuItems.compactMap { $0.menuItem() })}
            let menu = UIMenu(title: "", children: menuItems)
            
            button.menu = menu
            
        case .fwMenu:
            
            let buttonAction = UIAction { _ in
                let buttonRect = button.convert(button.frame, to: nil)
                MenuPresenter.present(parent: self, with: buttonRect)
            }
            button.addAction(buttonAction, for: .touchUpInside)
            button.setImage(image ?? UIImage(systemName: iconName.systemImageName), for: UIControl.State())
        }
    }
}


extension ImageButtonConfig: FWMenuPresenting {
    
    public var content: () -> [FWMenuSection] {
        
        switch itemType {
        case .fwMenu(_, let menuSections):
            return menuSections
        default:
            fatalError("This item type doesn't support FWMenu")
        }
    }
    
    public var menuType: FWMenuType {
        
        switch itemType {
        case .fwMenu(let menuType, _):
            return menuType
        default:
            fatalError("This item type doesn't support FWMenu")
        }
    }
    
    public var contentBackgroundColor: Color? {
        return nil
    }
    
    public var contentAccentColor: Color? {
        return nil
    }
    
    public var font: Font? {
        return nil
    }
    
    public var forceFullScreen: Bool {
        
        switch itemType {
        case .fwMenu(let menuType, _):
            switch menuType {
            case .standard(_, let presentedFromKeyboardAccessory), .settings(_, let presentedFromKeyboardAccessory):
                return presentedFromKeyboardAccessory
            }
        default:
            fatalError("This item type doesn't support FWMenu")
        }
    }
}
