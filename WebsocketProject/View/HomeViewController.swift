//
//  HomeViewController.swift
//  WebsocketProject
//
//  Created by 宇宣 Chen on 2022/2/24.
//

import UIKit
import MaterialComponents.MaterialCards
import MaterialComponents.MaterialCards_Theming
import MaterialComponents.MaterialContainerScheme
import RealmSwift

class HomeViewController: UIViewController {
    
//    enum ToggleMode: Int {
//        case edit
//        case reorder
//    }
//
//    var toggle = ToggleMode.reorder
//    var dataSource: [StatesViewModel] = []
    
    let apicall = AlamofireManager()
    var countries = [CountryViewModel]()
    
    lazy var searchBar:UISearchBar = {
        let searchBar                      = UISearchBar()
        searchBar.searchBarStyle           = UISearchBar.Style.default
        searchBar.isUserInteractionEnabled = true
        searchBar.showsCancelButton        = false
        return searchBar
    }()
    
    lazy var CardCollection: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection          = .vertical
        layout.minimumLineSpacing       = 8
        layout.minimumInteritemSpacing  = 8
        let cardSize                    = (view.bounds.size.width / 2) - 12;
        layout.itemSize                 = CGSize(width: cardSize, height: cardSize)
        
        let collection                  = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isScrollEnabled      = true
        collection.alwaysBounceVertical = true
        collection.contentInset         = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        collection.setCollectionViewLayout(layout, animated: true)
        collection.allowsMultipleSelection = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCountries()
        setupView()
    }
    
    func fetchCountries(){
        
        AlamofireManager.shared.CountryValues { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let result):
                    DispatchQueue.main.async {
                        self.countries = result
                        self.CardCollection.reloadData()
                    }
                case .failure(_):
                    print("error")
            }
        }
    }
    
    func setupView(){
        view.addSubview(CardCollection)
        
        //collection
        CardCollection.delegate            = self
        CardCollection.dataSource          = self
        CardCollection.register(HomeCollectionCell.self, forCellWithReuseIdentifier: HomeCollectionCell.identifier)
        CardCollection.pin(to: view)
        
        //nav bar
        navigationItem.titleView           = searchBar
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "heart.fill"),
                style: .plain,
                target: self,
                action: #selector(toggleModes)
            ),
            UIBarButtonItem(
                image: UIImage(systemName: "arrow.up.arrow.down"),
                style: .done,
                target: self,
                action: #selector(TappedSort)
            ),
        ]
        
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(reorderCards(gesture:)))
        longPressGesture.cancelsTouchesInView = false
        CardCollection.addGestureRecognizer(longPressGesture)
        
    }
    
    @objc func toggleModes(){
//        switch toggle {
//            case .edit:
//                toggle = .reorder
//            case .reorder:
//                toggle = .edit
//        }
//        self.update()
//        self.CardCollection.reloadData()
    }
    @objc func TappedSort(){
        print("sort")
    }
    
//    func update() {
//        switch toggle {
//            case .edit:
//                navigationItem.rightBarButtonItems?[0].image = UIImage(systemName: "circle")
//            case .reorder:
//                navigationItem.rightBarButtonItems?[0].image = UIImage(systemName: "heart.fill")
//        }
//    }
//
    
    @objc func reorderCards(gesture: UILongPressGestureRecognizer) {
        
        switch gesture.state {
            case .began:
                guard
                    let selectedIndexPath = CardCollection.indexPathForItem(
                        at: gesture.location(in: CardCollection))
                else { break }
                CardCollection.beginInteractiveMovementForItem(at: selectedIndexPath)
            case .changed:
                guard let gestureView = gesture.view else { break }
                CardCollection.updateInteractiveMovementTargetPosition(gesture.location(in: gestureView))
            case .ended:
                CardCollection.endInteractiveMovement()
            default:
                CardCollection.cancelInteractiveMovement()
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return stateVMs.count
        return countries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionCell.identifier, for: indexPath) as! HomeCollectionCell
//
//        let stateVM = stateVMs[indexPath.item]
//        cell.stateVM = stateVM
//        if stateVM.selected {
//            CardCollection.selectItem(at: indexPath, animated: true, scrollPosition: [])
//            cell.isSelected = true
//            cell.stateVM = stateVM
//        }
        
//        cell.isAccessibilityElement = true
//        cell.accessibilityLabel = "102323"
        cell.cardButton1.setTitle(countries[indexPath.item].name, for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard toggle == .edit else { return }
//        stateVMs[indexPath.item].selected.toggle()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        guard toggle == .edit else { return }
//        stateVMs[indexPath.item].selected = false
    }
    
//    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
////        return toggle == .reorder
//    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
//        let sourceItem = stateVMs[sourceIndexPath.item]
//
//        // reorder all cells in between source and destination, moving each by 1 position
//        if sourceIndexPath.item < destinationIndexPath.item {
//          for ind in sourceIndexPath.item..<destinationIndexPath.item {
//            stateVMs[ind] = stateVMs[ind + 1]
//          }
//        } else {
//          for ind in (destinationIndexPath.item + 1...sourceIndexPath.item).reversed() {
//            stateVMs[ind] = stateVMs[ind - 1]
//          }
//        }
//        stateVMs[destinationIndexPath.item] = sourceItem
    }
}

