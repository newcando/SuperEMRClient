		//
//  ViewController.swift
//  Demo_checkCell
//
//  Created by 李春波 on 16/8/9.
//  Copyright © 2016年 lcb. All rights reserved.
//

import UIKit
import Alamofire
        
class chatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate {
    
    let url = baseurl
    var ContentData:NSArray=[]
    
    var goodComm=[Dictionary<String, AnyObject>]()
    
    var user = 0
    var avator = ""
    var username = ""
    
    var currentPK = 0
    
    var iscomment = 1
    
    var tableView:UITableView?
    var refreshControl = UIRefreshControl()
    let imagePicView = UIView()
    let imagePic = UIImageView()
    let nameLable = UILabel()
    let avatorImage = UIImageView()
    var biaozhi = true
    var selectItems: [Bool] = []
    var likeItems:[Bool] = []
    var replyViewDraw:CGFloat!
    var test = UITextField()
    var commentView = pingLunFun()
    
    func getUserID(){
        Alamofire.request(.GET, self.url + "/api/selfUsersEx/?format=json", parameters: nil)
            .validate()
            .responseJSON {response in
                let jsonData = response.result.value as! Dictionary<String,AnyObject>
                let results = jsonData["results"] as! [Dictionary<String,AnyObject>]
                self.user = results[0]["user"] as! Int
                
                self.avator = results[0]["user_image"] as! String
                self.username = results[0]["nickname"] as! String
                print(self.user, terminator: "")
                self.contentValue()
        }
    }
    
    func contentValue(){
        let tableUrl = self.url + "/api/scContent/"//
        
        let userNSNumber = self.user as NSNumber
        let userString : String = userNSNumber.stringValue
        let params = [
            "uid": userString
        ]
        
        Alamofire.request(.GET, tableUrl, parameters: params)
            .validate()
            .responseJSON {response in
                let jsonData = response.result.value as! Dictionary<String,AnyObject>
                self.ContentData = jsonData["results"] as! NSArray
                //                    println(self.EMRData)
                //                    println(self.EMRData.count)
                for i in 0..<self.ContentData.count{
                    self.selectItems.append(false)
                    self.likeItems.append(false)
                    
                    let comm = self.ContentData[i]["scComment_set"] as! NSArray
                    var str=[String]()
                    var com = [
                        "good":str,
                        "commentName":str,
                        "comment":str
                    ]
                    for j in 0..<comm.count{
                        var name = comm[j]["uid_name"] as! String
                        var ctext = comm[j]["ctext"] as! String
                        com["commentName"]!.append(name)
                        com["comment"]!.append(ctext)
                    }
                    self.goodComm.append(com)
                }
                self.test.delegate = self
                self.commentView.commentTextField.delegate = self
                self.refreshControl.addTarget(self, action: #selector(chatViewController.refreshData),
                    forControlEvents: UIControlEvents.ValueChanged)
                self.refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
                self.tableView = UITableView(frame: self.view.frame, style:UITableViewStyle.Grouped)
                self.tableView!.delegate = self
                self.tableView!.dataSource = self
                self.tableView?.tableHeaderView = self.headerView()
                self.tableView?.contentInset = UIEdgeInsets(top: 50,left: 0,bottom: 0,right: 0)
                self.view.addSubview(self.tableView!)/////////
                self.tableView?.addSubview(self.refreshControl)
                self.tableView!.allowsMultipleSelection = true
                self.view.backgroundColor = UIColor.whiteColor()/////////
                self.commentView.frame = CGRectMake(0,0,self.view.bounds.width,30)
                self.commentView.hidden = true
                self.view.addSubview(self.commentView)////////
                self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chatViewController.handleTap(_:))))
                NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(chatViewController.keyBoardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
                NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(chatViewController.keyBoardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
                self.tableView!.reloadData()//重载数据
                //self.refreshControl.endRefreshing()
        }
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: UIBarButtonItemStyle.Plain, target: self, action: "addscContent")
        
        self.getUserID()
    }
    
    func addscContent() {
        self.iscomment=0
        var sb = UIStoryboard(name: "user", bundle:nil)
        var vc = sb.instantiateViewControllerWithIdentifier("addscContent") as! addContentViewController
        //VC为该界面storyboardID，Main.storyboard中选中该界面View，Identifier inspector中修改
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func refreshData() {
        print("123")
        biaozhi = true
        refreshControl.endRefreshing()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(ContentData.count)
        return ContentData.count
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView?.separatorInset = UIEdgeInsetsZero
        self.tableView?.layoutMargins = UIEdgeInsetsZero
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell
    {
        let identify:String =  self.username //"test \(indexPath.row)"
        //禁止重用机制
        var cell:defalutTableViewCell? = tableView.cellForRowAtIndexPath(indexPath) as? defalutTableViewCell
        if cell == nil{
            cell = defalutTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identify)
        }
        var imgData:[String]=[]
        let imgurl0=self.ContentData[indexPath.row]["img1"] as? String
        if(imgurl0 != nil){
            imgData.append(imgurl0!)
        }
        let imgurl1=self.ContentData[indexPath.row]["img2"] as? String
        if(imgurl1 != nil){
            imgData.append(imgurl1!)
        }
        let imgurl2=self.ContentData[indexPath.row]["img3"] as? String
        if(imgurl2 != nil){
            imgData.append(imgurl2!)
        }
        cell!.pk = self.ContentData[indexPath.row]["pk"] as! Int
        let comments = self.ContentData[indexPath.row]["scComment_set"]! as! NSArray
        cell!.setData(self.ContentData[indexPath.row]["uid_name"]! as! String,
                      imagePic: self.url + (self.ContentData[indexPath.row]["uid_avator"]! as! String),
                      content: self.ContentData[indexPath.row]["text"]! as! String,
                      imgData: imgData,
                      indexRow:indexPath,
                      selectItem: selectItems[indexPath.row],
                      
                      like:self.goodComm[indexPath.row]["good"]! as! [String],
                      likeItem:likeItems[indexPath.row],
                      CommentNameArray:self.goodComm[indexPath.row]["commentName"]! as! [String] ,
                      CommentArray:self.goodComm[indexPath.row]["comment"]! as! [String],
                      comments:comments)
        
        
        cell!.displayView.tapedImageV = {[unowned self] index in
            cell!.pbVC.show(inVC: self,index: index)
        }
        cell!.selectionStyle = .None
        
        cell!.heightZhi = { cellflag in
            self.selectItems[indexPath.row] = cellflag
            self.tableView?.reloadData()
        }
        cell!.likechange = { cellflag in
            self.likeItems[indexPath.row] = cellflag
            self.tableView?.reloadData()
        }
        cell!.commentchange = { _ in
            self.iscomment=1
            self.currentPK = cell!.pk
            self.replyViewDraw = cell!.convertRect(cell!.bounds,toView:self.view.window).origin.y + cell!.frame.size.height
            self.commentView.commentTextField.becomeFirstResponder()
            self.commentView.sendBtn.addTarget(self, action: #selector(chatViewController.sendComment(_:)), forControlEvents:.TouchUpInside)
            self.commentView.sendBtn.tag = indexPath.row
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        var h_content = cellHeightByData(self.ContentData[indexPath.row]["text"]! as! String)
        let h_image = cellHeightByData1(3)//(dataItem[indexPath.row]["imageUrls"]!.count)
        var h_like:CGFloat = 0.0
        let h_comment = cellHeightByCommentNum(self.goodComm[indexPath.row]["commentName"]!.count)
        if h_content>13*5{
            if !self.selectItems[indexPath.row]{
                h_content = 13*5
            }
        }
        if self.goodComm[indexPath.row]["good"]!.count > 0{
            h_like = 40
        }
        return h_content + h_image + 50 + 20 + h_like + h_comment
    }

    func headerView() ->UIView{
        
        imagePicView.frame = CGRectMake(0, 0, self.view.bounds.width, 225)
        imagePic.frame = CGRectMake(0, 0, self.view.bounds.width, 200)
        imagePic.image = UIImage(named: "background")
        imagePicView.addSubview(imagePic)
        imagePic.clipsToBounds = true
        self.nameLable.frame = CGRectMake(0, 170, 60, 18)
        self.nameLable.frame.origin.x = self.view.bounds.width - 140
        self.nameLable.text = self.username//"test"//用户名称
        self.nameLable.font = UIFont.systemFontOfSize(16)
        self.nameLable.textColor = UIColor.whiteColor()
        self.avatorImage.frame = CGRectMake(0, 150, 70, 70)
        self.avatorImage.frame.origin.x = self.view.bounds.width - 80
        
        let url = NSURL(string:self.avator)
        let data = NSData(contentsOfURL:url!)
        self.avatorImage.image = UIImage(data:data!)//UIImage(named: "avatorImage")//用户头像
        self.avatorImage.layer.borderWidth = 2
        self.avatorImage.layer.borderColor = UIColor.whiteColor().CGColor
        let view:UIView = UIView(frame: CGRectMake(0, 200, self.view.bounds.width, 26))
        view.backgroundColor = UIColor.whiteColor()
        imagePicView.addSubview(nameLable)
        imagePicView.addSubview(view)
        imagePicView.addSubview(avatorImage)
        return imagePicView
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        let offset:CGPoint = scrollView.contentOffset
        
        if (offset.y < 0) {
            var rect:CGRect = imagePic.frame
            rect.origin.y = offset.y
            rect.size.height = 200 - offset.y
            imagePic.frame = rect
        }
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            self.commentView.commentTextField.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    func keyBoardWillShow(note:NSNotification)
    {
        if(self.iscomment==1){
        let userInfo  = note.userInfo as! NSDictionary
        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let deltaY = keyBoardBounds.size.height
        let commentY = self.view.frame.height - deltaY
        var frame = self.commentView.frame
        let animations:(() -> Void) = {
            self.commentView.hidden = false
            self.commentView.frame.origin.y = commentY - 30
            frame.origin.y = commentY
            var point:CGPoint = self.tableView!.contentOffset
            point.y -= (frame.origin.y - self.replyViewDraw)
            self.tableView!.contentOffset = point
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
        }
    }
    
    func keyBoardWillHide(note:NSNotification)
    {
        if(self.iscomment==1){
        let userInfo  = note.userInfo as! NSDictionary
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations:(() -> Void) = {
            self.commentView.hidden = true
            self.commentView.transform = CGAffineTransformIdentity
            self.tableView!.frame.origin.y = 0
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
            
        }else{
            animations()
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
    func sendComment(sender:UIButton){
        let userNSNumber = self.user as NSNumber
        let userString : String = userNSNumber.stringValue
        
        let pkNSNumber = self.currentPK as NSNumber
        let pkString : String = pkNSNumber.stringValue
        //print(recordType.selectedSegmentIndex)
        let csrftoken=self.getCsrftoken()
        let params = [
            "csrfmiddlewaretoken":csrftoken as String,
            "ctext": self.commentView.commentTextField.text,
            "uid": userString,
            "wid":pkString
        ]
        let headers = [ "Accept":"application/json" ,
                        "Content-Type": "application/json" ,
                        "X-CSRFToken" : csrftoken]
        Alamofire.upload(.POST, self.url + "/api/scComment/", headers: headers, multipartFormData: {
            multipartFormData in
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
                        let alertController = UIAlertController(title: "我的评论", message:"上传成功", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }else{
                        let alertController = UIAlertController(title: "我的评论", message:"上传出错", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                    
                }
            case .Failure(let error):
                print(error, terminator: "")
            }
        }
        self.commentView.commentTextField.resignFirstResponder()
        self.tableView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}