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
        let sortedCountryObjects: Results<Country>
        
        // first time run the app
        if countryObjects.isEmpty || countryObjects.count == 0 {
            sortedCountryObjects = countryObjects.sorted(byKeyPath: "name", ascending: true)
            print("first time.. sort by name")
        }
        
        else{
            sortedCountryObjects = realm.objects(Country.self).sorted(byKeyPath: "id", ascending: true)
            print("not first time... sort by id")
        }
        
        
        var countries = [Country]()
        
        for object in sortedCountryObjects {
            countries.append(object)
        }
        
        return countries
    }
    

    func sort(bool: Bool) -> [Country] {
        
        var sortedCountries = [Country]()
        
        let countries = realm.objects(Country.self).sorted(byKeyPath: "id", ascending: bool)
        
        for country in countries {
            sortedCountries.append(country)
        }
        
        return sortedCountries
    }
    
    func switchIndex(source: Int, destination: Int, descending: Bool){
        
        
        var start = source
        var end = destination
        
        if descending {
            
            let total = realm.objects(Country.self).count - 1
            print("total\(total)")
            
            start = total - start
            end = total - end
            
            
            print(start)
            print(end)
        }
        
        realm.beginWrite()
        
        let startItem = realm.objects(Country.self).filter("id = %@", start)
        let endItem = realm.objects(Country.self).filter("id = %@", end)

        if let startItem = startItem.first, let endItem = endItem.first {
            startItem.id = end
            endItem.id = start
        }
        try! realm.commitWrite()
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
