
import UIKit
import RealmSwift







class Country: Object, Codable {
    
    @Persisted var name: String
    @Persisted var slug: String
    
    enum CodingKeys: String, CodingKey {
      case name = "Country"
      case slug = "Slug"
    }
}

