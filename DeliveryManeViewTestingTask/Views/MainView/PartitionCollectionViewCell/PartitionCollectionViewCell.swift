//
//  PartitionCollectionViewCell.swift
//  DeliveryManeViewTestingTask
//
//  Created by Александр Макаров on 14.10.2022.
//

import UIKit

protocol PartitionCollectionViewCellProtocol: AnyObject {
    // Устанавливаем текст в лэйбел ячейки
    func setLabelText(text: String)
}

// Ячейка для раздела с едой
final class PartitionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    
    // Идентификатор
    static let cellIdentifier = "PartitionCollectionViewCell"
    
    // Презентер ячейки
    var presenter: PartitionCollectionViewCellPresenterProtocol!
    
    // Данные для отображения
    var partition: Partition! {
        didSet {
            presenter = PartitionCollectionViewCellPresenter(view: self, partition: partition)
            presenter.setUpItemLabelText()
        }
    }
    
    // MARK: - Private Properties
    
    // Лэйбл с наименованием раздела
    private lazy var itemLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)
        return label
    }()
    
    // MARK: - Initializers
    
    // Кастомный инициализатор ячейки
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = CGColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        contentView.layer.cornerRadius = contentView.layer.frame.height / 2
        setupSubviews(itemLabel)
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Properties
    
    // Выбрана ли ячейка
    override var isSelected: Bool {
        willSet {
            onSelected(newValue)
        }
    }
    
    // MARK: - Private Methods
    // Изменяет отображение ячейки с выделенного состояния и обратно
    private func onSelected(_ newValue: Bool) {
        itemLabel.textColor = newValue ? UIColor.red : UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.5)
        itemLabel.font = newValue ?
        UIFont.systemFont(ofSize: 12, weight: .bold) :
        UIFont.systemFont(ofSize: 12)
        
        contentView.backgroundColor = newValue ? UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1) : UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        contentView.layer.borderWidth = newValue ? 0 : 0.5
    }
    
    // Устанавливает все подвиды
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            contentView.addSubview(subview)
        }
    }
    
    // Устанавливает все констрейнты на элементы ячейки
    private func setConstraints() {
        
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate ([
            itemLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itemLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            itemLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}

extension PartitionCollectionViewCell: PartitionCollectionViewCellProtocol {
    func setLabelText(text: String) {
        itemLabel.text = text
    }
}
