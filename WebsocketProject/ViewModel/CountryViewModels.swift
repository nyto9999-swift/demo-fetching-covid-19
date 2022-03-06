import UIKit
import RealmSwift

struct CollectionItemViewModel {
    var name           : String
    var cases          : String
    var deaths         : String
    var favorite       : Int     = 1
    var cellBgColor    : UIColor = .systemGray5

    init(name: String, cases: String, deaths: String, favorite: Int){
        var name = name
        
        
        if let rex = name.range(of: "(") {
            
            name.removeSubrange(rex.lowerBound..<name.endIndex)
        }
        
        self.favorite = favorite
        self.name     = name
        self.cases    = "確診：\(cases)"
        self.deaths   = "死亡：\(deaths)"
    }
}





