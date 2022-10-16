//
//  AdvertisingCollectionViewCellPresenter.swift
//  DeliveryManeViewTestingTask
//
//  Created by Александр Макаров on 14.10.2022.
//

import Foundation
import UIKit

protocol AdvertisingCollectionViewCellPresenterProtocol {
    // Настраивает изображение для установки его в имэйджВью
    func setUpItemImage()
    init(view: AdvertisingCollectionViewCellProtocol, advertising: Advertising)
}

final class AdvertisingCollectionViewCellPresenter {
    
    // Вью ячейки
    private unowned let view: AdvertisingCollectionViewCellProtocol
    // Данные рекламы для отображения
    private let advertising: Advertising
    
    required init(view: AdvertisingCollectionViewCellProtocol, advertising: Advertising) {
        self.view = view
        self.advertising = advertising
    }
}

extension AdvertisingCollectionViewCellPresenter: AdvertisingCollectionViewCellPresenterProtocol {
    func setUpItemImage() {
        guard let image = UIImage(named: advertising.rawValue) else { return }
        view.setImage(image: image)
    }
}
