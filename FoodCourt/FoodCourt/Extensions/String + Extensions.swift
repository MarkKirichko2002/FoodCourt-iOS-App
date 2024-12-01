//
//  String + Extensions.swift
//  FoodCourt
//
//  Created by Марк Киричко on 20.11.2024.
//

import Foundation

extension String {
    
    func convertText()-> String {
        return String(self.replacing(/[^0-9]/, with: "").prefix(11))
    }
    
    func convertImage()-> String {
        if self.isEmpty {
            return "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbdb17ZVJkHnPC6RtB-hpl3y84QgfB6M7Uxw&s"
        } else {
            return self
        }
    }
}
