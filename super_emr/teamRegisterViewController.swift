//
//  teamRegisterViewController.swift
//  super_emr
//
//  Created by 王佳华 on 10/22/16.
//  Copyright © 2016 王佳华. All rights reserved.
//

import UIKit
import Alamofire

class teamRegisterViewController: UIViewController {

    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var majarRange: UITextField!
    @IBOutlet weak var serviceRegion: UITextField!
    @IBOutlet weak var ServiceGoal: UITextField!
    @IBOutlet weak var Sponser: UITextField!
    @IBOutlet weak var telephone: UITextField!
    @IBOutlet weak var email: UITextField!
    
    let url = baseurl
    var user = 0
    var username = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getUserID()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SubmitButton(sender: UIButton) {
        self.submit()
    }
    func getUserID(){
        Alamofire.request(.GET, self.url + "/api/selfUsersEx/?format=json", parameters: nil)
            .validate()
            .responseJSON {response in
                    let jsonData = response.result.value as! Dictionary<String,AnyObject>
                    let results = jsonData["results"] as! [Dictionary<String,AnyObject>]
                    self.user = results[0]["user"] as! Int
                    print(self.user, terminator: "")
        }
    }
    
    func submit(){
        //注册按钮按下
        let csrftoken = getCsrftoken()
        let params = ["csrfmiddlewaretoken":csrftoken as String,
                      "teamName": self.teamName.text as String!,
                      "password": "adgw76t7qfyda562h",
                      "email": self.email.text as String!,
                      "majarRange":self.majarRange.text as String!,
                      "serviceRegion":self.serviceRegion.text as String!,
                      "serviceGoal":self.ServiceGoal.text as String!,
                      "Sponser":self.Sponser.text as String!,
                      "telephone":self.telephone.text as String!
        ]
        Alamofire.request(.POST, self.url+"/registTeam/", parameters: params)
            .validate()
            .responseJSON {response in
                //                print(response)
                let jsonData = response.result.value as! Dictionary<String,AnyObject>
                let code = jsonData["code"] as! Int
                print(jsonData)
                //Convert NSData to NSString
                //Convert NSString to String
                if code==0{
                    //
                    self.teamName.text = ""
                    self.email.text = ""
                    self.majarRange.text = ""
                    self.serviceRegion.text = ""
                    self.ServiceGoal.text = ""
                    self.Sponser.text = ""
                    self.telephone.text = ""
                    let alertController = UIAlertController(title: "公众号注册", message:"团队注册成功", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }else{
                    let msg = jsonData["msg"] as! String
                    print(msg)
                    let alertController = UIAlertController(title: "团队注册", message:msg, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
        }
    }
    func getCsrftoken()->String{
        let cookies:[NSHTTPCookie] = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookiesForURL(NSURL(string:self.url)!) as [NSHTTPCookie]!
        var csrftoken:String?
        for cookie in cookies{
            if cookie.name == "csrftoken"{
                csrftoken = cookie.value
            }
        }
        return csrftoken!
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
