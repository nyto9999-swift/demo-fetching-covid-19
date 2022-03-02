import UIKit
import RealmSwift

struct CountryViewModel {
    var name: String
    var favorite: Int = 1
    var color: UIColor = .systemTeal

    
    init(name: String, favorite: Int){
        var name = name
        
        
        if let rex = name.range(of: "(") {
            
            name.removeSubrange(rex.lowerBound..<name.endIndex)
        }
        
        if favorite == 0 {
            self.favorite = 0
            self.color = .systemGray5
        }
        
        self.name = name
    }
}




