//
//  Food.swift
//  DeliveryManeViewTestingTask
//
//  Created by Александр Макаров on 13.10.2022.
//

import Foundation

// Общая структура получаемых данных
struct FoodList: Decodable {
    let foods: [Food]?
    
    enum CodingKeys: String, CodingKey {
        case foods = "results"
    }
}

// Модель данных еды
struct Food: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case imageUrl = "thumbnail_url"
    }
}
