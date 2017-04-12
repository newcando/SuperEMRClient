//
//  publicPeopleMrgTableViewCell.swift
//  super_emr
//
//  Created by 王佳华 on 10/23/16.
//  Copyright © 2016 王佳华. All rights reserved.
//

import UIKit
import Alamofire

class publicPeopleMrgTableViewCell: UITableViewCell {

    var member = [:]
    let url = baseurl
    var publicUser = ""
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var workday: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteUser(sender: UIButton) {
        //
        let params = ["csrfmiddlewaretoken":self.getCsrftoken(),
                      "publicName": publicUser as String!,
                      "doctorName":member["nickname"] as! String!,
                      "optation": "delete"
                     ]
        Alamofire.request(.POST, self.url+"/Ajax/operate_relative_user/", parameters: params)
            .validate()
            .response { request, response, data, error in
                print(request)
                print(response)
                print(data)
                print(error)
                //Convert NSData to NSString
                let resultNSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                //Convert NSString to String
                let resultString = resultNSString as String
                print(resultString)
                    
//                let alertController = UIAlertController(title: "公众号管理", message:resultString, preferredStyle: UIAlertControllerStyle.Alert)
//                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
//                self.presentViewController(alertController, animated: true, completion: nil)
        }
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
