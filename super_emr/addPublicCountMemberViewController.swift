//
//  addFriendsViewController.swift
//  super_emr
//
//  Created by 王佳华 on 8/29/16.
//  Copyright © 2016 王佳华. All rights reserved.
//

import UIKit
import Alamofire

class addPublicCountMemberViewController: UIViewController {
    
    let url = baseurl
    
    @IBOutlet weak var friendName: UITextField!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var addFriendsButton: UIButton!
    
    var nickname = ""
    var type = ""
    var PublicName = ""
    
    @IBAction func Search(sender: UIButton) {
        //登陆按钮按下
        let username = self.friendName.text
        //        let csrftoken = getCsrftoken()
        //println(username)
        let params = [//"csrfmiddlewaretoken":csrftoken as String,
            "nickname": username as String!
        ]
        Alamofire.request(.GET, self.url+"/api/usersEx/", parameters: params)
            .validate()
            .responseJSON {response in
                //                print(response)
                let jsonData = response.result.value as! Dictionary<String,AnyObject>
                                print(jsonData)
                let count = jsonData["count"] as! Int
                if (count>0){
                    let url = jsonData["results"]![0]["user_image"] as! String
                    self.userImageLoad(url)
                    self.nickname = jsonData["results"]![0]["nickname"] as! String
                    var x = ""
                    let user_type = jsonData["results"]![0]["user_type"] as! String
                    self.type = user_type
                    if(user_type == "A"){
                        x="病人："
                    }else if(user_type == "B"){
                        x="医生："
                    }else if(user_type == "C"){
                        x="宝贝："
                    }
                    self.label1.text = x + self.nickname
                }else{
                    self.label1.text = ""
                    self.img1.image = nil
                    let alertController = UIAlertController(title: "用户查找", message:"未找到该用户，请核对用户名", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
        }
    }
    @IBAction func addFriendsButtonTouchUp(sender: UIButton) {
        if(self.type == "B" || self.type == "A"){
            let params = ["csrfmiddlewaretoken":self.getCsrftoken(),
                          "publicName": self.PublicName as String!,
                          "doctorName": self.nickname as! String!,
                          "optation": "add"
            ]
            Alamofire.request(.POST, self.url+"/Ajax/operate_relative_user/", parameters: params)
                .validate()
                .response { request, response, data, error in
                    print(request)
                    print(response)
                    print(data)
                    print(error)
                    //Convert NSData to NSString
                    let resultNSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                    //Convert NSString to String
                    let resultString = resultNSString as String
                    print(resultString)
                    if error==nil && resultString == "adding member successful"{
                        let alertController = UIAlertController(title: "公众号管理", message:"医生添加成功", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }else{
                        let alertController = UIAlertController(title: "公众号管理", message:resultString, preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
            }
        }else{
            let alertController = UIAlertController(title: "公众号管理", message:"该用户不是病人", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
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
    //验证码加载
    func userImageLoad(url: String){
        Alamofire.request(.GET, url, parameters: nil)
            .validate()
            .response { request, response, data, error in
                
                let image = UIImage(data: data! as NSData)
                self.img1.image = image
        }
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
