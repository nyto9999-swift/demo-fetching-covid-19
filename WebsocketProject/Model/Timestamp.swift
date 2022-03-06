
import UIKit
import RealmSwift

class Timestamp: Object, Codable {
    @objc dynamic var today: Date = Date()
}
