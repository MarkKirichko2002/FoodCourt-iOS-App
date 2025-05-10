//
//  WorkingStatus.swift
//  FoodCourt
//
//  Created by Марк Киричко on 02.12.2024.
//

import Foundation

enum WorkingStatus: CaseIterable, Codable {
    
    case work
    case notwork
    
    var title: String {
        switch self {
        case .work:
            return "Работаю"
        case .notwork:
            return "Не работаю"
        }
    }
    
    var value: Int {
        switch self {
        case .work:
            return 1
        case .notwork:
            return 0
        }
    }
}
