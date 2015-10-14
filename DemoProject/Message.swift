
import UIKit

class Message {
    var participants = [User]()
    var content = ""
    var creator = User(name: "")
    var likeCount = "3.4k"
    
    var imageUrl: NSURL?
    
    init(_ participants: [User], content: String, creator: User) {
        self.participants = participants
        self.content = content
        self.creator = creator 
    }
    
    init(_ participants: [User], content: String, creator: User, imageURL: NSURL) {
        self.participants = participants
        self.content = content
        self.creator = creator
        self.imageUrl = imageURL
    }
    
    init() {
        self.content = ""
        self.creator = User(name: "Michael Jordon")
    }
    
    static func randomMessage() -> Message {
        let message = Message()
        
        if arc4random_uniform(5) == 3 {
            message.imageUrl = NSURL(string: "http://1.bp.blogspot.com/-WjR1NMDszqI/UB7LSWnvtWI/AAAAAAAANU8/WDzo3NGrvhg/s1600/Gardnerstealing.png")
        }
        
        message.content = "Some thing that this guy said goes here. This will be super long so that I can see how this flexible growth and what not works."
 
        let numberOfURLs = Int(arc4random_uniform(4))
        
        let possibleURLs = [NSURL(string: "http://i.cdn.turner.com/sivault/multimedia/photo_gallery/0706/gallery.mlb.sammy.sosa/images/1998.peace.sign.jpg")!,
            NSURL(string: "http://gazettereview.com/wp-content/uploads/2015/06/David-Ortiz-700x560.jpg")!,
            NSURL(string: "http://static.foxsports.com/content/fscom/img/2013/09/03/090313_MLB_Yankees_Alex_Rodriguez_PI_CH_20130903234439508_660_320.JPG")!,
            NSURL(string: "http://a57.foxnews.com/global.fncstatic.com/static/managed/img/U.S./0/0/OJ%20Simpson12.jpg")!]
        
        let possibleNames = ["Alex Rodriguez", "David Ortiz", "Sammy Sosa", "Billy Butler"]
        
        let possibleParticipants = [User(name: possibleNames[0], url: possibleURLs[0]),
        User(name: possibleNames[1], url: possibleURLs[1]),
        User(name: possibleNames[2], url: possibleURLs[2]),
        User(name: possibleNames[3], url: possibleURLs[3])]
        
        message.creator = User(name: possibleNames[numberOfURLs], url: possibleURLs[numberOfURLs])
        
        if numberOfURLs == 0 {
            message.participants = Array(possibleParticipants.prefix(1))
        } else if numberOfURLs == 1 {
            message.participants = Array(possibleParticipants.prefix(2))
        } else if numberOfURLs == 2 {
            message.participants = Array(possibleParticipants.prefix(3))
        } else if numberOfURLs == 3 {
            message.participants = Array(possibleParticipants.prefix(4))
        }
        
        return message
    }
}
