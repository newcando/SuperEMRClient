//
//  EMRDetailViewController.swift
//  super_emr
//
//  Created by 王佳华 on 8/20/16.
//  Copyright (c) 2016 王佳华. All rights reserved.
//

import UIKit
import Alamofire

class EMRDetailViewController: UIViewController {

    var user = 0
    var typedes = "null"
    let url = baseurl
    
    @IBOutlet weak var symptomDescription: UILabel!
    @IBOutlet weak var upload_datetime: UILabel!
    @IBOutlet weak var RecordOccurTime: UILabel!
    @IBOutlet weak var imageRecord0: UIImageView!
    @IBOutlet weak var imageRecord1: UIImageView!
    @IBOutlet weak var imageRecord2: UIImageView!
    @IBOutlet weak var recordType: UILabel!
    
    var emrData:Dictionary<String,AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        symptomDescription.text = emrData["symptomDescription"] as? String
        upload_datetime.text = emrData["upload_datetime"] as? String
        RecordOccurTime.text = emrData["RecordOccurTime"] as? String
        let type = emrData["recordType"] as? Int
        
        if(type==1){
            self.typedes="门诊病历"
        }else if(type==2){
            self.typedes="住院病历"
        }else if(type==3){
            self.typedes="体检病历"
        }else{
            self.typedes="null"
        }
        self.recordType.text = self.typedes
        getUserID()
        
    }
    func getUserID(){
        Alamofire.request(.GET, self.url + "/api/selfUsersEx/?format=json", parameters: nil)
            .validate()
            .responseJSON { response in
                print(response)
                let jsonData = response.result.value as! Dictionary<String,AnyObject>
                let results = jsonData["results"] as! [Dictionary<String,AnyObject>]
                self.user = results[0]["user"] as! Int
                print(self.user, terminator: "")
                self.ImageLoad()
        }
    }
    func ImageLoad(){
        let imgurl0=emrData["imageRecord0"] as? String
        if(imgurl0 != nil){
            Alamofire.request(.GET, imgurl0!, parameters: nil)
                .response{ _, _, data, _ in
                    let image = UIImage(data: data! as NSData)
                    self.imageRecord0.image = image
            }
        }
        let imgurl1=emrData["imageRecord1"] as? String
        if(imgurl1 != nil){
            Alamofire.request(.GET, imgurl1!, parameters: nil)
                .response{ _, _, data, _ in
                    let image = UIImage(data: data! as NSData)
                    self.imageRecord1.image = image
            }
        }
        let imgurl2=emrData["imageRecord2"] as? String
        if(imgurl2 != nil){
            Alamofire.request(.GET, imgurl2!, parameters: nil)
                .response{ _, _, data, _ in
                    let image = UIImage(data: data! as NSData)
                    self.imageRecord2.image = image
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
