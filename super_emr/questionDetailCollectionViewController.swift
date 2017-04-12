//
//  questionDetailCollectionViewController.swift
//  super_emr
//
//  Created by 王佳华 on 10/10/16.
//  Copyright © 2016 王佳华. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class questionDetailCollectionViewController: RCConversationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "病人信息", style: UIBarButtonItemStyle.Plain, target: self, action: "openpatientInfo")
    }


    func openemr() {
        print("openemr")
        let emrTable = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("emrTable") as! super_emr.EMRIndexTableViewController
        emrTable.username = self.title!
        emrTable.getPatientID()
        self.navigationController?.pushViewController(emrTable, animated: true)
    }
    
    func openpatientInfo() {
        print("openpatientInfo")
        let openpatientInfo = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("patientInfo") as! patientInfoViewController
        openpatientInfo.username = self.title!
        openpatientInfo.getPatientID()
        self.navigationController?.pushViewController(openpatientInfo, animated: true)
    }
    
    

}
