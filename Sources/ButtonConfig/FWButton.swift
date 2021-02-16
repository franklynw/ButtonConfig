//
//  FWButton.swift
//  
//
//  Created by Franklyn Weber on 16/02/2021.
//

import SwiftUI


public struct FWButton: View {
    
    let config: ButtonConfig
    
    
    public var body: some View {
        
        switch config.itemType {
        case .button(let action):
            
            let button = Button(action: {
                action()
            }) {
                Text(config.title)
                
                if let iconName = config.iconName {
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
                Label(config.title, systemImage: config.iconName?.systemImageName ?? "chevron.right")
            }
            
            AnyView(menu)
        }
    }
}
