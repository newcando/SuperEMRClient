//
//  MeViewController.swift
//  super_emr
//
//  Created by 王佳华 on 10/9/16.
//  Copyright © 2016 王佳华. All rights reserved.
//

import UIKit
import Alamofire

class MeViewController: UIViewController {

    let url = baseurl
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(sender: UIButton) {
        Alamofire.request(.GET, self.url + "/logout" ,parameters: nil)
            .validate()
            .response { request, response, data, error in
//                let login = LoginViewController()
                let login = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as! LoginViewController
                let window = UIApplication.sharedApplication().delegate?.window
                let nav = UINavigationController(rootViewController: login)
                window!!.rootViewController = nav
//                self.navigationController?.popToRootViewControllerAnimated(true)
        }
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
