import UIKit
import MaterialComponents.MaterialCards
import MaterialComponents.MaterialCards_Theming
import MaterialComponents.MaterialContainerScheme
import MaterialComponents.MaterialTabs_TabBarView
import RealmSwift
import MarqueeLabel


class HomeViewController: UIViewController {
    
    let realm             = DatabaseService.shared
    var collectionItemsVM = [CollectionItemViewModel]()
    var filterViewModels  = [CollectionItemViewModel]()
    var marqueeVM         = MarqueeViewModel()
    var isSearch: Bool    = false
    var isAscending       = false
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor                           = .systemGray6
        return view
    }()
    
    lazy var scrollViewContainer: UIStackView = {
        let view                                       = UIStackView()
        view.axis                                      = .vertical
        view.spacing                                   = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isLayoutMarginsRelativeArrangement        = true
        view.backgroundColor                           = .systemGray6
        return view
    }()
    
    lazy var searchBar:UISearchBar = {
        let searchBar                      = UISearchBar()
        searchBar.searchBarStyle           = UISearchBar.Style.default
        searchBar.isUserInteractionEnabled = true
        searchBar.showsCancelButton        = false
        searchBar.backgroundColor          = .systemGray6
        return searchBar
    }()
    
    lazy var tabBar: MDCTabBarView = {
       let tabBar                                       = MDCTabBarView()
       tabBar.items                                     = self.tabBarItems
       tabBar.tabBarDelegate                            = self
       tabBar.translatesAutoresizingMaskIntoConstraints = false
       tabBar.barTintColor                              = .systemGray6
       tabBar.selectionIndicatorStrokeColor             = .systemIndigo
       tabBar.rippleColor                               = .systemGray4
       tabBar.setTitleColor(adaptiveColor(), for: UIControl.State.normal)
    
       return tabBar
     }()
    
    lazy var tabBarItems: [UITabBarItem] = {
      let itemTitles = ["All", "Favorite", "Setting"]
      return itemTitles
        .enumerated()
        .map { (index, title) in
          return UITabBarItem(title: title, image: nil, tag: index)
        }
    }()
    
    lazy var worldTotalMarqueeLabel: MarqueeLabel! = {
        let title             = MarqueeLabel(frame: accessibilityFrame, duration: 8.0, fadeLength: 10.0)
        title.type            = .continuous
        title.speed           = .duration(50.0)
        title.animationCurve  = .linear
        title.fadeLength      = 10.0
        title.leadingBuffer   = 50.0
        title.trailingBuffer  = 5.0
        title.backgroundColor = .systemGray6
        title.tintColor       = .systemGray
        return title
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection                               = .vertical
        layout.minimumLineSpacing                            = 8
        layout.minimumInteritemSpacing                       = 8
        let cardSize                                         = (view.bounds.size.width / 2) - 12;
        layout.itemSize                                      = CGSize(width: cardSize, height: cardSize)
        
        let collection                                       = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isScrollEnabled                           = true
        collection.alwaysBounceVertical                      = true
        collection.contentInset                              = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        collection.allowsMultipleSelection                   = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor                           = .systemGray6
        collection.setCollectionViewLayout(layout, animated: true)
        return collection
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        (collectionItemsVM, marqueeVM) = realm.fetchCovid19Data()
        setupView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionItemsVM = realm.render().countries
        self.collectionView.reloadData()
    }
    
    func setupView(){
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addArrangedSubview(tabBar)
        scrollViewContainer.addArrangedSubview(worldTotalMarqueeLabel)
        scrollViewContainer.addArrangedSubview(collectionView)
        
        //marquee label
        MarqueeLabel.controllerLabelsLabelize(self)
        worldTotalMarqueeLabel.labelize = false
        worldTotalMarqueeLabel.isHidden = true
        
        if marqueeVM.TotalConfirmed != nil,
           marqueeVM.TotalDeaths    != nil {
            worldTotalMarqueeLabel.text = "Total Confirmed: \(marqueeVM.TotalConfirmed!) Total Deaths: \(marqueeVM.TotalDeaths!)"
        }
        
        //collection
        collectionView.delegate            = self
        collectionView.dataSource          = self
        collectionView.register(HomeCollectionCell.self, forCellWithReuseIdentifier: HomeCollectionCell.identifier)
        
        //nav items
        let arrowUpDown = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down"),
            style: .done,
            target: self,
            action: #selector(tappedSort)
        )
        arrowUpDown.tintColor = .systemBlue
        navigationItem.titleView           = searchBar
        searchBar.delegate                 = self
        navigationItem.rightBarButtonItems = [arrowUpDown]
        
        //tab bar
        tabBar.setSelectedItem(tabBarItems[0], animated: true)
    }

    func setupConstraints(){
        scrollView.pin(to: view)
        scrollViewContainer.pin(to: scrollView)
        
        NSLayoutConstraint.activate([
            scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollViewContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    //nav button function
    @objc func tappedSort(){
        self.collectionItemsVM = realm.sortByAscDesc(bool: isAscending)
        self.collectionView.reloadData()
        self.isAscending.toggle()
    }
    
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearch ? filterViewModels.count : collectionItemsVM.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionCell.identifier, for: indexPath) as! HomeCollectionCell
        
        let country = isSearch ? filterViewModels[indexPath.item] : collectionItemsVM[indexPath.item]
        
        cell.country = country
        
        return cell
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pan = scrollView.panGestureRecognizer
        let velocity = pan.velocity(in: scrollView).y
        if velocity < -1000 {
            
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.2, delay: 0,
                options: [
                    .curveEaseIn,
                    .preferredFramesPerSecond60
                ], animations: {
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                    self.worldTotalMarqueeLabel.isHidden = false
                    self.tabBar.isHidden = true
                    
            })
            
        } else if velocity > 1000 {
            
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.2, delay: 0,
                options: [
                    .curveEaseIn,
                    .preferredFramesPerSecond60
                ], animations: {
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    self.worldTotalMarqueeLabel.isHidden = true
                    self.tabBar.isHidden = false
            })
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == "" || searchBar.text == nil {
            isSearch = false
            self.collectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        searchBar.resignFirstResponder()

        filterViewModels = collectionItemsVM.filter({
            $0.name.contains(text)
        })

        isSearch = true
        self.collectionView.reloadData()
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

extension HomeViewController: MDCTabBarViewDelegate {
 
    func tabBarView(_ tabBarView: MDCTabBarView, didSelect item: UITabBarItem) {
        switch item.title {
            case "All":
                self.collectionItemsVM = realm.sortByAscDesc(bool: true)
                self.collectionView.reloadData()
            case "Favorite":
                self.collectionItemsVM = realm.filterFavorite()
                self.collectionView.reloadData()
            case "Setting":
                let destinationVC = SettingViewController()
                self.navigationController?.pushViewController(destinationVC, animated: true)
            case .none:
                print("none")
            case .some(_):
                print("some")
        }
    }
}

