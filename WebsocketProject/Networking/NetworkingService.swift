import UIKit
import Alamofire

final class NetworkingService {
    static let shared = NetworkingService()
    
    func fetchWorldTotalJson(url: String, completion: @escaping (Result<WorldTotal, Error>) -> Void) {
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
    
    func downloadCsv(url: String, completion: @escaping (Result<URL, Error>) -> Void){
        
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)


        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
        let destinationPath = documentsPath.appendingPathComponent("covid19_global_cases_and_deaths.csv")
        try? FileManager.default.removeItem(atPath: destinationPath)
        
        
        AF.download(url, to: destination)
            .validate()
            .responseURL { response in
            switch response.result {
                case .success(let url):
                    completion(.success(url))
                case .failure(let error):
                    
                    completion(.failure(error))
                 
                    
            }
        }
    }

}


