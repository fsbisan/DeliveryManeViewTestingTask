//
//  PartitionCollectionViewCellPresenter.swift
//  DeliveryManeViewTestingTask
//
//  Created by Александр Макаров on 14.10.2022.
//

import Foundation

protocol PartitionCollectionViewCellPresenterProtocol {
    // Устанавливаем текст в ячейку
    func setUpItemLabelText()
    // Инициализируем модель ячейки
    init(view: PartitionCollectionViewCellProtocol, partition: Partition)
}

// Презентер для ячейки разделов еды
final class PartitionCollectionViewCellPresenter {
    
    // MARK: - Public Properties
    
    private unowned let view: PartitionCollectionViewCellProtocol
    private let partition: Partition
    
    required init(view: PartitionCollectionViewCellProtocol, partition: Partition) {
        self.view = view
        self.partition = partition
    }
}


extension PartitionCollectionViewCellPresenter: PartitionCollectionViewCellPresenterProtocol {
    func setUpItemLabelText() {
        view.setLabelText(text: partition.rawValue)
    }
}
