//
//  patientInfoViewController.swift
//  super_emr
//
//  Created by 王佳华 on 10/15/16.
//  Copyright © 2016 王佳华. All rights reserved.
//

import UIKit
import Alamofire

class patientInfoViewController: UIViewController {

    var username = ""
    let url = baseurl
    var user = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPatientID(){
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
        }
    }
    
    @IBAction func patientEMR(sender: UIButton) {
        self.openemr()
    }

    @IBAction func xueya(sender: UIButton) {
        self.openXueya()
    }
    @IBAction func xuetang(sender: UIButton) {
        self.openXuetang()
    }
    @IBAction func yongyao(sender: UIButton) {
        self.openmedicalEatRecordTableViewController()
    }
    
    func openemr() {
        print("openemr")
        let emrTable = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("emrTable") as! super_emr.EMRIndexTableViewController
        emrTable.username = self.username
        emrTable.getPatientID()
        self.navigationController?.pushViewController(emrTable, animated: true)
    }
    func openXueya() {
        print("openXueya")
        let emrTable = UIStoryboard(name: "doctor", bundle: nil).instantiateViewControllerWithIdentifier("xuyaID") as! xueyaViewController
        emrTable.username = self.username
        emrTable.getPatientID()
        self.navigationController?.pushViewController(emrTable, animated: true)
    }
    func openXuetang() {
        print("openXuetang")
        let emrTable = UIStoryboard(name: "doctor", bundle: nil).instantiateViewControllerWithIdentifier("xuetangid") as! xuetangViewController
        emrTable.username = self.username
        emrTable.getPatientID()
        self.navigationController?.pushViewController(emrTable, animated: true)
    }
    func openmedicalEatRecordTableViewController() {
        print("openmedicalEatRecordTableViewController")
        let emrTable = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("medicalEatRecord") as! medicalEatRecordTableViewController
        emrTable.username = self.username
        emrTable.getPatientID()
        self.navigationController?.pushViewController(emrTable, animated: true)
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
