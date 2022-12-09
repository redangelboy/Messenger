
import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let ref = Database.database().reference().child("messages/")
    var messages1 : [[String:String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHidding()
        tableView.dataSource = self
        title = "Chateamos"
//        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        self.fetchfirebaseMessages()
    }
    
    private func setupKeyboardHidding(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillshow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func string2Dic(messageInfo : String) -> [String : String]{
        var message : [String : String] = [:]
        
        let info = messageInfo.split(omittingEmptySubsequences: false, whereSeparator: { $0 == "\n" })
        var newvar : [Int: [Substring]] =  [:]
        if info.count >= 5 {
            for i in 1..<5{
                newvar[i] = String(info[i]).split(omittingEmptySubsequences: false, whereSeparator: { $0 == "=" })
            }
                        
            guard let uid =   newvar[1] else  {return [:]}
            guard let body =  newvar[2] else {return [:]}
            guard let time =  newvar[3] else {return [:]}
            guard let user =  newvar[4] else {return [:]}
            
            message[ String(uid[0]).trimmingCharacters(in: .whitespaces)] = String(uid[1])
            message[ String(body[0]).trimmingCharacters(in: .whitespaces)] = String(body[1])
            message[ String(time[0]).trimmingCharacters(in: .whitespaces)] = String(time[1])
            message[ String(user[0]).trimmingCharacters(in: .whitespaces)] = String(user[1])
            
            print(type(of: String(time[1])))
        }
        return message
    }
    
    func fetchfirebaseMessages(){
        ref.observe(.childAdded) { snap in
            
            guard let temp = snap.value as?  [String:String] else { print("failed to convert to message ")
                return
            }
            self.messages1.append(temp)
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: self.messages1.count - 1, section: 0), at: .bottom, animated: true)
        }
        
        print("este es mensajes despues de ser append \(self.messages1.count)")
    }
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        
        guard let body = self.messageTextfield.text else {return}
        
        
        ref.child(Date().description).setValue(["UID" : " C ", "body": body, "timestamp": "\(Date())", "username" : "Cesar"])
            self.messageTextfield.text = ""
        }
        
    }


extension ChatViewController: UITableViewDataSource {
    
    @objc
    func keyboardWillshow(sender: NSNotification){
        view.frame.origin.y = view.frame.origin.y - 200
    }
    
    @objc
    func keyboardWillHide(sender: NSNotification){
        view.frame.origin.y = 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        let forPrint = self.messages1[indexPath.row]

        print("************")
        print(forPrint["username"] as Any)
        print(forPrint["body"] as Any)
        
        guard let name = forPrint["username"] else {fatalError("wrong user")}
        print(name)
        
        //This is a message from the current user.
        if name == "Cesar" {
            cell.contactLabel.isHidden = true
            cell.myLabel.isHidden = false
            cell.label.text = forPrint["body"]
            cell.label.textAlignment = .right
            cell.myLabel.text = forPrint["username"]
            cell.messageBubble.backgroundColor = UIColor(named: "cBlue")
            cell.label.textColor = UIColor(named: "cLightBlue")
        }
        
        //This is a message from another sender.
        else {
            cell.myLabel.isHidden = true
            cell.contactLabel.isHidden = false
            cell.label.text = forPrint["body"]
            cell.label.textAlignment = .left
            cell.contactLabel.text = forPrint["username"]
            cell.messageBubble?.backgroundColor = UIColor(named: "cPurple")
            cell.label.textColor = UIColor(named: "cLightPurple")
            
        }
        
        return cell
    }
}
