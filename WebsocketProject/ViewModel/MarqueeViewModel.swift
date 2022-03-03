import UIKit
import RealmSwift

struct MarqueeViewModel {
    var TotalConfirmed: Int?
    var TotalDeaths: Int?
    
    init(confirmed: Int?, deaths: Int?) {
        self.TotalConfirmed = confirmed
        self.TotalDeaths    = deaths
    }
    init() { //Convenience Initializer
        self.TotalConfirmed = nil
        self.TotalDeaths    = nil
    }
   
}




