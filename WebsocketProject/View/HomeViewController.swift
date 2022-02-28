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
    
    let apicall = AlamofireManager()
    let realm = RealmManager.shared
    var countries = [Country]()
    var isDescending = false
    
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
        realmRender()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.countries = RealmManager.shared.render()
        self.CardCollection.reloadData()
    }
    
    func realmRender(){
        DispatchQueue.main.async {
            self.countries = self.realm.CountryValues()
            self.CardCollection.reloadData()
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
                image: UIImage(systemName: "gearshape.fill"),
                style: .done,
                target: self,
                action: #selector(tappedGear)
            ),
            UIBarButtonItem(
                image: UIImage(systemName: "arrow.up.arrow.down"),
                style: .done,
                target: self,
                action: #selector(tappedSort)
            ),
            
        ]
    }
    
    @objc func tappedSort(){
        countries = realm.sortByFavorite(bool: isDescending)
        CardCollection.reloadData()
        isDescending.toggle()
        print(isDescending)
    }
    @objc func tappedGear(){
        let destinationVC = SettingViewController()
        
        destinationVC.countries = RealmManager.shared.sortById()
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 
        return countries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionCell.identifier, for: indexPath) as! HomeCollectionCell
        
        
        cell.cardButton1.setTitle(countries[indexPath.item].name, for: .normal)
        if countries[indexPath.row].favorite == 0 {
            cell.backgroundColor = .systemGray3
        }
        else {
            cell.backgroundColor = .systemTeal
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        true
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pan = scrollView.panGestureRecognizer
        let velocity = pan.velocity(in: scrollView).y
        if velocity < -1000 {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else if velocity > 1000 {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
        }
    }
}

