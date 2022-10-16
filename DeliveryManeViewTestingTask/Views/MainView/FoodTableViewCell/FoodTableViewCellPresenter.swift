//
//  FoodTableViewCellPresenter.swift
//  DeliveryManeViewTestingTask
//
//  Created by Александр Макаров on 13.10.2022.
//

import Foundation




// MARK: - Initializers
// MARK: - Override Methods

// MARK: - Public Methods
// MARK: - Private Methods

protocol FoodTableViewCellPresenterProtocol: AnyObject {
//    получение изображения блюда для его установки
    
    func setImage()
    //    получение имени блюда для его установки
    
    func setFoodName()
    // Сохранение данных изображения в кэш
    func saveDataToCache(with data: Data, and response: URLResponse)
    
    // Получение данных изображения из кэша
    func getCachedImage(from url: URL) -> Data?
    
    init(view: FoodTableViewCellProtocol, food: Food?)
}

final class FoodTableViewCellPresenter {
    // MARK: - Private Properties
    // Вью ячейки таблицы
    weak private var view: FoodTableViewCellProtocol?
    // Экземпляр модели блюда
    private var food: Food?
    
    required init(view: FoodTableViewCellProtocol, food: Food?) {
        self.view = view
        self.food = food
    }
}

extension FoodTableViewCellPresenter: FoodTableViewCellPresenterProtocol {
    
    func setImage() {
        guard let food = food else { return }
        guard let stringUrl = food.imageUrl else { return }
        
        guard let url = URL(string: stringUrl) else {
            guard self.view != nil else { return }
            self.view?.showErrorImage()
            return
        }
        
        // Используем изображение из кеша, если оно там есть
        if let cachedImageData = getCachedImage(from: url) {
            guard self.view != nil else { return }
            self.view?.showImage(data: cachedImageData)
            return
        }
        // Если изображения нет в кэше то загружаем из сети
        ImageManager.shared.fetchImage(from: food) { data, response in
            guard self.view != nil else { return }
            self.view?.showImage(data: data)
            self.saveDataToCache(with: data, and: response)
        }
    }
    
    func setFoodName() {
        guard let food = food else { return }
        guard let name = food.name else { return }
        guard self.view != nil else { return }
        view?.showFoodName(foodName: name)
    }
    
    func saveDataToCache(with data: Data, and response: URLResponse) {
        guard let url = response.url else { return }
        let urlRequest = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        
        URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
    }
    
    func getCachedImage(from url: URL) -> Data? {
        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            return cachedResponse.data
        }
        return nil
    }
}
