//
//  AdvertisingCollectionViewCell.swift
//  DeliveryManeViewTestingTask
//
//  Created by Александр Макаров on 14.10.2022.
//

import UIKit

protocol AdvertisingCollectionViewCellProtocol: AnyObject {
    // Устанавливает изображение в имэйджВью
    func setImage(image: UIImage)
}

// Ячейка для отображения рекламного баннера
final class AdvertisingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    
    // Идентификатор ячейки
    static let cellIdentifier = "AdvertisingCollectionViewCell"
    
    // Презентер ячейки
    var presenter: AdvertisingCollectionViewCellPresenterProtocol!
    // Данные для отображения
    var advertising: Advertising! {
        didSet {
            presenter = AdvertisingCollectionViewCellPresenter(view: self, advertising: advertising)
            presenter.setUpItemImage()
        }
    }
    
    // MARK: - Private Properties
    
    //    Вью для изображения с рекламным баннером в ячейке  и его первичная настройка
    private lazy var advertisingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        return imageView
    }()
    
    // MARK: - Initializers
    
    // Кастомный инициализатор
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews(advertisingImageView)
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    // Установка подвью
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            contentView.addSubview(subview)
        }
    }
    
    // Установка и настройка констрейнтов
    private func setConstraints() {
        
        advertisingImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate ([
            advertisingImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            advertisingImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            advertisingImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            advertisingImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}


extension AdvertisingCollectionViewCell: AdvertisingCollectionViewCellProtocol {
    func setImage(image: UIImage) {
        advertisingImageView.image = image
    }
}
