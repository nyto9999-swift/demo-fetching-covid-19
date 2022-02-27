
import UIKit
import RealmSwift

class Country: Object, Codable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var slug: String = ""
    
    enum CodingKeys: String, CodingKey {
      case name = "Country"
      case slug = "Slug"
    }
}

