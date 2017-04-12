//
//  uploadEMRViewController.swift
//  super_emr
//
//  Created by 王佳华 on 8/18/16.
//  Copyright (c) 2016 王佳华. All rights reserved.
//

import UIKit
import Alamofire

class uploadEMRViewController: UIViewController ,UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    var user = 0
    let url = baseurl
    
    @IBOutlet weak var personal_description: UITextField!
    
    @IBOutlet weak var img1: UIImageView!
    @IBAction func gallery(sender: UIButton) {
        //判断设置是否支持图片库
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
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //查看info对象
        //print(info)
        //获取选择的原图
        //let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        img1.image = image
        //图片控制器退出
        picker.dismissViewControllerAnimated(true, completion: {
            () -> Void in
        })
    }
    //取消图片控制器代理
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        //图片控制器退出
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
    @IBAction func takePicture(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera)
        {
            //创建图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //设置来源
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            //设置镜头
            if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Front)
            {
                picker.cameraDevice = UIImagePickerControllerCameraDevice.Front
            }
            //设置闪光灯
            picker.cameraFlashMode = UIImagePickerControllerCameraFlashMode.On
            //允许编辑
            picker.allowsEditing = true;
            //打开相机
            self.presentViewController(picker, animated: true, completion: { () -> Void in
            })
            }else{
                let aler = UIAlertView(title: "找不到相机!", message: nil, delegate: nil, cancelButtonTitle: "确定")
                aler.show()}
    }
    func getUserID(){
        Alamofire.request(.GET, self.url + "/api/selfUsersEx/?format=json", parameters: nil)
            .validate()
            .responseJSON {response in
                    let jsonData = response.result.value as! Dictionary<String,AnyObject>
                    let results = jsonData["results"] as! [Dictionary<String,AnyObject>]
                    self.user = results[0]["user"] as! Int
                    print(self.user, terminator: "")
                }
    }
    @IBAction func uploadEMRButton(sender: UIButton) {
        let userNSNumber = self.user as NSNumber
        let userString : String = userNSNumber.stringValue
        let csrftoken = self.getCsrftoken()
        let params = [
            "csrfmiddlewaretoken":csrftoken as String,
            "title": "自我描述",
            "hospital": "null",
            "doctor": "null",
            "symptomDescription": personal_description.text,
            "diagnosis": "null",
            "recordType": "4",
            "user": userString
        ]
        let headers = [ "Accept":"application/json" ,
            "Content-Type": "application/json" ,
            "X-CSRFToken" : csrftoken]
        Alamofire.upload(.POST, self.url + "/api/myMedicalRecords/", headers: headers, multipartFormData: {
            multipartFormData in
            if let _image = self.img1.image {
                if let imageData = UIImageJPEGRepresentation(_image, 0.5) {
                    multipartFormData.appendBodyPart(data: imageData, name: "imageRecord0", fileName: "file.png", mimeType: "image/png")
                }
            }
            
            for (key, value) in params {
                if value is String! {
                    multipartFormData.appendBodyPart(data: value!.dataUsingEncoding(NSUTF8StringEncoding)!, name: key as! String)
                }
//                else if value is Int {
//                    let convertedValueNumber: NSNumber = NSNumber(int: value.intValue)
//                    let data = NSKeyedArchiver.archivedDataWithRootObject(convertedValueNumber)
//                    multipartFormData.appendBodyPart(data: data, name: key as! String)
//                }
            }
//            for (key, value) in paramsInt {
//                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8IntEncoding)!, name: key)
//            }
            
            }) { (encodingResult) in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON(completionHandler: { response in
                        debugPrint(response.response!.statusCode, terminator: "")
                        if(response.response!.statusCode==201 ){//&& error==nil){
                            let alertController = UIAlertController(title: "自我描述", message:"上传成功", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                            self.presentViewController(alertController, animated: true, completion: nil)
                            self.personal_description.text=""
                            self.img1.image=nil
                        }else{
                            let alertController = UIAlertController(title: "自我描述", message:"上传出错", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                        
                    })
                case .Failure(let error):
                    print(error, terminator: "")
                }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getUserID()
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
