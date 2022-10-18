//
//  MainViewController.swift
//  DeliveryManeViewTestingTask
//
//  Created by Александр Макаров on 13.10.2022.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Public Properties
    var currentPartition: Int = 0
    
    // MARK: - Private Properties
   
    // Презентер
    private var presenter: MainViewControllerPresenterProtocol!
   
    // Модель данных для отображения разделов в коллекшнВью
    private var partitions = Partition.allCases
    
    // Модель данных для наименования баннеров рекламных
    private var advertisings = Advertising.allCases
   
    // Модель данных со списком еды
    private var foods: [Food] = []
    
    // Высота рекламного коллекВью
    private var advertisingHeight: CGFloat = 0
    
    // Состояние для смещения высоты вью
    private var previousOffsetState: CGFloat = 0
    
    // Лэйбл с наименованием города
    private lazy var townLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    // Таблица с ячейками еды
    private lazy var foodTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FoodTableViewCell.self, forCellReuseIdentifier: FoodTableViewCell.cellIdentifier)
        // Высота ячейки таблицы
        tableView.rowHeight = 170
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        tableView.layer.cornerRadius = 10
        return tableView
    }()
    
    // Горизонтальный колл вью с рекламными баннерами
    private lazy var advertisingСollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AdvertisingCollectionViewCell.self, forCellWithReuseIdentifier: AdvertisingCollectionViewCell.cellIdentifier)
        return collectionView
    }()
    
    // Горизонтальный колл вью с разделами еды
    private lazy var partitionCollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PartitionCollectionViewCell.self, forCellWithReuseIdentifier: PartitionCollectionViewCell.cellIdentifier)
        return collectionView
    }()
    
    // Констрейнт отвечающий за расстояние от верха экрана до верха тэйблвью
    private lazy var constraintHeightOfAdvertisingView: NSLayoutConstraint = {
        let constraint = partitionCollectionView.topAnchor.constraint(equalTo: townLabel.bottomAnchor,
                                                                       constant: 150)
        return constraint
    }()
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        // Размер кэша для изображений
        URLCache.shared.diskCapacity = 30000000
        presenter = MainViewControllerPresenter(view: self, foods: foods, partitions: partitions, advertisings: advertisings)
        
        // Запрашиваем данные с едой
        presenter.getFoods()
        
        // Устанавливаем текст с наименованием города
        townLabel.text = presenter.setTownLabelText()
       
        setupSubviews(townLabel, advertisingСollectionView, partitionCollectionView,foodTableView)
        advertisingСollectionView.sendSubviewToBack(foodTableView)
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        partitionCollectionView.selectItem(at: IndexPath(index: 0), animated: true, scrollPosition: .left)
    }
    
    // MARK: - Public Methods
    
    // Перезагрузка таблицы
    func reloadTableViewData() {
        foodTableView.reloadData()
    }
    
    // MARK: - Private Methods
    
    // Установвка подвидов в родительский вью
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    // Установка констрейнтов
    private func setConstraints() {
        
        townLabel.translatesAutoresizingMaskIntoConstraints = false
        advertisingСollectionView.translatesAutoresizingMaskIntoConstraints = false
        partitionCollectionView.translatesAutoresizingMaskIntoConstraints = false
        foodTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate ([
            
            townLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            townLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            townLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 50),
            
            advertisingСollectionView.topAnchor.constraint(equalTo: townLabel.bottomAnchor,
                                                           constant: 10),
            advertisingСollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                               constant: 0),
            advertisingСollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                                constant: 0),
            advertisingСollectionView.heightAnchor.constraint(lessThanOrEqualToConstant: 150),
            
            constraintHeightOfAdvertisingView,
            partitionCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                             constant: 0),
            partitionCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                              constant: 0),
            partitionCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
            
            
            foodTableView.topAnchor.constraint(equalTo: partitionCollectionView.bottomAnchor,
                                               constant: 0),
            foodTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            foodTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            foodTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    private func deactivateConstraints() {
        NSLayoutConstraint.deactivate([partitionCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                                                    constant: advertisingHeight),])
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == advertisingСollectionView ?
        presenter.numberOfAdvertisingItems() :
        presenter.numberOfPartitionItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Рекламное кол вью
        if collectionView == advertisingСollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvertisingCollectionViewCell.cellIdentifier, for: indexPath) as! AdvertisingCollectionViewCell
            cell.advertising = presenter.getAdvertising(at: indexPath)
            return cell
            // Колл вью с разделами еды
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PartitionCollectionViewCell.cellIdentifier, for: indexPath) as! PartitionCollectionViewCell
            cell.partition = presenter.getPartition(at: indexPath)
            if indexPath.item == 0 {
                cell.isSelected = true
            } else {
                cell.isSelected = false
            }
            return cell
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.currentPartition(at: indexPath)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == advertisingСollectionView {
            return CGSize(width: 280, height: collectionView.frame.height - 32)
        } else {
            return CGSize(width: 92, height: collectionView.frame.height - 33)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == advertisingСollectionView {
            return UIEdgeInsets(top: 6, left: 16, bottom: 0, right: 16)
        } else {
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfFoodRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: FoodTableViewCell.cellIdentifier,
            for: indexPath
        ) as! FoodTableViewCell
        cell.food = presenter.getFood(at: indexPath)
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    
//    Сжимает вью с рекламой
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y > 150 {
            constraintHeightOfAdvertisingView.constant = 0
        }
        
        let offsetDiff = previousOffsetState - scrollView.contentOffset.y
        
        previousOffsetState = scrollView.contentOffset.y
        
        if scrollView.contentOffset.y < 150 {
            constraintHeightOfAdvertisingView.constant += offsetDiff
        }
    }
}
