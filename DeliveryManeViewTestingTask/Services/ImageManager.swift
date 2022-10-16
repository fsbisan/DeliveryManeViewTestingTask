//
//  ImageManager.swift
//  DeliveryManeViewTestingTask
//
//  Created by Александр Макаров on 13.10.2022.
//

import Foundation

// Менеджер для получения изображений из сети

class ImageManager {
    static var shared = ImageManager()

    init(){}

    func fetchImage(from food: Food, completion: @escaping(Data, URLResponse) -> Void) {
        guard let stringUrl = food.imageUrl else { return }
        guard let url = URL(string: stringUrl) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response else {
                print(error?.localizedDescription ?? "No error description")
                return
            }

            guard url == response.url else { return }
            DispatchQueue.main.async {
                completion(data, response)
            }

        }.resume()
    }
}
