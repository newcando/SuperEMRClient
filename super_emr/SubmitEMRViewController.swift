//
//  SubmitEMRViewController.swift
//  super_emr
//
//  Created by 王佳华 on 11/25/15.
//  Copyright (c) 2015 王佳华. All rights reserved.
//

import UIKit
import Alamofire

class SubmitEMRViewController: UIViewController {

    let url = baseurl
    
    @IBOutlet weak var emrtitle: UITextField!
    @IBOutlet weak var type: UISegmentedControl!
    @IBOutlet weak var hospital: UITextField!
    @IBOutlet weak var doctor: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var symptom: UITextField!
    @IBOutlet weak var diagnose: UITextField!
    @IBOutlet weak var image1: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //time.text = getCurrentTime()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitEMR(sender: UIButton) {
        let params = ["title":emrtitle.text as String!,
            "recordType": String(type.selectedSegmentIndex+1) as String!,
            "hospital":hospital.text as String!,
            "doctor":doctor.text as String!,
            "RecordOccurTime":time.text as String!,
            "symptomDescription":symptom.text as String!,
            "diagnosis":diagnose.text as String!]

        Alamofire.request(.GET, self.url + "/Ajax/medicalrecord_add" ,parameters: params)
            .validate()
            .response { request, response, data, error in
                print(request)
                print(response)
                print(data)
                print(error)
                let jsonData = data as! Dictionary<String,AnyObject>
                let jsonError = jsonData["error"] as! String
                var alert = UIAlertView()
                alert.title = "录入病历"
                if error==nil && jsonError == "0"{
                    //提示界面成功
                    alert.message = "病历-\(self.emrtitle.text) 录入成功!"
                    //清空输入信息
                    self.emrtitle.text = ""
                    self.hospital.text = ""
                    self.doctor.text = ""
                    self.time.text = self.getCurrentTime()
                    self.symptom.text = ""
                    self.diagnose.text = ""
                }
                else{
                    alert.message = "病历-\(self.emrtitle.text) 录入失败!"
                }
                alert.addButtonWithTitle("OK")
                alert.show()
        }
    }
    
    func getCurrentTime()->String{
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss" //(格式可按自己需求修整)
        let strNowTime = timeFormatter.stringFromDate(date) as String
        return strNowTime
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
