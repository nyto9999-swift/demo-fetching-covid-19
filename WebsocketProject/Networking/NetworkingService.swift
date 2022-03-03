import UIKit
import Alamofire

final class NetworkingService {
    static let shared = NetworkingService()
    
    func fetchWorldTotal(url: String, completion: @escaping (Result<WorldTotal, Error>) -> Void) {
        AF.request(url)
            .validate()
            .responseDecodable(of: WorldTotal.self) { (response) in
                
                switch response.result {
                    case .success(let worldTotal):
                        completion(.success(worldTotal))
        
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
    }
    
    func fetchCovid19Json(url: String, completion: @escaping (Result<[Country], Error>) -> Void) {
        AF.request(url)
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


