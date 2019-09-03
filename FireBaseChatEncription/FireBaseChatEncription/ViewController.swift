//
//  ViewController.swift
//  FireBaseChatEncription
//
//  Created by Matrix Marketers on 03/09/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import Firebase


let MainChatArray : NSMutableArray = []

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    //MARK: - outlet
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var mTableViewChat: UITableView!
    let key = "1234567898745632" // length == 32
    let iv =  "9876543212589632" // length == 16
    
    //MARK: - Basic Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTableViewChat.register(UINib.init(nibName: "Inbox", bundle: nil), forCellReuseIdentifier: "Inbox")
        mTableViewChat.delegate = self
        mTableViewChat.dataSource = self
        MainChatArray.removeAllObjects()
        mTableViewChat.reloadData()
        self.FireBaseGotData()
              // Do any additional setup after loading the view.
    }
    
    
    //MARK: - ButtonAction
    @IBAction func btnSend(_ sender: Any) {
        
        self.FireBaseSendData()
    }

    
    
    //MARK: - uiTableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainChatArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.mTableViewChat.dequeueReusableCell(withIdentifier: "Inbox", for: indexPath) as! Inbox
        cell.selectionStyle = .none
        let Data = MainChatArray[indexPath.row] as! NSDictionary
        cell.lblInbox.text = Data["Message"] as? String
        
        return cell
        
    }
    
    //MARK: - Firebase Method
    func FireBaseSendData(){

        let Data = ["Message":self.txtMessage.text!]
        let COnvertObjectIntoString = FrameWorkCode.JsonConvertIntoString(Json: Data)
        let Encript = try! FrameWorkCode.AESDecrypt(KEY: key, IV:iv, StringForDescription: COnvertObjectIntoString)
        let TempDict : NSDictionary = [iv:Encript]
        var ref2: DatabaseReference!
        ref2 = Database.database().reference()
        ref2?.child("Chat").childByAutoId().updateChildValues(TempDict as! [AnyHashable : Any], withCompletionBlock: { (error, response) in
            if (error != nil){
                print("error")
            }else{
               self.txtMessage.text = ""
            }
        })
    }
    
    
    func FireBaseGotData(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("Chat").observe(.childAdded, with: { (snapshot) -> Void in
            let messageData  =  snapshot
            let AllData = messageData.value as! NSDictionary
            let Message = AllData[self.iv] as! String
            let Decript = try! FrameWorkCode.AESDecrypt(KEY: self.key, IV: self.iv, StringForDescription: Message)
            let MesageGot : NSDictionary = FrameWorkCode.StringconvertToDictionary(text: Decript)! as NSDictionary
            MainChatArray.add(MesageGot)
            self.mTableViewChat.reloadData()
        })
    }
    
    

}



