//
//  MainViewControllerPresenter.swift
//  DeliveryManeViewTestingTask
//
//  Created by Александр Макаров on 13.10.2022.
//




// MARK: - Override Methods


// MARK: - Private Methods

import Foundation

protocol MainViewControllerPresenterProtocol {
    func numberOfAdvertisingItems() -> Int
    func numberOfPartitionItems() -> Int
    func numberOfFoodRows() -> Int
    func getFoods()
    func getFood(at indexPath: IndexPath) -> Food
    
    func getPartition(at indexPath: IndexPath) -> Partition
    func currentPartition(at indexPath: IndexPath)
    
    func getAdvertising(at indexPath: IndexPath) -> Advertising
    func currentAdvertising(at indexPath: IndexPath) -> Advertising
    
    func setTownLabelText() -> String
    init(view: MainViewController, foods: [Food], partitions: [Partition], advertisings: [Advertising])
}


final class MainViewControllerPresenter {
    
    // MARK: - Private Proeprties
    
    private let partitions: [Partition]
    private let advertisings: [Advertising]
    private var foods: [Food]
    
    unowned private var view: MainViewController
    
    // MARK: - Initializers
    
    required init(view: MainViewController, foods: [Food], partitions: [Partition], advertisings: [Advertising]) {
        self.partitions = partitions
        self.foods = foods
        self.view = view
        self.advertisings = advertisings
    }
}

extension MainViewControllerPresenter: MainViewControllerPresenterProtocol {
    
    func getFood(at indexPath: IndexPath) -> Food {
        foods[indexPath.row]
    }
    
    func getFoods() {
        NetworkManager.shared.fetchMenu { [weak self] result in
            switch result {
            case .success(let foods):
                self?.foods = foods.foods ?? []
                self?.view.reloadTableViewData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func numberOfFoodRows() -> Int {
        foods.count
    }
    
    func numberOfAdvertisingItems() -> Int {
        advertisings.count
    }
    
    func numberOfPartitionItems() -> Int {
        partitions.count
    }
    
    func setTownLabelText() -> String {
        "Москва"
    }
    
    func getPartition(at indexPath: IndexPath) -> Partition {
        partitions[indexPath.item]
    }
    
    func currentPartition(at indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            foods = foods.shuffled()
            view.reloadTableViewData()
        case 1:
            foods = foods.shuffled()
            view.reloadTableViewData()
        case 2:
            foods = foods.shuffled()
            view.reloadTableViewData()
        default:
            break
        }
    }
    
    func getAdvertising(at indexPath: IndexPath) -> Advertising {
        advertisings[indexPath.item]
    }
    
    func currentAdvertising(at indexPath: IndexPath) -> Advertising {
        advertisings[indexPath.item]
    }
}
