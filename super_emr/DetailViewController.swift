//
//  DetailViewController.swift
//  super_emr
//
//  Created by 王佳华 on 12/2/15.
//  Copyright (c) 2015 王佳华. All rights reserved.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController {

    var user = 0
    let url = baseurl
   
    @IBOutlet weak var symptomDescription: UILabel!
    @IBOutlet weak var upload_datetime: UILabel!
    @IBOutlet weak var RecordOccurTime: UILabel!
    @IBOutlet weak var imageRecord0: UIImageView!
    
    var emrData:Dictionary<String,AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        symptomDescription.text = emrData["symptomDescription"] as? String
        upload_datetime.text = emrData["upload_datetime"] as? String
        RecordOccurTime.text = emrData["RecordOccurTime"] as? String
        ImageLoad()
        
    }
    func getUserID(){
        Alamofire.request(.GET, self.url + "/api/selfUsersEx/?format=json", parameters: nil)
            .validate()
            .response { request, response, data, error in
                print(request)
                print(response)
                print(data)
                print(error)
                if error == nil {
                    let jsonData = data as! Dictionary<String,AnyObject>
                    let results = jsonData["results"] as! [Dictionary<String,AnyObject>]
                    self.user = results[0]["user"] as! Int
                    print(self.user, terminator: "")
                }
        }
    }
    func ImageLoad(){
        let imgurl=emrData["imageRecord0"] as? String
        Alamofire.request(.GET, imgurl!, parameters: nil)
            .response{ _, _, data, _ in
                let image = UIImage(data: data! as NSData)
                self.imageRecord0.image = image
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
