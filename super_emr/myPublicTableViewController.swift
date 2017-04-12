//
//  mydoctorTableViewController.swift
//  super_emr
//
//  Created by 王佳华 on 10/2/16.
//  Copyright © 2016 王佳华. All rights reserved.
//
import Foundation
import UIKit
import Alamofire

class myPublicTableViewController: UITableViewController {
    
    let url = baseurl
    var doctors:NSMutableArray=[]
    var user = 0
    var username = ""
    var token = ""
    var portrait = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.getUserID()
    }
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
        
        Alamofire.request(.GET, self.url + "/api/selfRelatedUsersEx/?format=json", parameters: nil)
            .validate()
            .responseJSON {response in
                let jsonData = response.result.value as! Dictionary<String,AnyObject>
                let results = jsonData["results"] as! [Dictionary<String,AnyObject>]
                for rel in results{
                    let type = rel["user_type"] as! String
                    if (type == "D"){
                        self.doctors.addObject(rel)
                    }
                    //                    self.doctors.addObject(rel)
                }
//                print(self.doctors)
                self.tableView.reloadData()//重载数据
        }
    }
    func getDayOfWeek()->Int? {
        // sunday 0  monday 1    saturday 6
        let todayDate = NSDate()
//        let formatter  = NSDateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let todayDate = formatter.dateFromString("2016-12-10")!
        
        let myCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var myComponents = myCalendar!.components(.Weekday, fromDate: todayDate)
        var weekDay = myComponents.weekday
        
        weekDay -= 1
        return weekDay
    }
    
    func privateChat(index: Int) {
        //打开会话界面
        //        let x : Int = self.doctors[index]["user"] as! Int
        //        let xNSNumber = x as NSNumber
        //        let xString : String = xNSNumber.stringValue
        var dn = 0
        var destination = ""
        let members = self.doctors[index]["relative_set"] as! [Dictionary<String,AnyObject>]
        let date = self.getDayOfWeek()
        for rel in members{
            let type = rel["workday"] as! Int
            if (type == date){
                dn += 1
                destination = rel["nickname"] as! String
            }
        }
        if(dn > 0){
            let xString : String = self.doctors[index]["nickname"] as! String
            let xStringDesc = destination
            let chatWith = RCConversationViewController(conversationType: RCConversationType.ConversationType_PRIVATE, targetId:xStringDesc )
            chatWith.title = xString + "-" + xStringDesc
            chatWith.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(chatWith, animated: true)
        }else{
            let alertController = UIAlertController(title: "公众号咨询", message:"该公众号今日没有医生值班", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
//        let xString : String = self.doctors[index]["nickname"] as! String
//        let chatWith = RCConversationViewController(conversationType: RCConversationType.ConversationType_GROUP, targetId:xString )
//        chatWith.title = self.doctors[index]["nickname"] as! String
//        chatWith.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(chatWith, animated: true)
//        //        self.presentViewController(chatWith, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        print(self.doctors.count)
        return self.doctors.count
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
                                            
                                            //                                            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                                            //                                                //打开会话列表
                                            //                                                let chatListView = DemoChatListViewController()
                                            //                                                self.navigationController?.pushViewController(chatListView, animated: true)
                                            //                                                })
            }, error: { (status) -> Void in
                print("登陆的错误码为:\(status.rawValue)")
            }, tokenIncorrect: {
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                print("token错误")
        })
    }
    
    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myPublicTableCell", forIndexPath: indexPath) as! myPublicTableViewCell
        
        // Configure the cell...
        let cellData = self.doctors[indexPath.row] as! Dictionary<String,AnyObject>
        cell.username?.text = cellData["nickname"] as? String
//        cell.link = (cellData["user_image"] as? String)!
//        cell.refreshUserImage()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        self.loginRongCloud( indexPath.row as Int)
        self.privateChat( indexPath.row as Int)
        
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
