//
//  publicCountManagementViewController.swift
//  super_emr
//
//  Created by 王佳华 on 10/23/16.
//  Copyright © 2016 王佳华. All rights reserved.
//

import UIKit

class publicCountManagementViewController: UIViewController {

    var publiccount = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func peopleMrg(sender: UIButton) {
        let Table = UIStoryboard(name: "doctor", bundle: nil).instantiateViewControllerWithIdentifier("publicPeopleManagement") as! publicPeopleManagementTableViewController
        Table.publiccount = publiccount
        self.navigationController?.pushViewController(Table, animated: true)
        
    }

    @IBAction func comman(sender: UIButton) {
    }
    @IBAction func frontPageMrg(sender: UIButton) {
    }
    @IBOutlet weak var publicCountSetting: UIButton!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
