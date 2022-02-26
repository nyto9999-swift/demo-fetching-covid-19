import UIKit
import RealmSwift

struct CountryViewModel {
    
    var name:String
    var slug:String
    
    init(name: String, slug: String){
        
        self.name = name
        self.slug = slug
        
        if let dotRange = name.range(of: ",") {
            
            self.name.removeSubrange(dotRange.lowerBound..<name.endIndex)
        }
        
        if let dotRange = name.range(of: "(") {
            
            self.name.removeSubrange(dotRange.lowerBound..<name.endIndex)
        }
    }
}
