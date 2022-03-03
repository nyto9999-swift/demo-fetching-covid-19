
import UIKit
import RealmSwift

class Country: Object, Codable {
    
    @objc dynamic var id: Int = 999
    @objc dynamic var favorite: Int = 1
    @objc dynamic var name: String = ""
    @objc dynamic var slug: String = ""
      
    enum CodingKeys: String, CodingKey {
      case name = "Country"
      case slug = "Slug"
       
    }
}




