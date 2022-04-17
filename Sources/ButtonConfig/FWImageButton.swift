//
//  FWImageButton.swift
//  
//
//  Created by Franklyn Weber on 16/02/2021.
//

import SwiftUI
import FWMenu


public struct FWImageButton: View {
    
    let config: ImageButtonConfig
    
    internal var fixedSize: CGSize?
    internal var font: Font?
    internal var accentColor: Color?
    
    
    public init(_ config: ImageButtonConfig) {
        self.config = config
    }
    
    public var body: some View {
        
        switch config.itemType {
        case .button(let action):
            
            let button = Button(action: {
                action()
            }) {
                sized(fixedSize)
                    .withFont(font)
                    .withColor(accentColor)
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
                sized(fixedSize)
                    .withFont(font)
                    .withColor(accentColor)
            }
            
            AnyView(menu)
            
        case .fwMenu(_, let menuContent):
            
            let imageSystemName = config.iconName.systemImageName
            
            FWMenu(imageSystemName: imageSystemName, sections: menuContent)
        }
    }
    
    @ViewBuilder
    private func sized(_ size: CGSize?) -> some View {
        if let size = size {
            Image(systemName: config.iconName.systemImageName)
                .resizable()
                .frame(width: size.width, height: size.height)
        } else {
            Image(systemName: config.iconName.systemImageName)
        }
    }
}


extension FWImageButton {
    
    public func fixedSize(_ fixedSize: CGSize) -> Self {
        var copy = self
        copy.fixedSize = fixedSize
        return copy
    }
    
    public func font(_ font: Font) -> Self {
        var copy = self
        copy.font = font
        return copy
    }
    
    public func accentColor(_ accentColor: Color) -> Self {
        var copy = self
        copy.accentColor = accentColor
        return copy
    }
}


fileprivate extension View {
    
    @ViewBuilder
    func withFont(_ font: Font?) -> some View {
        if let font = font {
            self.font(font)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func withColor(_ color: Color?) -> some View {
        if let color = color {
            self.accentColor(color)
        } else {
            self
        }
    }
}
