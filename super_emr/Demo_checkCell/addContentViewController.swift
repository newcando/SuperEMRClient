//
//  addContentViewController.swift
//  super_emr
//
//  Created by 王佳华 on 1/22/17.
//  Copyright © 2017 王佳华. All rights reserved.
//

import UIKit
import Alamofire

class addContentViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    var index=0
    var user = 0
    let url = baseurl
    
    @IBOutlet weak var scContent: UITextField!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getUserID()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitScContent(sender: UIButton) {
        let userNSNumber = self.user as NSNumber
        let userString : String = userNSNumber.stringValue
        //print(recordType.selectedSegmentIndex)
        let csrftoken=self.getCsrftoken()
        let params = [
            "csrfmiddlewaretoken":csrftoken as String,
            "text": self.scContent.text,
            "uid": userString
        ]
        let headers = [ "Accept":"application/json" ,
                        "Content-Type": "application/json" ,
                        "X-CSRFToken" : csrftoken]
        Alamofire.upload(.POST, self.url + "/api/scContent/", headers: headers, multipartFormData: {
            multipartFormData in
            for (index,_image) in [("img1", self.img1.image),("img2", self.img2.image),("img3", self.img3.image)] {
                if let imageData = UIImageJPEGRepresentation(_image!, 0.5) {
                    multipartFormData.appendBodyPart(data: imageData, name: index, fileName: "file.png", mimeType: "image/png")
                }
            }
            for (key, value) in params {
                if value is String! {
                    multipartFormData.appendBodyPart(data: value!.dataUsingEncoding(NSUTF8StringEncoding)!, name: key as! String)
                }
            }
            
        }) { (encodingResult) in
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response, terminator: "")
                    print(response.response?.statusCode)
                    if(response.response?.statusCode==201 ){//&& error==nil){
                        let alertController = UIAlertController(title: "我的动态", message:"上传成功", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                        self.img1.image=nil
                        self.img2.image=nil
                        self.img3.image=nil
                        self.scContent.text = ""
                    }else{
                        let alertController = UIAlertController(title: "我的动态", message:"上传出错", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                    
                }
            case .Failure(let error):
                print(error, terminator: "")
            }
        }
    }
    
    @IBAction func select1(sender: UIButton) {
        self.setPhoto(1)
    }
    @IBAction func select2(sender: UIButton) {
        self.setPhoto(2)
    }
    @IBAction func select3(sender: UIButton) {
        self.setPhoto(3)
    }
    
    func setPhoto(index:Int){
        self.index=index
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            //设置是否允许编辑
            picker.allowsEditing = false
            
            //picker.sourceType = .PhotoLibrary
            //弹出控制器，显示界面
            self.presentViewController(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            print("读取相册错误", terminator: "")
            let alert = UIAlertView()
            alert.title = "病历拍照"
            alert.message = "读取相册失败"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //查看info对象
        //print(info)
        //获取选择的原图
        //let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        if(self.index==1){
            img1.image = image
        }else if(self.index==2){
            img2.image = image
        }else if(self.index==3){
            img3.image = image
        }else{
            print("图片选择出错", terminator: "")
        }
        
        //图片控制器退出
        picker.dismissViewControllerAnimated(true, completion: {
            () -> Void in
        })
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
    func getUserID(){
        Alamofire.request(.GET, self.url + "/api/selfUsersEx/?format=json", parameters: nil)
            .validate()
            .responseJSON { response in
                print(response)
                let jsonData = response.result.value as! Dictionary<String,AnyObject>
                let results = jsonData["results"] as! [Dictionary<String,AnyObject>]
                self.user = results[0]["user"] as! Int
                print(self.user, terminator: "")
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
