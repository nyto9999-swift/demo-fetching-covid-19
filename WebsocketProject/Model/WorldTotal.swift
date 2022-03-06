
import UIKit
import RealmSwift

class WorldTotal: Object, Codable {
    
    @objc dynamic var TotalConfirmed: Int
    @objc dynamic var TotalDeaths: Int

    enum CodingKeys: String, CodingKey {
      case TotalConfirmed = "TotalConfirmed"
      case TotalDeaths = "TotalDeaths"
    }
}
