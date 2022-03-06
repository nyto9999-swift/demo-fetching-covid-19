
import UIKit
import RealmSwift

class Country: Object {
    
    @objc dynamic var id: Int = 999
    @objc dynamic var favorite: Int = 1
    @objc dynamic var country_en: String = ""
    @objc dynamic var country_ch: String = ""
    @objc dynamic var cases: String = ""
    @objc dynamic var deaths: String = ""
      
}




