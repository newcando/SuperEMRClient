//
//  publicPeopleManagementTableViewController.swift
//  super_emr
//
//  Created by 王佳华 on 10/23/16.
//  Copyright © 2016 王佳华. All rights reserved.
//

import UIKit

class publicPeopleManagementTableViewController: UITableViewController {

//    var refreshCtrl = UIRefreshControl()
    
    var publiccount = [:]
    var members = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//        print(publiccount)
        //添加刷新
//        self.refreshCtrl.addTarget(self, action: "refreshData",
//                                 forControlEvents: UIControlEvents.ValueChanged)
//        self.refreshCtrl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: UIBarButtonItemStyle.Plain, target: self, action: "addMember")
        self.membersSort()
        self.tableView.reloadData()//重载数据
    }
    func refreshData(){
    }
    
    func addMember(){
        //
        let emrTable = UIStoryboard(name: "doctor", bundle: nil).instantiateViewControllerWithIdentifier("addPublicCountMember") as! addPublicCountMemberViewController
        emrTable.PublicName = self.publiccount["nickname"] as! String
        self.navigationController?.pushViewController(emrTable, animated: true)
    }

    func membersSort(){
        self.members = publiccount["relative_set"] as! [Dictionary<String,AnyObject>]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.members.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pubplicPeopleMrgCell", forIndexPath: indexPath) as!publicPeopleMrgTableViewCell
        // Configure the cell...
        
        let cellData = self.members[indexPath.row] as! Dictionary<String,AnyObject>
        cell.name.text = cellData["nickname"] as? String
        cell.member = cellData
        let workday = (cellData["workday"] as? Int)!
        var str = ""
        switch(workday){
            case 1:str = "周一"
            case 2:str = "周二"
            case 3:str = "周三"
            case 4:str = "周四"
            case 5:str = "周五"
            case 6:str = "周六"
            case 0:str = "周日"
            default:str = "周一"
        }
        cell.workday.text = str
        cell.publicUser = publiccount["nickname"] as! String

        return cell
    }
 
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        //performSegueWithIdentifier("detailDoctorWorkSchedule", sender: indexPath)
        let d = UIStoryboard(name: "doctor", bundle: nil).instantiateViewControllerWithIdentifier("doctorschedule") as! doctorworkschedule
        let cellData = self.members[indexPath.row] as! Dictionary<String,AnyObject>
        d.name = (cellData["nickname"] as? String)!
        d.workdayint = (cellData["workday"] as? Int)!
        
        self.navigationController?.pushViewController(d, animated: true)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//        if segue.identifier=="detailDoctorWorkSchedule"{
//            if let indexPath = sender as? NSIndexPath{
//                let dest = segue.destinationViewController as! doctorworkschedule
//                dest.name = "sds"
//            }
//        }
//    }

}
