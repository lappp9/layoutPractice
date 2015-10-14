
import UIKit

class User {
    var name = ""
    var lastActive = "4:14 PM"
    var profileURL = NSURL()
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, url: NSURL) {
        self.name = name
        self.profileURL = url
    }
}