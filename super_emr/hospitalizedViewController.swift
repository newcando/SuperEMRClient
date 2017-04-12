//
//  hospitalizedViewController.swift
//  super_emr
//
//  Created by 王佳华 on 8/20/16.
//  Copyright (c) 2016 王佳华. All rights reserved.
//

import UIKit
import Alamofire


class hospitalizedViewController: UITableViewController{//, UITableViewDelegate, UITableViewDataSource  {

    let url = baseurl
    var EMRData:NSArray=[]
    var user = 0
    
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
            .responseJSON{ response in
                print(response.response) // URL response
                let jsonData = response.result.value as! Dictionary<String,AnyObject>
                let results = jsonData["results"] as! [Dictionary<String,AnyObject>]
                self.user = results[0]["user"] as! Int
                print(self.user, terminator: "")
                self.loadEMRJsonData()
                }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadEMRJsonData(){
        let tableUrl = self.url + "/api/myMedicalRecords/"//验证图片地址
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 5    // 秒
        
        let userNSNumber = self.user as NSNumber
        let userString : String = userNSNumber.stringValue
        let params = [
            "recordType": "2",
            "user": userString
        ]
        
        Alamofire.request(.GET, tableUrl, parameters: params)
            .validate()
            .responseJSON { response in
                print(response)
                    let jsonData = response.result.value as! Dictionary<String,AnyObject>
                    self.EMRData = jsonData["results"] as! NSArray
                    //                    println(self.EMRData)
                    //                    println(self.EMRData.count)
                    self.tableView.reloadData()//重载数据
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
        print(EMRData.count)
        return EMRData.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EMPPhotoIndexCell", forIndexPath: indexPath) as! EMRPhotoTableViewCell
        
        // Configure the cell...
        let emrData = EMRData[indexPath.row] as! Dictionary<String,AnyObject>
        print(emrData, terminator: "")
        cell.symptomDescription?.text = emrData["symptomDescription"] as? String
        cell.upload_datetime?.text = emrData["upload_datetime"] as? String
        cell.RecordOccurTime?.text = emrData["RecordOccurTime"] as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("hospitallizedSegue", sender: indexPath)
    }
    
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier=="hospitallizedSegue"{
            if let indexPath = sender as? NSIndexPath{
                let dest = segue.destinationViewController as! EMRDetailViewController
                let emrData = EMRData[indexPath.row] as! Dictionary<String,AnyObject>
                dest.emrData = emrData
            }
        }
    }

}
