//
//  ChatCollectionViewCell.swift
//  chat-test
//
//  Created by 木村太一朗 on 2018/10/17.
//  Copyright © 2018年 TANOSYS, LLC. All rights reserved.
//

import UIKit
import SwiftJsonUI

class ChatCollectionViewCell: UICollectionViewCell, ViewHolder {
    
    var _views: [String : UIView] = [String : UIView]()
    
    private class ChatBinding: Binding {
        weak var nameLabel: SJUILabel!
        weak var messageLabel: SJUILabel!
    }
    
    private lazy var _binding = ChatBinding(viewHolder: self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
        _binding.bindView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadView() {

    }
    func applyData(chat: ChatMessage) {
        _binding.data = chat
    }
    
    func estimatedHeight(chat: ChatMessage) -> CGFloat {
        let width: CGFloat = 210.0
        let paragraphStyle = _binding.messageLabel.attributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle
        return NSAttributedString(string: chat.message, attributes: _binding.messageLabel.attributes).heightForAttributedString(width, lineHeightMultiple: paragraphStyle?.lineHeightMultiple ?? 1.0) + 50.0
    }
}
