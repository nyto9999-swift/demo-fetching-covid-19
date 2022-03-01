import UIKit
import Alamofire

final class NetworkingService {
    
    static let shared = NetworkingService()
    var countries = [Country]()
    
    func fetchCovid19Json(url: String, completion: @escaping (Result<[Country], Error>) -> Void) {
        AF.request("https://api.covid19api.com/countries")
            .validate()
            .responseDecodable(of: [Country].self) { (response) in
                
                switch response.result {
                    case .success(let countries):
                        completion(.success(countries))
        
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
    }

}


