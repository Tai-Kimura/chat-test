//
//  ViewController.swift
//  chat-test
//
//  Created by 木村太一朗 on 2018/10/17.
//  Copyright © 2018年 TANOSYS, LLC. All rights reserved.
//
import UIKit
import SwiftJsonUI

class ChatViewController: DefaultViewController, UICollectionViewDelegate, UICollectionViewDataSource, ChatManagerDelegate {    
    override var layoutFilePath: String {
        get {
            return "chat"
        }
    }
    private class ViewBinding: Binding {
        weak var rootView: SJUIView!
        weak var collectionView: SJUICollectionView!
        weak var messageArea: SJUIView!
        weak var messageTextView: SJUITextView!
        weak var sendBtn: SJUIButton!
    }
    private lazy var _binding = ViewBinding(viewHolder: self)
    override var binding: Binding {
        get {
            return _binding
        }
    }
    
    private var _demoCell = ChatMeCollectionViewCell(frame: CGRect.zero)
    
    private var _chatMessages = [ChatMessage]()
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ChatManager.instance.delegate = self
        ChatManager.instance.isChatEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ChatManager.instance.isChatEnabled = false
    }

    override func applicationDidBecomeActive() {
        super.applicationDidBecomeActive()
        ChatManager.instance.isChatEnabled = true
    }
    
    override func keyboardWillChangeFrame(_ notification: Foundation.Notification){
        var keyboardFrameEnd: CGRect = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrameEnd = view.convert(keyboardFrameEnd, to: _binding.rootView)
        let animationDuration: TimeInterval = ((notification as NSNotification).userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        _binding.rootView.constraintInfo?.bottomMargin = keyboardFrameEnd.origin.y >= view.frame.size.height ? 0 : keyboardFrameEnd.size.height - safeAreaInsets.bottom
        view.animateWithConstraintInfo(duration: animationDuration)
    }
    
     override func initializeView() {
        super.initializeView()
        _binding.collectionView?.constraintInfo?.topMargin = safeAreaInsets.top
        _binding.messageArea?.constraintInfo?.bottomMargin = safeAreaInsets.bottom
        _binding.rootView.resetConstraintInfo()
        _binding.collectionView.delegate = self
        _binding.collectionView.dataSource = self
        _binding.collectionView.register(ChatMeCollectionViewCell.self, forCellWithReuseIdentifier: ChatMeCollectionViewCell.cellIdentifier)
        _binding.collectionView.register(ChatYouCollectionViewCell.self, forCellWithReuseIdentifier: ChatYouCollectionViewCell.cellIdentifier)
    }
    
    
    //MARK: CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _chatMessages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let chatMessage = _chatMessages[indexPath.row]
        let cellIdentifier = chatMessage.isMe ? ChatMeCollectionViewCell.cellIdentifier : ChatYouCollectionViewCell.cellIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ChatCollectionViewCell
        cell.applyData(chat: chatMessage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let height = _demoCell.estimatedHeight(chat: _chatMessages[indexPath.row])
        return CGSize(width: UIScreen.main.bounds.size.width, height: height)
    }
    
    //MARK: ChatManagerDelegate
    func didConnected() {
        
    }
    func failedToConnect(error: Error) {
        
    }
    func sendMessage() {
        _binding.sendBtn.isEnabled = false
        ChatManager.instance.sendMessage(message: _binding.messageTextView.text)
    }
    func onReceiveMessage(chatMessage: ChatMessage) {
        _chatMessages.append(chatMessage)
        _binding.collectionView.reloadData()
        let lastIndexPath = IndexPath(row: _chatMessages.count - 1, section: 0)
        _binding.collectionView.scrollToItem(at: lastIndexPath, at: .top, animated: true)
    }
    func didSendMessage() {
        _binding.sendBtn.isEnabled = true
        _binding.messageTextView.text = ""
        hideKeyboard()
    }
    func failedToSendMessage(error: Error) {
        _binding.sendBtn.isEnabled = true
        print("Failed to send message")
    }
}


