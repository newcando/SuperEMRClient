//
//  findPasswordViewController.swift
//  super_emr
//
//  Created by 王佳华 on 8/17/16.
//  Copyright (c) 2016 王佳华. All rights reserved.
//

import UIKit
import Alamofire

class findPasswordViewController: UIViewController {

    let url = baseurl
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBAction func findPasswordButton(sender: UIButton) {
        let username = self.nickname.text
        let email = self.email.text
        let params = ["email": email as String!,
                      "username": username as String!]
        
        Alamofire.request(.GET, self.url + "/Ajax/find_password/", parameters: params)
            .validate()
            .responseJSON {response in
                if(response.result.value==nil){
                    let alertController = UIAlertController(title: "找回密码", message:"服务器出错", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }else{
                    let jsonData = response.result.value as! Dictionary<String,AnyObject>
                    let error = jsonData["error"] as! String
                    self.nickname.text = ""
                    self.email.text = ""
                    let alertController = UIAlertController(title: "找回密码", message:error, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                

        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
