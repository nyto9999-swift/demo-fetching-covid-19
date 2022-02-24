//
//  HomeViewController.swift
//  WebsocketProject
//
//  Created by 宇宣 Chen on 2022/2/24.
//

import UIKit
import MaterialComponents.MaterialCards
import MaterialComponents.MaterialCards_Theming

class HomeViewController: UIViewController {
        
    lazy var searchBar:UISearchBar = {
        let searchBar                      = UISearchBar()
        searchBar.searchBarStyle           = UISearchBar.Style.default
        searchBar.isUserInteractionEnabled = true
        searchBar.showsCancelButton        = false
        return searchBar
    }()
    
    lazy var collection: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.frame.width/2)-7.5, height: (view.frame.width/2)-7.5)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout) //card custom
        collection.isScrollEnabled = true
        collection.setCollectionViewLayout(layout, animated: true)
        collection.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collection)
        setupView()
    }
    
    func setupView(){
        
        //collection
        collection.delegate = self
        collection.dataSource = self
        collection.register(MDCCardCollectionCell.self, forCellWithReuseIdentifier: "cell")
        collection.pin(to: view)
        
        //nav bar
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "heart.fill"),
                style: .done,
                target: self,
                action: #selector(TappedHeart)
            ),
            UIBarButtonItem(
                image: UIImage(systemName: "arrow.up.arrow.down"),
                style: .done,
                target: self,
                action: #selector(TappedSort)
            ),
        ]
    }

    @objc func TappedHeart(){
        print("heart")
    }
    @objc func TappedSort(){
        print("sort")
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MDCCardCollectionCell
        let containerScheme = MDCContainerScheme()
        
        cell.cornerRadius = 8
        cell.layer.borderWidth = 9
        cell.applyTheme(withScheme: containerScheme)
        cell.applyOutlinedTheme(withScheme: containerScheme)
        return cell
    }
 
}

