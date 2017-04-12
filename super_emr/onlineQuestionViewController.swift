//
//  onlineQuestionViewController.swift
//  super_emr
//
//  Created by 王佳华 on 10/9/16.
//  Copyright © 2016 王佳华. All rights reserved.
//

import UIKit
import Alamofire

class onlineQuestionViewController: UIViewController {

    let url = baseurl
    var doctors:NSMutableArray=[]
    var user = 0
    var username = ""
    var token = ""
    var portrait = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.getUserID()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onlineQuestion(sender: UIButton) {
//        let chatList = DemoChatListViewController()
//        self.navigationController?.pushViewController(chatList, animated: true)
        self.getUserID()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func getUserID(){
        Alamofire.request(.GET, self.url + "/api/selfUsersEx/?format=json", parameters: nil)
            .validate()
            .responseJSON {response in
                let jsonData = response.result.value as! Dictionary<String,AnyObject>
                let results = jsonData["results"] as! [Dictionary<String,AnyObject>]
                self.user = results[0]["user"] as! Int
                self.token = results[0]["demo"] as! String
                self.username = results[0]["nickname"] as! String
                self.portrait = results[0]["user_image"] as! String
                self.loginRongCloud()
        }
    }
    func loginRongCloud() {
        //登录融云服务器的token。需要您向您的服务器请求，您的服务器调用server api获取token
        //开发初始阶段，您可以先在融云后台API调试中获取
        let token = self.token
        let portrait = self.portrait
        if (token==""){
            return
        }
        print(token)
        //连接融云服务器
        RCIM.sharedRCIM().connectWithToken(token,
                                           success: { (userId) -> Void in
                                            print("登陆成功。当前登录的用户ID：\(userId)")
                                            //设置当前登陆用户的信息
                                            RCIM.sharedRCIM().currentUserInfo = RCUserInfo.init(userId: userId, name: self.username, portrait: portrait)
                                            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                                                //打开会话列表
                                                let chatListView = DemoChatListViewController()
//                                                chatListView.hidesBottomBarWhenPushed = true
                                                self.navigationController?.pushViewController(chatListView, animated: true)
                                            })
            }, error: { (status) -> Void in
                print("登陆的错误码为:\(status.rawValue)")
            }, tokenIncorrect: {
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                print("token错误")
        })
    }

}
