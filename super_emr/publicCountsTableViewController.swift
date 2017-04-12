//
//  publicCountsTableViewController.swift
//  super_emr
//
//  Created by 王佳华 on 10/23/16.
//  Copyright © 2016 王佳华. All rights reserved.
//

import UIKit
import Alamofire

class publicCountsTableViewController: UITableViewController {

    let url = baseurl
    var PublicCounts:NSMutableArray=[]
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
                print(response)
                let jsonData = response.result.value as! Dictionary<String,AnyObject>
                let results = jsonData["results"] as! [Dictionary<String,AnyObject>]
                self.user = results[0]["user"] as! Int
                self.token = results[0]["demo"] as! String
                self.username = results[0]["nickname"] as! String
                self.portrait = results[0]["user_image"] as! String
        }
        
        Alamofire.request(.GET, self.url + "/api/selfRelatedUsersEx/?format=json", parameters: nil)
            .validate()
            .responseJSON {response in
                let jsonData = response.result.value as! Dictionary<String,AnyObject>
                let results = jsonData["results"] as! [Dictionary<String,AnyObject>]
                for rel in results{
                    let type = rel["user_type"] as! String
                    if (type == "D"){
                        self.PublicCounts.addObject(rel)
                    }
                    //                    self.PublicCounts.addObject(rel)
                }
                //print(self.PublicCounts)
                self.tableView.reloadData()//重载数据
        }
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
        print(self.PublicCounts.count)
        return self.PublicCounts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PublicCountTableCell", forIndexPath: indexPath) as! publicCountCellTableViewCell
        
        // Configure the cell...
        let cellData = self.PublicCounts[indexPath.row] as! Dictionary<String,AnyObject>
        cell.name?.text = cellData["nickname"] as? String
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        self.loginRongCloud( indexPath.row as Int)
//        self.privateChat( indexPath.row as Int)
        let cellDetailTable = UIStoryboard(name: "doctor", bundle: nil).instantiateViewControllerWithIdentifier("publicCountManagement") as! publicCountManagementViewController
        let cellData = self.PublicCounts[indexPath.row] as! Dictionary<String,AnyObject>
        
        cellDetailTable.publiccount = cellData
        cellDetailTable.title = cellData["nickname"] as! String
        
        self.navigationController?.pushViewController(cellDetailTable, animated: true)
        
        
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
