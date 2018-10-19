//
//  ChatYouCollectionViewCell.swift
//  chat-test
//
//  Created by 木村太一朗 on 2018/10/17.
//  Copyright © 2018年 TANOSYS, LLC. All rights reserved.
//

import UIKit
import SwiftJsonUI

class ChatYouCollectionViewCell: ChatCollectionViewCell {
    static let cellIdentifier = "ChatYou"
    override func loadView() {
        SJUIViewCreator.createView("chat_you_cell", target: self, onView: self.contentView)
    }
}
