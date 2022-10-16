//
//  NetworkManager.swift
//  DeliveryManeViewTestingTask
//
//  Created by Александр Макаров on 13.10.2022.
//

import UIKit

// Виды ошибок при работе с сетью

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

// Менеджер работы с сетью через UrlSession

class NetworkManager {
    
    static var shared = NetworkManager()
    
    func fetchMenu(completion: @escaping(Result<FoodList, NetworkError>) -> Void) {
        
        guard let url = URL(string: "https://tasty.p.rapidapi.com/recipes/list?from=0&size=20&tags=under_30_minutes") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        let headers = [
            "X-RapidAPI-Key": "58137fde3emsh8935dfca4bafacep180f18jsn3a2e033f1134",
            "X-RapidAPI-Host": "tasty.p.rapidapi.com"
        ]
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let foodlist = try JSONDecoder().decode(FoodList.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(foodlist))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }

    private init() {}
}


