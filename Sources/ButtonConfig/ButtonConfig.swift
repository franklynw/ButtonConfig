//
//  ButtonConfig.swift
//
//  Created by Franklyn Weber on 12/02/2021.
//

import SwiftUI
import FWCommonProtocols


public struct ButtonConfig: Identifiable {
    
    public let id: String
    
    let title: String
    let iconName: SystemImageNaming?
    let shouldAppear: () -> Bool
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
    ///   - title: the menu item's title
    ///   - systemImage: a systemImage to use for the icon - if nil, no icon will appear
    ///   - shouldAppear: a closure to control whether or not the menu item should appear
    ///   - action: the action invoked when the item is selected
    /// - Returns: a ButtonConfig instance
    public init(title: String = "", systemImage: SystemImageNaming? = nil, shouldAppear: (() -> Bool)? = nil, action: @escaping () -> ()) {
        id = UUID().uuidString
        itemType = .button(action: action)
        self.title = title
        self.iconName = systemImage
        self.shouldAppear = shouldAppear ?? { true }
    }
    
    /// Initialiser for a sub-menu item
    /// - Parameters:
    ///   - title: the menu item's title
    ///   - systemImage: a systemImage to use for the icon - if nil, no icon will appear
    ///   - shouldAppear: a closure to control whether or not the menu item should appear
    ///   - subButtons: the sub-menu items which will apeear when this item is selected
    /// - Returns: a ButtonConfig instance
    public init(title: String = "", systemImage: SystemImageNaming? = nil, shouldAppear: (() -> Bool)? = nil, menuItems: [ButtonConfig]) {
        id = UUID().uuidString
        itemType = .menu(subMenus: menuItems)
        self.title = title
        self.iconName = systemImage
        self.shouldAppear = shouldAppear ?? { true }
    }
    
    /// The view for this Button
    /// - Parameter itemId: the item's id
    /// - Returns: an AnyView instance, either a button row or a sub-menu row
    @ViewBuilder
    public func item() -> some View {
        
        if shouldAppear() == true {
            
            switch itemType {
            case .button(let action):
                
                let button = Button(action: {
                    action()
                }) {
                    Text(self.title)
                    
                    if let iconName = iconName {
                        Image(systemName: iconName.systemImageName)
                    }
                }
                
                AnyView(button)
                
            case .menu(let subButtons):
                
                let menu = Menu {
                    ForEach(subButtons) { button in
                        button.item()
                    }
                } label: {
                    Label(self.title, systemImage: iconName?.systemImageName ?? "chevron.right")
                }
                
                AnyView(menu)
            }
        }
    }
}


extension ButtonConfig {
    
    public var barButtonItem: UIBarButtonItem? {
        
        guard let iconName = iconName else {
            return nil
        }
        
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
    
    public func menuItem() -> UIMenuElement? {
        
        guard shouldAppear() else {
            return nil
        }
        
        let image: UIImage?
        
        if let iconName = iconName {
            image = UIImage(systemName: iconName.systemImageName)
        } else {
            image = nil
        }
        
        switch itemType {
        case .button(let action):
            return UIAction(title: title, image: image) { _ in action() }
        case .menu(let subButtons):
            return UIMenu(title: title, image: UIImage(systemName: "chevron.right"), children: subButtons.compactMap { $0.menuItem() })
        }
    }
}
