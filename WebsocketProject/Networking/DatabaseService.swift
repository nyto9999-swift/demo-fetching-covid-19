import UIKit
import RealmSwift

final class DatabaseService {
    
    static let shared = DatabaseService()
    let realm = try! Realm()
    var collectionItemVMs = [CollectionItemViewModel]()
    var marqueeVM = MarqueeViewModel()
    
    public func fetchCovid19Data() -> (countries: [CollectionItemViewModel], worldTotal: MarqueeViewModel) {
        
        
//        deletes(withTypes: [Country.self])
        // if not today data, api call.....
        
        if !todayData() {
            
            delete(objectType: WorldTotal.self)
            deletes(withTypes: [Country.self])

            print("fetching. world total")
            NetworkingService.shared.fetchWorldTotal(url: "https://api.covid19api.com/world/total", completion: { [weak self] result in
                
                switch result {
                        
                    case .success(let worldTotal):
                        self?.save(object: worldTotal)
                    case .failure(_):
                        print("alamofire fail worldTotal")
                }
            })
            
            NetworkingService.shared.fetchCovid19Json(url: "https://api.covid19api.com/countries", completion: { [weak self] result in
                
                switch result {
                        
                    case .success(let countries):
                        self?.saves(objects: countries)
                    case .failure(_):
                        print("alamofire fail")
                }
            })
        }
    
        print("Realm Path : \(realm.configuration.fileURL?.absoluteURL)")
        return render()
    }
    
    
    //MARK: Save
    func save(object: Object) {
        
        deletes(withTypes: [WorldTotal.self])
        
        realm.beginWrite()
        
        realm.add(object)
        
        try! realm.commitWrite()
    }
    
    func saves(objects: [Object]) {
        
        realm.beginWrite()
        
        objects.forEach {realm.add($0)}
        
        incrementCountryID()
       
        try! realm.commitWrite()
    }
    
    func storeSetting(iPath: [IndexPath]) throws {
        try! realm.write({
            
            for i in iPath {
                let result = realm.objects(Country.self).filter("id = %@", i.row)
                
                guard let result = result.first else {
                    throw RealmError.write
                }
                
                if result.favorite == 0 {
                    result.favorite = 1
                }
                else {
                    result.favorite = 0
                }
            }
        })
    }
    
    func incrementCountryID(){
        let countries = realm.objects(Country.self).sorted(byKeyPath: "name", ascending: true)
        
        var id = 0
    
        countries.forEach {
            let country = realm.objects(Country.self).filter("name = %@", $0.name)
            if let country = country.first {
                country.id = id
                id += 1
            }
        }
    }
    
    //MARK: Read
    func render() -> (countries: [CollectionItemViewModel], worldTotal: MarqueeViewModel)  {
        
        let countryObjects = realm.objects(Country.self)
        let worldTotalObject = realm.objects(WorldTotal.self)
        
        // first time run the app
        if countryObjects.isEmpty || countryObjects.count == 0 {
            collectionItemVMs = sortById()
            print("first time.. sort by name")
        }
        
        // not first time to run the app
        else{
            collectionItemVMs = sortByAscDesc(bool: true)
            print("not first time... sort by id")
        }
        
        
        if !worldTotalObject.isEmpty || worldTotalObject.count != 0 {
            
            marqueeVM.TotalConfirmed = worldTotalObject.first!.TotalConfirmed
            marqueeVM.TotalDeaths = worldTotalObject.first!.TotalDeaths
        }
        return (collectionItemVMs, marqueeVM)
    }
    
    //MARK: Delete
    func delete(objectType: Object.Type) {
        try! realm.write {
            let objects = realm.objects(objectType)
            realm.delete(objects)
        }
    }
    
    func deletes(withTypes types: [Object.Type]) {
        try! realm.write {
            types.forEach { objectType in
                let objects = realm.objects(objectType)
                realm.delete(objects)
            }
        }
    }
 
    //MARK: Sort
    
    func sortById() -> [CollectionItemViewModel] {
        collectionItemVMs = []
        
        let countries = realm.objects(Country.self).sorted(byKeyPath: "id", ascending: true)
        
        countries.forEach {collectionItemVMs.append(CollectionItemViewModel(name: $0.name, favorite: $0.favorite))}
        
        return collectionItemVMs
    }
    
    func sortByAscDesc(bool: Bool) -> [CollectionItemViewModel] {
        collectionItemVMs = []
        
        let sortProperties = [SortDescriptor(keyPath: "favorite", ascending: bool), SortDescriptor(keyPath: "id", ascending: bool)]
        
        let countries = realm.objects(Country.self).sorted(by: sortProperties)
        
        
        countries.forEach {collectionItemVMs.append(CollectionItemViewModel(name: $0.name, favorite: $0.favorite))}
        
        return collectionItemVMs
    }
    
    func filterFavorite() -> [CollectionItemViewModel] {
        collectionItemVMs = []
        let sortProperties = [SortDescriptor(keyPath: "favorite", ascending: true), SortDescriptor(keyPath: "id", ascending: true)]
        
        
        let countries = realm.objects(Country.self).sorted(by: sortProperties).filter("favorite = 0")
        
        countries.forEach {collectionItemVMs.append(CollectionItemViewModel(name: $0.name, favorite: $0.favorite))}
        
        return collectionItemVMs
    }
    
    //MARK: Others
    func todayData() -> Bool {
        let countryObjects = realm.objects(Country.self)
        let todayStart = Calendar.current.startOfDay(for: Date())
        let todayEnd: Date = {
            let components = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: components, to: todayStart)!
        }()
        let today = realm.objects(WorldTotal.self).filter("timestamp BETWEEN %@", [todayStart, todayEnd])
        if today.count == 0 || today.isEmpty ||
            countryObjects.count == 0 || countryObjects.isEmpty{
            return false
        }else {
            return true
        }
    }
}


extension DatabaseService {
    func latest() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let yesterdayDateFormatter = dateFormatter.string(from: Date().dayBefore)
        let yesterday = "\(yesterdayDateFormatter)Z"
        return yesterday
    }
    
    func reomveTimeFrom(date: Date) -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let date = Calendar.current.date(from: components)
        
        return date!
    }
}

extension Date {
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}
