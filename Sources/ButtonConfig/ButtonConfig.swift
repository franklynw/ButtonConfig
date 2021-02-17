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
    ///   - title: the button's title
    ///   - systemImage: a systemImage to use for the icon - if nil, no icon will appear
    ///   - shouldAppear: a closure to control whether or not the menu item should appear
    ///   - action: the action invoked when the item is selected
    /// - Returns: a ButtonConfig instance
    public init(title: String? = nil, systemImage: SystemImageNaming? = nil, shouldAppear: (() -> Bool)? = nil, action: @escaping () -> ()) {
        id = UUID().uuidString
        itemType = .button(action: action)
        self.title = title ?? ""
        self.iconName = systemImage
        self.shouldAppear = shouldAppear ?? { true }
    }
    
    /// Initialiser for a sub-menu item
    /// - Parameters:
    ///   - title: the button's title
    ///   - systemImage: a systemImage to use for the icon - if nil, no icon will appear
    ///   - shouldAppear: a closure to control whether or not the menu item should appear
    ///   - subButtons: the sub-menu items which will apeear when this item is selected
    /// - Returns: a ButtonConfig instance
    public init(title: String? = nil, systemImage: SystemImageNaming? = nil, shouldAppear: (() -> Bool)? = nil, menuSections: [MenuSection]) {
        id = UUID().uuidString
        itemType = .menu(menuSections: menuSections)
        self.title = title ?? ""
        self.iconName = systemImage
        self.shouldAppear = shouldAppear ?? { true }
    }
    
    /// The view for this Button
    /// - Parameter itemId: the item's id
    /// - Returns: an AnyView instance, either a button row or a sub-menu row
    @ViewBuilder
    public func item() -> some View {
        
        switch itemType {
        case .button(let action):
            
            let button = Button(action: {
                action()
            }) {
                Text(title)
                
                if let iconName = iconName {
                    Image(systemName: iconName.systemImageName)
                }
            }
            
            AnyView(button)
            
        case .menu(let menuSections):
            
            let menu = Menu {
                ForEach(menuSections) { menuSection in
                    Section {
                        ForEach(menuSection.menuItems) { menuItem in
                            menuItem.item()
                        }
                    }
                }
            } label: {
                Label(title, systemImage: iconName?.systemImageName ?? "chevron.right")
            }
            
            AnyView(menu)
        }
    }
}


extension ButtonConfig {
    
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
        case .menu(let menuSections):
            
            let menuItems = menuSections.map { UIMenu(title: "", options: .displayInline, children: $0.menuItems.compactMap { $0.menuItem() })}
            
            return UIMenu(title: title, image: UIImage(systemName: "chevron.right"), children: menuItems)
        }
    }
}
