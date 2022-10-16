//
//  FoodTableViewCell.swift
//  DeliveryManeViewTestingTask
//
//  Created by Александр Макаров on 13.10.2022.
//

import UIKit

protocol FoodTableViewCellProtocol: AnyObject {
    // Установка изображение с блюдом во вью
    func showImage(data: Data)
    // Установка наименования блюда в лэйбл
    func showFoodName(foodName: String)
    // Установка описания блюда в лэйбл
    func showDescription(foodDescription: String)
    // Установка картинки с заглушкой
    func showErrorImage()
    // Установка надписи с заглушкой
    func showErrorDescription()
}

// Ячейка с изображением блюда его наименованием и описанием
final class FoodTableViewCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    // Идентификатор ячейки
    static var cellIdentifier = "FoodTableViewCell"
    // Презентер
    var presenter: FoodTableViewCellPresenterProtocol!
    
    // Экземпляр модели блюда
    var food: Food? {
        didSet {
            // Инициализация презентера
            presenter = FoodTableViewCellPresenter(view: self, food: food)
            // Устанавливаем изображение блюда
            presenter.setImage()
            // Устанавливаем имя блюда
            presenter.setFoodName()
        }
    }
    
    // MARK: - Private Properties
    
    // Вью с изображением блюда
    private lazy var foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.backgroundColor = .red
        return imageView
    }()
    
    // Лэйбл с наименованием блюда
    private lazy var foodNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    // Лэйбл с описанием блюда
    private lazy var foodDescriptionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Баварские колбаски, ветчина, пикантная пепперони, острая чоризо, моцарелла, томатный соус"
        label.textColor = .gray
        label.numberOfLines = 0

        return label
    }()
    
    // Лэйбл с ценой блюда
    private lazy var foodCostLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "от 345 р"
        label.textColor = .red
        label.textAlignment = .center
        label.layer.cornerRadius = 6
        label.layer.borderWidth = 0.5
        label.layer.borderColor = CGColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        return label
    }()
    
    // MARK: - Initializers
    
    // Кастомный инициализатор
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews(foodImageView, foodNameLabel, foodDescriptionLabel, foodCostLabel)
        backgroundColor = .white
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods
    
    // Очиска картинки перед переиспользованием ячейки
    override func prepareForReuse() {
        foodImageView.image = nil
    }
    
    // MARK: - Private Methods
    
    // Установка подвидов в основное вью
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            contentView.addSubview(subview)
        }
    }
    
    // Установка констрейнтов
    private func setConstraints() {
        
        foodNameLabel.translatesAutoresizingMaskIntoConstraints = false
        foodDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        foodImageView.translatesAutoresizingMaskIntoConstraints = false
        foodCostLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate ([
            foodImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: 24),
            foodImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                  constant: -24),
            foodImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: 16),
            foodImageView.widthAnchor.constraint(equalToConstant: 132),
            
            foodNameLabel.topAnchor.constraint(equalTo: foodImageView.topAnchor,
                                               constant: 0),
            foodNameLabel.leadingAnchor.constraint(equalTo: foodImageView.trailingAnchor, constant: 32),
            foodNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -16),
            
            foodDescriptionLabel.topAnchor.constraint(equalTo: foodNameLabel.bottomAnchor, constant: 8),
            foodDescriptionLabel.leadingAnchor.constraint(equalTo: foodNameLabel.leadingAnchor),
            foodDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            foodDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -40),
            
            foodCostLabel.topAnchor.constraint(equalTo: foodDescriptionLabel.bottomAnchor, constant: 12),
            foodCostLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            foodCostLabel.widthAnchor.constraint(equalToConstant: 87),
            foodCostLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
}

extension FoodTableViewCell: FoodTableViewCellProtocol {
    func showImage(data: Data) {
        guard let image = UIImage(data: data) else { return }
        foodImageView.image = image
    }
    
    func showFoodName(foodName: String) {
        foodNameLabel.text = foodName
    }
    
    func showDescription(foodDescription: String) {
        foodDescriptionLabel.text = foodDescription
    }
    
    func showErrorImage() {
        foodImageView.image = UIImage(named: "garryPotter")
    }
    
    func showErrorDescription() {
        foodDescriptionLabel.text = "Error, no data"
    }
}
