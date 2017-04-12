//
//  EMRIndexTableViewController.swift
//  super_emr
//
//  Created by 王佳华 on 11/30/15.
//  Copyright (c) 2015 王佳华. All rights reserved.
//

import UIKit
import Alamofire

struct RMRDataType{
    var title:String! = nil
    var id:String! = nil
    var recordType:String! = nil
    var hospital:String! = nil
    var doctor:String! = nil
    var RecordOccurTime:String! = nil
    var upload_datetime:String! = nil
    var diagnosis:String! = nil
    var symptomDescription:String! = nil
    var voiceDescription0:String! = nil
    var voiceDescription1:String! = nil
    var voiceDescription2:String! = nil
    var voiceDescription3:String! = nil
    var voiceDescription4:String! = nil
    var imageRecord0:String! = nil
    var imageRecord1:String! = nil
    var imageRecord2:String! = nil
    var imageRecord3:String! = nil
    var imageRecord4:String! = nil
    var imageRecord5:String! = nil
    var imageRecord6:String! = nil
    var imageRecord7:String! = nil
    var user:String! = nil
}

class EMRIndexTableViewController: UITableViewController{//, UITableViewDelegate, UITableViewDataSource {

    let url = baseurl
    var EMRData:NSArray=[]
    var user = 0
    var username = ""
    var style = 0
    
    
//    init(param: Int,username: String) {
//        self.style = param
//        self.username = username
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        getUserID()
//        if(self.style == 0){
//            getUserID()
//        }else{
//            getPatientID()
//        }
        
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
                    self.loadEMRJsonData()
                }
            }
    }
    
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
                self.loadEMRJsonData1()
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
            "recordType": "4",
            "user": userString
        ]
        
        Alamofire.request(.GET, tableUrl, parameters: params)
            .validate()
            .responseJSON {response in
                print(response)
                let jsonData = response.result.value as! Dictionary<String,AnyObject>
                if(self.style == 0){
                    self.EMRData = jsonData["results"] as! NSArray
                    self.tableView.reloadData()//重载数据
                }
                }
    }
    func loadEMRJsonData1(){
        let tableUrl = self.url + "/api/myMedicalRecords/"//验证图片地址
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.timeoutIntervalForRequest = 5    // 秒
        
        let userNSNumber = self.user as NSNumber
        let userString : String = userNSNumber.stringValue
        let params = [
            "recordType": "4",
            "user": userString
        ]
        
        Alamofire.request(.GET, tableUrl, parameters: params)
            .validate()
            .responseJSON {response in
                print(response)
                let jsonData = response.result.value as! Dictionary<String,AnyObject>
                self.EMRData = jsonData["results"] as! NSArray
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
        let cell = tableView.dequeueReusableCellWithIdentifier("EMRIndexCell", forIndexPath: indexPath) as! EMRIndexTableViewCell

        // Configure the cell...
        let emrData = EMRData[indexPath.row] as! Dictionary<String,AnyObject>
        print(emrData, terminator: "")
        cell.symptomDescription?.text = emrData["symptomDescription"] as? String
        cell.upload_datetime?.text = emrData["upload_datetime"] as? String
        cell.RecordOccurTime?.text = emrData["RecordOccurTime"] as? String

        return cell
    }

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("segueDetailView", sender: indexPath)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier=="segueDetailView"{
            if let indexPath = sender as? NSIndexPath{
                let dest = segue.destinationViewController as! DetailViewController
                let emrData = EMRData[indexPath.row] as! Dictionary<String,AnyObject>
                dest.emrData = emrData
            }
        }
    }

}
