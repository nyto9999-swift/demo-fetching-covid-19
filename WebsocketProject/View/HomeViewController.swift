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
    
    let realm = DatabaseService.shared
    var viewModels = [CountryViewModel]() 
    var filterViewModels = [CountryViewModel]()
    var isSearch: Bool = false
    var isAscending = false
    
    lazy var searchBar:UISearchBar = {
        let searchBar                      = UISearchBar()
        searchBar.searchBarStyle           = UISearchBar.Style.default
        searchBar.isUserInteractionEnabled = true
        searchBar.showsCancelButton        = false
        return searchBar
    }()
    
    lazy var CollectionView: UICollectionView = {
        
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
        self.hideKeyboardWhenTappedAround()
        fetchCovidData()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModels = realm.render()
        self.CollectionView.reloadData()
    }
    
    func fetchCovidData(){
        DispatchQueue.main.async {
            self.viewModels = self.realm.fetchCovid19Data()
            self.CollectionView.reloadData()
        }
    }
    
    func setupView(){
        view.addSubview(CollectionView)
        
        //collection
        CollectionView.delegate            = self
        CollectionView.dataSource          = self
        CollectionView.register(HomeCollectionCell.self, forCellWithReuseIdentifier: HomeCollectionCell.identifier)
        CollectionView.pin(to: view)
        
        //nav bar
        
        navigationItem.titleView           = searchBar
        searchBar.delegate                 = self
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
    
    //nav button function
    @objc func tappedSort(){
        print("tap")
        self.viewModels = realm.sortByFavorite(bool: isAscending)
        self.CollectionView.reloadData()
        self.isAscending.toggle()
    }
    
    @objc func tappedGear(){
        let destinationVC = SettingViewController()
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearch ? filterViewModels.count : viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionCell.identifier, for: indexPath) as! HomeCollectionCell
        
        let country = isSearch ? filterViewModels[indexPath.item] : viewModels[indexPath.item]
        
        cell.country = country
        
        return cell
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

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == "" || searchBar.text == nil {
            isSearch = false
            self.CollectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        searchBar.resignFirstResponder()

        filterViewModels = viewModels.filter({
            $0.name.contains(text)
        })

        isSearch = true
        self.CollectionView.reloadData()
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
