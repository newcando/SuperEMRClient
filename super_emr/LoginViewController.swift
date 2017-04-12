//
//  LoginViewController.swift
//  super_emr
//
//  Created by 王佳华 on 11/18/15.
//  Copyright (c) 2015 王佳华. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    let url = baseurl
    var captcha0:String?
    
    @IBOutlet weak var captchaImage: UIImageView!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var captchaResult: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        RCIM.sharedRCIM().initWithAppKey("pwe86ga5ep576")//App Secret i30RzGlwaeyt
//        printCookie()
        //获取验证码
        captchaImageLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func refreshCaptcha(sender: UITapGestureRecognizer) {
        //获取验证码
        captchaImageLoad()
    }
    
    @IBAction func LoginButton(sender: UIButton) {
        //登陆按钮按下
        let username = self.Username.text
        let password = self.Password.text
        let captcha1  = self.captchaResult.text
        let csrftoken = getCsrftoken()
        //println(username)
        let params = ["csrfmiddlewaretoken":csrftoken as String,
                      "username": username as String!,
                      "password":password as String!,
                      "captcha_0":self.captcha0 as String!,
                      "captcha_1":captcha1 as String!
        ]
        Alamofire.request(.POST, self.url+"/login2/", parameters: params)
            .validate()
            .responseJSON {response in
                print(response)
                let jsonData = response.result.value as! Dictionary<String,AnyObject>
                //let rongcloud = jsonData["rongcloud"] as! [Dictionary<String,AnyObject>]
                //Convert NSString to String
                let resultString = jsonData["type"] as! String
                
                if (resultString == "A" ){//patient
                    //界面跳转   登陆->主界面
                    self.performSegueWithIdentifier("segueLogin", sender: self)
                    self.printCookie()
                }else if(resultString == "B" ){//doctor
                    self.performSegueWithIdentifier("doctorlogin", sender: self)
                    self.printCookie()
                }else{
                    let alertController = UIAlertController(title: "登陆", message:"登录失败", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
        }
    }
    @IBAction func goBackToLoginView(segue:UIStoryboardSegue){
        //dismissViewControllerAnimated(true, completion: nil)
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
    func printCookie(){
        let cookies:[NSHTTPCookie] = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookiesForURL(NSURL(string:self.url)!)! as [NSHTTPCookie]
        //var csrftoken:String?
        for cookie in cookies{
            print(cookie.name,cookie.value)
            print(cookie.expiresDate)
        }
    }
    //验证码加载
    func captchaImageLoad(){
        Alamofire.request(.GET, self.url, parameters: nil)
            .validate()
            .response { request, response, data, error in
//                print(request)
//                print(response)
//                print(data)
//                print(error)
                print(response?.URL! )
                var err : NSError?
                //Convert NSData to NSString
                let resultNSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                //Convert NSString to String
                let resultString = resultNSString as String
                var parser     = HTMLParser(html: resultString, error: &err)
                if err == nil{
                    if response?.URL! != NSURL(string: self.url + "/emr/index/")!{
                        var bodyNode   = parser.body
                        var img = bodyNode?.findChildTag("img")
                        let imgUrl = self.url + img!.getAttributeNamed("src")//验证图片地址
                        self.captcha0 = bodyNode?.findNodeById("id_captcha_0")!.getAttributeNamed("value")
                        //println(self.captcha0)
                        Alamofire.request(.GET, imgUrl, parameters: nil)
                            .validate()
                            .response { request, response, data, error in
                                print(request)
                                print(response)
                                print(data)
                                print(error)
                                let image = UIImage(data: data! as NSData)
                                if(image != nil){
                                    self.captchaImage.image = image
                                }
                                
                        }
                    }else{
                        Alamofire.request(.GET, self.url+"/login2/", parameters: nil)
                            .validate()
                            .responseJSON {response in
                                print(response)
                                let jsonData = response.result.value as! Dictionary<String,AnyObject>
                                print(jsonData)
                                //let rongcloud = jsonData["rongcloud"] as! [Dictionary<String,AnyObject>]
                                //Convert NSString to String
                                let resultString = jsonData["type"] as! String
                                
                                if (resultString == "A" ){//patient
                                    //界面跳转   登陆->主界面
                                    self.performSegueWithIdentifier("segueLogin", sender: self)
                                    self.printCookie()
                                }else if(resultString == "B" ){//doctor
                                    self.performSegueWithIdentifier("doctorlogin", sender: self)
                                    self.printCookie()
                                }else{
                                    let alertController = UIAlertController(title: "登陆", message:"登录失败", preferredStyle: UIAlertControllerStyle.Alert)
                                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                                    self.presentViewController(alertController, animated: true, completion: nil)
                                }
                        }
                    }
                
                }else{
                    NSLog("captcha image url error: \(err)")
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

}
