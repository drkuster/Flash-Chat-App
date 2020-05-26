//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

extension StringProtocol
{
    var asciiValues: [UInt8] { compactMap(\.asciiValue) }
}

class ChatViewController: UIViewController
{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var checkMark: UIButton!
    @IBOutlet weak var recipentTextField: UITextField!
    
    var messages : [Message] =
    [
        
    ]
    
    var uniqueConvoID : String?
    
    var recipent : String?
    
    var shouldSendMessages = false
    
    let db = Firestore.firestore()
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        tableView.dataSource = self
        recipentTextField.delegate = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        checkRecipent()
    }
    
    @IBAction func logOutPressed(_ sender: Any)
    {
        do
        {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        }
            
        catch let signOutError as NSError
        {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func checkPressed(_ sender: UIButton)
    {
        if (sender.tag == 1)
        {
            sender.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            sender.tag = 0
        }
        
        else
        {
            sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            sender.tag = 1
        }
        
        checkRecipent()
    }
    
    func checkRecipent()
    {
        if recipentTextField.text != ""
        {
            if checkMark.tag == 0 // checked
            {
                recipentTextField.endEditing(true)
                loadMessages()
                shouldSendMessages = true
            }
            
            else // unchecked
            {
                messages.removeAll()
                tableView.reloadData()
                shouldSendMessages = false
            }
        }
    }
    
    func loadMessages()
    {
        db.collection(uniqueConvoID!).order(by: K.FStore.dateField).addSnapshotListener
        { (querySnapshot, error) in
            self.messages.removeAll()
            if let documents = querySnapshot?.documents
            {
                for doc in documents
                {
                    let data = doc.data()
                    let bodyText = data[K.FStore.bodyField] as! String
                    let date = data[K.FStore.dateField] as! TimeInterval
                    let sender = data[K.FStore.senderField] as! String
                    let message = Message(sender: sender, body: bodyText, timestamp: date)
                    self.messages.append(message)
                }
                
                if (self.messages.count > 0)
                {
                    DispatchQueue.main.async
                    {
                        self.tableView.reloadData()
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        checkMark.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        checkMark.tag = 0
        checkRecipent()
        return recipentTextField.endEditing(true)
    }
    
    func calculateConvoID()
    {
        let sender = Auth.auth().currentUser?.email ?? "blank email"
        var sum : Int = 0
        let senderVals = sender.asciiValues
        let recipentVals = recipent!.asciiValues
        
        for val in senderVals
        {
            sum += Int(val)
        }
        
        for val in recipentVals
        {
            sum += Int(val)
        }
        
        uniqueConvoID = String(sum)
    }
    
    @IBAction func sendPressed(_ sender: UIButton)
    {
        if (shouldSendMessages)
        {
            if let text = messageTextfield.text
            {
                db.collection(uniqueConvoID!).addDocument(data:
                [
                    K.FStore.senderField : Auth.auth().currentUser!.email!,
                    K.FStore.bodyField : text,
                    K.FStore.dateField : Date().timeIntervalSince1970
                ])
                { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    }
                    else
                    {
                        DispatchQueue.main.async
                        {
                            self.messageTextfield.text = ""
                        }
                    }
                }
            }
        }
    }
}

extension ChatViewController : UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        recipent = recipentTextField.text
        calculateConvoID()
        loadMessages()
    }
}

extension ChatViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        
        cell.label.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email
        {
            cell.youImageView.isHidden = true
            cell.meImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        else
        {
            cell.youImageView.isHidden = false
            cell.meImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.blue)
            cell.label.textColor = UIColor(named: K.BrandColors.lighBlue)
        }
        
        return cell
    }
    
    
}
