//
//  FWImageButton.swift
//  
//
//  Created by Franklyn Weber on 16/02/2021.
//

import SwiftUI


public struct FWImageButton: View {
    
    let config: ImageButtonConfig
    
    internal var fixedSize: CGSize?
    internal var font: Font?
    internal var accentColor: Color?
    
    
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
            
        case .menu(let subButtons):
            
            let menu = Menu {
                ForEach(subButtons) { button in
                    button.item()
                }
            } label: {
                sized(fixedSize)
                    .withFont(font)
                    .withColor(accentColor)
            }
            
            AnyView(menu)
        }
    }
    
    @ViewBuilder
    private func sized(_ size: CGSize?) -> some View {
        if let size = size {
            Image(systemName: config.iconName.systemImageName)
                .resizable()
                .frame(width: size.width, height: 27)
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
        }
    }
    
    @ViewBuilder
    func withColor(_ color: Color?) -> some View {
        if let color = color {
            self.accentColor(color)
        }
    }
}