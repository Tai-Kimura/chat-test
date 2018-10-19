//
//  ChatMeCollectionViewCell.swift
//  chat-test
//
//  Created by 木村太一朗 on 2018/10/17.
//  Copyright © 2018年 TANOSYS, LLC. All rights reserved.
//

import UIKit
import SwiftJsonUI

class ChatMeCollectionViewCell: ChatCollectionViewCell {
    static let cellIdentifier = "ChatMe"
    override func loadView() {
        SJUIViewCreator.createView("chat_me_cell", target: self, onView: self.contentView)
    }
}
