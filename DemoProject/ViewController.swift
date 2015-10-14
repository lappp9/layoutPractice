
import UIKit

class ViewController: UIViewController {
    let tableView = ASTableView()
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 1...20 { messages.append(Message.randomMessage()) }
        
        view.backgroundColor = UIColor.whiteColor()
        tableView.frame = view.bounds
        tableView.asyncDataSource = self
        tableView.asyncDelegate = self
        
        view.addSubview(tableView)
    }

}

extension ViewController: ASTableViewDelegate {
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
    }
}

extension ViewController: ASTableViewDataSource {
    func tableView(tableView: ASTableView!, nodeForRowAtIndexPath indexPath: NSIndexPath!) -> ASCellNode! {
        let cell = PostCellNode(message: messages[indexPath.row])
        cell.needsDivider = (indexPath.row != (messages.count - 1))
        return cell
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
}