//
//  ChatViewController.swift
//  Parse Chat
//
//  Created by Akbar Mirza on 2/22/17.
//  Copyright © 2017 Akbar Mirza. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var messageField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    // Properties
    var messages: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // refresh the data
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSendMessage(_ sender: Any) {
        
        let msg = PFObject(className: "Message")
        if let msgText = messageField.text {
            msg["text"] = msgText
            msg["user"] = PFUser.current()
            
            msg.saveInBackground { (didSave: Bool, error: Error?) in
                if (didSave) {
                    // the object has been saved
                    print("Message Saved: \"\(msgText)\"")
                } else {
                    // there was a problem, check error.description
                }
            }
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func refresh() {
        // add code to be run every second
        let query = PFQuery(className: "Message").includeKey("user")
        
        // sort query by createdAt
        query.order(byDescending: "createdAt")
        
        // load objects
        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
            if error == nil {
                // the find succeeded
                print("Successfully retrieved \(messages!.count) messages.")
                
                // do something with the found objects
                if let messages = messages {
                    
                    self.messages = messages
                    
                    print("Messages updated!")
                    
                    self.tableView.reloadData()
                    
                    
                    print(messages)
                    
//                    for msg in messages {
//                        print(msg.objectId)
//                    }
                } else {
                    // log details of the failure
                    print("Error: \(error!)")
                }
            }
        }
        
    }

}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.messages.count 
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = self.messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
        
        if let text = message["text"] as? String {
            cell.textLabel?.text = text
        }
        
        if let user = message["user"] as? String {
            cell.userLabel.isHidden = false
            cell.userLabel.text = user
        } else {
            // cell.userLabel.isHidden = true
        }
        
        return cell
        
    }
    
}
