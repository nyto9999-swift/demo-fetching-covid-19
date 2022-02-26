import UIKit
import Alamofire

final class AlamofireManager {

    static let shared = AlamofireManager()
    var countryMV = [CountryViewModel]()
    
    
    public func CountryValues(completion: @escaping (Result<[CountryViewModel], Error>) -> Void) {
        
        if RealmManager.shared.isOutdate() {
            
            print("api call....")
            AF.request("https://api.covid19api.com/countries")
               .validate()
               .responseDecodable(of: [Country].self) { [weak self] (response) in
                   guard let self = self else { return }

                   switch response.result {
                       case .success(let countries):
                           
                           for country in countries {
                               self.countryMV.append(CountryViewModel(name: country.name, slug: country.slug))
                           }
                           
                           RealmManager.shared.delete(objectType: Country.self)
                           RealmManager.shared.save(countries: countries)
                           
                           //fetch slug
                           
                           
                           completion(.success(self.countryMV))
                       case .failure(let error):
                           completion(.failure(error))
                   }
               }
        }
        
        else {
            completion(.success(RealmManager.shared.render()))
        }
        
        
    }
}


