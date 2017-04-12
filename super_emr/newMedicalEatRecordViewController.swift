//
//  newMedicalEatRecordViewController.swift
//  super_emr
//
//  Created by 王佳华 on 8/21/16.
//  Copyright (c) 2016 王佳华. All rights reserved.
//

import UIKit
import Alamofire

class newMedicalEatRecordViewController: UIViewController {

    var user = 0
    let url = baseurl

    @IBOutlet weak var medicine: UITextField!
    @IBOutlet weak var method:UITextField!
    @IBOutlet weak var how_use:UITextField!
    @IBOutlet weak var eatTime:UITextField!
    @IBOutlet weak var resultDescription:UITextField!
    @IBOutlet weak var datapicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getUserID()
    }

    func getUserID(){
        Alamofire.request(.GET, self.url + "/api/selfUsersEx/?format=json", parameters: nil)
            .responseJSON{ response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                let data=response.result.value
                let error=response.result.error
                if error == nil {
                    let jsonData = data as! Dictionary<String,AnyObject>
                    let results = jsonData["results"] as! [Dictionary<String,AnyObject>]
                    self.user = results[0]["user"] as! Int
                    print(self.user, terminator: "")
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getCsrftoken()->String{
        let cookies:[NSHTTPCookie] = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookiesForURL(NSURL(string:self.url)!) as [NSHTTPCookie]!
        var csrftoken:String?
        for cookie in cookies{
            if cookie.name == "csrftoken"{
                csrftoken = cookie.value
            }
        }
        return csrftoken!
    }
    
    @IBAction func submit(sender: UIButton) {
        let userNSNumber = self.user as NSNumber
        let userString : String = userNSNumber.stringValue
        
        let params = ["csrfmiddlewaretoken":self.getCsrftoken() as! String,
            "medicine": self.medicine.text as String!,
            "method":self.method.text as String!,
            "how_use":self.how_use.text as String!,
            "eatTime":self.eatTime.text as String!,
            "resultDescription":self.resultDescription.text as String!,
            "user":userString as String
        ]
        Alamofire.request(.POST, self.url+"/api/myMedicineEatRecord/", parameters: params)
            .validate()
            .response { request, response, data, error in
                print(request)
                print(response)
                print(data)
                print(error)
                if(response!.statusCode==201 && error==nil){
                    let alertController = UIAlertController(title: "服药记录", message:"上传成功", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    self.medicine.text=""
                    self.method.text=""
                    self.how_use.text=""
                    self.eatTime.text=""
                    self.resultDescription.text=""
                }else{
                    let alertController = UIAlertController(title: "服药记录", message:"上传出错", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }

                
        }

    }
    

    @IBAction func addEatTime(sender: UIButton) {
        //更新提醒时间文本框
        let formatter = NSDateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print(formatter.stringFromDate(datapicker.date), terminator: "")
        self.eatTime.text=formatter.stringFromDate(datapicker.date)
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
