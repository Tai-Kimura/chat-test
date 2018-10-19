//
//  ChatMessage.swift
//  chat-test
//
//  Created by 木村太一朗 on 2018/10/17.
//  Copyright © 2018年 TANOSYS, LLC. All rights reserved.
//

import UIKit
import SwiftJsonUI

class ChatMessage: SJUIModel {
    var message: String {
        get {
            return _json["message"].stringValue
        }
    }
    
    var isMe: Bool {
        get {
            return _json["uuid"].stringValue == ChatManager.instance.uuid
        }
    }
}
