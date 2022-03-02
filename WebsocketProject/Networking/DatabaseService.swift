import UIKit
import RealmSwift

final class DatabaseService {

    static let shared = DatabaseService()
    let realm = try! Realm()
    var vms = [CountryViewModel]()
    
    public func fetchCovid19Data() -> [CountryViewModel] {
        
        if isFirstTime() {
            print("api call....")
            
            NetworkingService.shared.fetchCovid19Json(url: "https://api.covid19api.com/countries", completion: { [weak self] result in

                switch result {
                        
                    case .success(let countries):
                        self?.save(countries: countries)
                    case .failure(_):
                        print("alamofire fail")
                }
            })
        }
        else{
            
            // if latest
            
            // else
        }
        
        print("Realm Path : \(realm.configuration.fileURL?.absoluteURL)")
        return render()
    }
    
    func save(countries: [Country]) {
        
        realm.beginWrite()
        
        for country in countries {
            
            realm.add(country)
        }
        
        incrementID()
        
        try! realm.commitWrite()
    }

    
    func render() -> [CountryViewModel] {
        
        let countryObjects = realm.objects(Country.self)
        
        
        // first time run the app
        if countryObjects.isEmpty || countryObjects.count == 0 {
            vms = sortById()
            print("first time.. sort by name")
        }
        
        // not first time to run the app
        else{
            vms = sortByAscDesc(bool: true)
            print("not first time... sort by id")
        }
        
        return vms
    }
    

    func sortById() -> [CountryViewModel] {
        vms = []
        
        let countries = realm.objects(Country.self).sorted(byKeyPath: "id", ascending: true)
        
        
        for country in countries {
            vms.append(CountryViewModel(name: country.name, favorite: country.favorite))
        }
        
        return vms
    }
    
    func sortByAscDesc(bool: Bool) -> [CountryViewModel] {
        vms = []
        
        let sortProperties = [SortDescriptor(keyPath: "favorite", ascending: bool), SortDescriptor(keyPath: "id", ascending: bool)]
        
        
        let countries = realm.objects(Country.self).sorted(by: sortProperties)
        

        for country in countries {
            vms.append(CountryViewModel(name: country.name, favorite: country.favorite))
        }
        
        return vms
    }
    
    func filterFavorite() -> [CountryViewModel] {
        vms = []
        let sortProperties = [SortDescriptor(keyPath: "favorite", ascending: true), SortDescriptor(keyPath: "id", ascending: true)]
        
        
        let countries = realm.objects(Country.self).sorted(by: sortProperties).filter("favorite = 0")
        

        for country in countries {
            vms.append(CountryViewModel(name: country.name, favorite: country.favorite))
        }
        
        return vms
    }
    
    
    
    func storeSetting(iPath: [IndexPath]) throws {
        try! realm.write({
            
            for i in iPath {
                print(i)
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
    
    func isFirstTime() -> Bool{
        let countryObjects = realm.objects(Country.self)
        if countryObjects.count == 0 || countryObjects.isEmpty {
            return true
        }
        else {
            return false
        }
    }
    
    func incrementID(){
        let countries = realm.objects(Country.self).sorted(byKeyPath: "name", ascending: true)
        var id = 0
        for country in countries {
            let result = realm.objects(Country.self).filter("name = %@", country.name)

            if let result = result.first {
                result.id = id
                id += 1
            }
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
}

extension Date {
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}
