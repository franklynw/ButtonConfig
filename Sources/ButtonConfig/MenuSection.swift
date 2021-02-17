//
//  MenuSection.swift
//  
//
//  Created by Franklyn Weber on 17/02/2021.
//

import Foundation


public struct MenuSection: Identifiable {
    
    public let id = UUID().uuidString
    public let menuItems: [ButtonConfig]
    
    public init(_ menuItems: [ButtonConfig]) {
        self.menuItems = menuItems
    }
}
