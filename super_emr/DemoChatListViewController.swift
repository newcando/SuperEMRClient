//
//  DemoChatListViewController.swift
//  demo-app-ios-v2-quick-start-swift
//
//  Created by 岑裕 on 15/11/25.
//  Copyright © 2015年 岑裕. All rights reserved.
//

import Foundation

class DemoChatListViewController: RCConversationListViewController {
    override func viewDidLoad() {
        //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
        super.viewDidLoad()
        
        //设置需要显示哪些类型的会话
        self.setDisplayConversationTypes([RCConversationType.ConversationType_PRIVATE.rawValue,
            RCConversationType.ConversationType_DISCUSSION.rawValue,
            RCConversationType.ConversationType_CHATROOM.rawValue,
            RCConversationType.ConversationType_GROUP.rawValue,
            RCConversationType.ConversationType_APPSERVICE.rawValue,
            RCConversationType.ConversationType_SYSTEM.rawValue])
        //设置需要将哪些类型的会话在会话列表中聚合显示
        self.setCollectionConversationType([RCConversationType.ConversationType_DISCUSSION.rawValue,
            RCConversationType.ConversationType_GROUP.rawValue])
        
        self.navigationItem.title = "咨询列表"
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "单聊", style: UIBarButtonItemStyle.Plain, target: self, action: "privateChat")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "退出", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
        
//        self.privateChat()
    }
    
    func privateChat() {
        //打开会话界面
        let chatWithSelf = RCConversationViewController(conversationType: RCConversationType.ConversationType_PRIVATE, targetId: "test")
        chatWithSelf.title = "测试"
        chatWithSelf.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chatWithSelf, animated: true)
    }
    
    func logout() {
        //断开连接并设置不再接收推送消息
        RCIM.sharedRCIM().disconnect(false)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //重写RCConversationListViewController的onSelectedTableRow事件
    override func onSelectedTableRow(conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, atIndexPath indexPath: NSIndexPath!) {
        //打开会话界面
        let chat = questionDetailCollectionViewController(conversationType: model.conversationType, targetId: model.targetId)
        chat.title = model.targetId//"病人咨询"
        chat.hidesBottomBarWhenPushed = true
//        chat.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "单聊", style: UIBarButtonItemStyle.Plain, target: chat, action: "privateChat")
        self.navigationController?.pushViewController(chat, animated: true)
    }
}