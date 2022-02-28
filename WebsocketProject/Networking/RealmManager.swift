import UIKit
import RealmSwift

final class RealmManager {

    static let shared = RealmManager()
    let realm = try! Realm()
    
    
    public func CountryValues() -> [Country] {
        
        if isFirstTime() {
            print("api call....")
            
            AlamofireManager.shared.fetchData(url: "https://api.covid19api.com/countries", completion: { result in
                switch result {
                        
                    case .success(_):
                        print("alamofire fetched data")
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

    
    func render() -> [Country] {
    
        let countryObjects = realm.objects(Country.self)
        
        var sortedCountries = [Country]()
        
        
        // first time run the app
        if countryObjects.isEmpty || countryObjects.count == 0 {
            sortedCountries = sortById()
            print("first time.. sort by name")
        }
        
        // not first time to run the app
        else{
            
            print("not first time... sort by id")
            sortedCountries = sortByFavorite(bool: true)
        }
        
        return sortedCountries
    }
    

    func sortById() -> [Country] {
        
        var sortedCountries = [Country]()
        
        let countries = realm.objects(Country.self).sorted(byKeyPath: "id", ascending: true)
        
        for country in countries {
            sortedCountries.append(country)
        }
        
        return sortedCountries
    }
    
    func sortByFavorite(bool: Bool) -> [Country] {
        let sortProperties = [SortDescriptor(keyPath: "favorite", ascending: bool), SortDescriptor(keyPath: "id", ascending: bool)]
        

        var sortedCountries = [Country]()
        
        let countries = realm.objects(Country.self).sorted(by: sortProperties)
        
        for country in countries {
            sortedCountries.append(country)
        }
        
        return sortedCountries
    }
    
    func storeSetting(iPath: [IndexPath], completion: @escaping (Result<String, Error>) -> Void) {
        
        do {
            try realm.write({
                
                for i in iPath {
                    print(i)
                    let result = realm.objects(Country.self).filter("id = %@", i.row)

                    guard let result = result.first else { return }
                    
                    if result.favorite == 0 {
                        result.favorite = 1
                    }
                    else {
                        result.favorite = 0
                    }
                    print(result.favorite)
                }
            })
            completion(.success("成功"))
        }
        catch {
            
            completion(.failure(error))
            print("setting error")
        }
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


extension RealmManager {
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
