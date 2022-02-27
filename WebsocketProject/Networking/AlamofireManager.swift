import UIKit
import Alamofire

final class AlamofireManager {
    
    static let shared = AlamofireManager()
    var countries = [Country]()
    
    
    
    func fetchData(url: String, completion: @escaping (Result<String, Error>) -> Void) {
        AF.request("https://api.covid19api.com/countries")
            .validate()
            .responseDecodable(of: [Country].self) { (response) in
                
                switch response.result {
                    case .success(let countries):
                            
                        RealmManager.shared.save(countries: countries)
                        
                        completion(.success("stored in realm successfully"))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
    }

}


