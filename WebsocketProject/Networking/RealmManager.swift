import UIKit
import RealmSwift

final class RealmManager {

    static let shared = RealmManager()
    
    
    let realm = try! Realm()
    
    func save(countries: [Country]) {
    
        realm.beginWrite()
        
        for country in countries {
            
            realm.add(country)
        }
        
        try! realm.commitWrite()
    }
    
    func render() -> [CountryViewModel] {
        
        print("User Realm User file location: \(realm.configuration.fileURL!.path)")
        var countryMV = [CountryViewModel]()
        let countries = realm.objects(Country.self)
        for country in countries {
            countryMV.append(CountryViewModel(name: country.name, slug: country.slug))
        }
        return countryMV
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
    
    func isOutdate() -> Bool{
        let countries = realm.objects(Country.self)
        if countries.count == 0 || countries.isEmpty {
            return true
        }
        else {
            return false
        }
    }
    

     
    
    
}


