//
//  medicalEatRecordTableViewController.swift
//  super_emr
//
//  Created by 王佳华 on 8/21/16.
//  Copyright (c) 2016 王佳华. All rights reserved.
//

import UIKit
import Alamofire

struct medicalEat{
    var id:String! = nil
    var medicine:String! = nil
    var method:String! = nil
    var how_use:String! = nil
    var eatTime:String! = nil
    var resultDescription:String! = nil
    var upload_datetime:String! = nil
    var user:String! = nil
}

class medicalEatRecordTableViewController: UITableViewController {

    let url = baseurl
    var MERData:NSArray=[]
    var user = 0
    var style = 0
    var username = ""
    
    func getPatientID(){
        self.style = 1
        let parm = [
            "format" : "json",
            "user_type" : "A",
            "nickname" : self.username
        ]
        Alamofire.request(.GET, self.url + "/api/usersEx/", parameters: parm)
            .validate()
            .responseJSON {response in
                let jsonData = response.result.value as! Dictionary<String,AnyObject>
                let results = jsonData["results"] as! [Dictionary<String,AnyObject>]
                self.user = results[0]["user"] as! Int
                print(self.user, terminator: "")
                self.loadmedicalEatRecordsJsonData1()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        getUserID()
        
    }
    func getUserID(){
        Alamofire.request(.GET, self.url + "/api/selfUsersEx/?format=json", parameters: nil)
            .validate()
            .responseJSON {response in
                if(self.style == 0){
                    let jsonData = response.result.value as! Dictionary<String,AnyObject>
                    let results = jsonData["results"] as! [Dictionary<String,AnyObject>]
                    self.user = results[0]["user"] as! Int
                    print(self.user, terminator: "")
                    self.loadmedicalEatRecordsJsonData()
                }
            }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadmedicalEatRecordsJsonData(){
        let tableUrl = self.url + "/api/myMedicineEatRecord/"//
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 5    // 秒
        
        let userNSNumber = self.user as NSNumber
        let userString : String = userNSNumber.stringValue
        let params = [
            "format": "json",
            "user": userString
        ]
        
        Alamofire.request(.GET, tableUrl, parameters: params)
            .validate()
            .responseJSON {response in
                if(self.style == 0){
                    let jsonData = response.result.value as! Dictionary<String,AnyObject>
                    self.MERData = jsonData["results"] as! NSArray
                    //                    println(self.EMRData)
                    //                    println(self.EMRData.count)
                    self.tableView.reloadData()//重载数据
                }
            }
    }
    
    func loadmedicalEatRecordsJsonData1(){
        let tableUrl = self.url + "/api/myMedicineEatRecord/"//
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 5    // 秒
        
        let userNSNumber = self.user as NSNumber
        let userString : String = userNSNumber.stringValue
        let params = [
            "format": "json",
            "user": userString
        ]
        
        Alamofire.request(.GET, tableUrl, parameters: params)
            .validate()
            .responseJSON {response in
                if(self.style == 1){
                    let jsonData = response.result.value as! Dictionary<String,AnyObject>
                    self.MERData = jsonData["results"] as! NSArray
                    //                    println(self.EMRData)
                    //                    println(self.EMRData.count)
                    self.tableView.reloadData()//重载数据
                }
        }
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
        print(MERData.count)
        return MERData.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("medicalEatRecordTableViewCell", forIndexPath: indexPath) as! medicalEatRecordTableViewCell
        
        // Configure the cell...
        
        let emrData = MERData[indexPath.row] as! Dictionary<String,AnyObject>
        print(emrData, terminator: "")
        cell.medicine?.text = emrData["medicine"] as? String
        cell.method?.text = emrData["method"] as? String
        cell.how_use?.text = emrData["how_use"] as? String
        cell.eatTime?.text = emrData["eatTime"] as? String
        cell.resultDescription?.text = emrData["resultDescription"] as? String
        
        return cell
    }
    
//    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        performSegueWithIdentifier("segueDetailView", sender: indexPath)
//    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
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
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//        if segue.identifier=="segueDetailView"{
//            if let indexPath = sender as? NSIndexPath{
//                let dest = segue.destinationViewController as! DetailViewController
//                let emrData = MERData[indexPath.row] as! Dictionary<String,AnyObject>
//                dest.emrData = emrData
//            }
//        }
//    }

}
