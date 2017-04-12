//
//  Register2ViewController.swift
//  super_emr
//
//  Created by 王佳华 on 11/6/15.
//  Copyright (c) 2015 王佳华. All rights reserved.
//

import UIKit
import Alamofire

class Register2ViewController: UIViewController {
    
    let url = baseurl
    var captcha0:String?
    
    @IBOutlet weak var captchaImage: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var captcha: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        captchaImageLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(sender: UIButton) {
        //注册按钮按下
        let username = self.username.text
        let password = self.password.text
        let email  = self.email.text
        let captcha1  = self.captcha.text
        let csrftoken = getCsrftoken()
        //println(username)
        let params = ["csrfmiddlewaretoken":csrftoken as String!,
                      "username": username as String!,
                      "password":password as String!,
                      "password1":password as String!,
                      "email":email as String!,
                      "is_patient":"doctor" as String!,
                      "captcha_0":self.captcha0 as String!,
                      "captcha_1":captcha1 as String!
        ]
        Alamofire.request(.POST, self.url+"/regist/", parameters: params)
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
                if error==nil && resultString == "注册成功,请查收邮件激活账号"{
                    //界面跳转   登陆->主界面
                    //self.performSegueWithIdentifier("segue2Register2Login", sender: self)
                    let login = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as! LoginViewController
                    let window = UIApplication.sharedApplication().delegate?.window
                    let nav = UINavigationController(rootViewController: login)
                    window!!.rootViewController = nav
                }
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
    //验证码加载
    func captchaImageLoad(){
        Alamofire.request(.GET, self.url+"/emr/regist/", parameters: nil)
            .validate()
            .response { request, response, data, error in
                print(request)
                print(response)
                print(data)
                print(error)
                if error==nil{
                    //                                        println(request)
                    //                                        println(response)
                    //                                        println(data)
                    var err : NSError?
                    //Convert NSData to NSString
                    let resultNSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                    //Convert NSString to String
                    let resultString = resultNSString as String
                    
                    //print(resultString)
                    var parser     = HTMLParser(html: resultString, error: &err)
                    if err == nil{
                        if response?.URL! != NSURL(string: self.url + "/emr/index/")!{
                            var bodyNode   = parser.body
                            var img = bodyNode?.findChildTag("img")
                            let imgUrl = self.url + img!.getAttributeNamed("src")//验证图片地址
                            self.captcha0 = bodyNode?.findNodeById("id_captcha_0")!.getAttributeNamed("value")
                            print(self.captcha0)
                            Alamofire.request(.GET, imgUrl, parameters: nil)
                                .validate()
                                .response { request, response, data, error in
                                    print(request)
                                    print(response)
                                    print(data)
                                    print(error)
                                    let image = UIImage(data: data! as NSData)
                                    self.captchaImage.image = image
                            }
                        }else{
                            self.performSegueWithIdentifier("segueLogin", sender: self)
                        }
                        
                    }else{
                        NSLog("captcha image url error: \(err)")
                    }
                }else{
                    NSLog("login view request error: \(error)")
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
    
}
