//
//  doctorworkschedule.swift
//  super_emr
//
//  Created by 王佳华 on 12/4/16.
//  Copyright © 2016 王佳华. All rights reserved.
//
import UIKit
import Alamofire

class doctorworkschedule: UIViewController {

    var name = ""
    var workdayint = 0
    let url = baseurl
    @IBOutlet weak var doctorname: UITextField!
    @IBOutlet weak var workday: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.doctorname.text = self.name
        self.workday.selectedSegmentIndex = self.workdayint //默认选中第二项
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func workdaychange(sender: UISegmentedControl) {
        //获得选项的索引
        print(sender.selectedSegmentIndex)
        let params = ["csrfmiddlewaretoken":self.getCsrftoken(),
                      "username": self.name as String,
                      "workday": sender.selectedSegmentIndex as Int
        ]
        Alamofire.request(.POST, self.url+"/Ajax/setworkday/", parameters: params as! [String : AnyObject])
            .validate()
            .response { request, response, data, error in
                print(request)
                print(response)
                print(data)
                print(error)
        }
        
    }
    @IBAction func goback(sender: UIBarButtonItem) {
        
        self.presentingViewController!.dismissViewControllerAnimated(false, completion:nil)
        
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
}
