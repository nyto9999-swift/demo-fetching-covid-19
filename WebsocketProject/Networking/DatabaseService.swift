import UIKit
import RealmSwift
import SwiftCSV


final class DatabaseService {
    
    static let shared = DatabaseService()
    let realm = try! Realm()
    var collectionItemVMs = [CollectionItemViewModel]()
    
    
    public func fetchTodayData() -> (countries: [CollectionItemViewModel], worldTotal: MarqueeViewModel) {
        
        if !todayData() {
            
            NetworkingService.shared.downloadCsv(url: "https://od.cdc.gov.tw/eic/covid19/covid19_global_cases_and_deaths.csv", completion:  { [weak self] result in
                switch result {
                    case .success(let url):
 
                        do {
                            try self?.loadCSVThenSaveInDB(url: url)
                        }
                        catch {
                            print("load csv error")
                        }
                        
                    case .failure(let error):
                        print(error)
                }
            })
            
            NetworkingService.shared.fetchWorldTotalJson(url: "https://api.covid19api.com/world/total") { [weak self] result in
                switch result {
                        
                    case .success(let wordTotal):
                        self?.saveInDB(object: wordTotal)
                    case .failure(let error):
                        print(error)
                }
            }
            
        }
        
        
        print("Realm Path : \(realm.configuration.fileURL?.absoluteURL)")
        return loadDB()
    }
    func loadCSVThenSaveInDB(url: URL) throws {
        
        deletes(withTypes: [Country.self])
        delete(objectType: Timestamp.self)

        //["country_ch", "country_en", "cases", "deaths"]
        let csv: CSV = try CSV(url: url)
        self.realm.beginWrite()

        let today = Timestamp()
        self.realm.add(today)
        
        try! csv.enumerateAsDict { dict in
            self.savesInDB(countryData: dict)
            
        }
        
        self.incrementCountryID()
        
        try! self.realm.commitWrite()
    }
    
    //MARK: Save
    func saveInDB(object: Object) {
        
        delete(objectType: WorldTotal.self)
        
        realm.beginWrite()
        
        realm.add(object)
        
        try! realm.commitWrite()
    }
    
    func savesInDB(countryData: [String:String]) {

        let country = Country()
        
        if let en     = countryData["country_en"],
           let ch     = countryData["country_ch"],
           let cases  = countryData["cases"],
           let deaths = countryData["deaths"]
        {
            country.country_en = en
            country.country_ch = ch
            country.cases      = cases
            country.deaths     = deaths
            country.favorite   = 1
        }
            realm.add(country)
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
        let countries = realm.objects(Country.self)
        
        var id = 0
    
        countries.forEach {
            let country = realm.objects(Country.self).filter("country_en = %@", $0.country_en)
            if let country = country.first {
                country.id = id
                id += 1
            }
        }
    }
    
    //MARK: Read
    func loadDB() -> (countries: [CollectionItemViewModel], worldTotal: MarqueeViewModel)  {
        
        var marqueeVM = MarqueeViewModel()
        collectionItemVMs = sort(isAscending: true)

        if let worldTotalObject = realm.objects(WorldTotal.self).first {
            marqueeVM.TotalConfirmed = worldTotalObject.TotalConfirmed
            marqueeVM.TotalDeaths = worldTotalObject.TotalDeaths
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
    
    func sort(isAscending: Bool?) -> [CollectionItemViewModel] {
        collectionItemVMs = []
        
        let countries = realm.objects(Country.self).sorted(byKeyPath: "id", ascending: isAscending ?? true)
        
        countries.forEach {
            collectionItemVMs.append(CollectionItemViewModel(name: $0.country_ch, cases: $0.cases, deaths: $0.deaths, favorite: $0.favorite))
        }
        
        return collectionItemVMs
    }
    
    func sortFavorite(isAscending: Bool?) -> [CollectionItemViewModel] {
        collectionItemVMs = []
        
        
        let sortProperties = [SortDescriptor(keyPath: "favorite", ascending: isAscending ?? true), SortDescriptor(keyPath: "id", ascending: isAscending ?? true)]
        
        let countries = realm.objects(Country.self).sorted(by: sortProperties).filter("favorite = 0")
        
        countries.forEach {collectionItemVMs.append(CollectionItemViewModel(name: $0.country_ch, cases: $0.cases, deaths: $0.deaths, favorite: $0.favorite))}
        
        return collectionItemVMs
    }
    
    //MARK: Others
    func todayData() -> Bool {
        let today = startDayAndEndDay()
        
        let timestamp = realm.objects(Timestamp.self).filter("today BETWEEN %@", [today.start, today.end])
        
        if timestamp.count == 0 ||
           timestamp.isEmpty
        {
            print("not today")
            return false
        }
        print("today")
        return true
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
