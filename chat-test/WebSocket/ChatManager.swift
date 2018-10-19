//
//  ChatManager.swift
//  chat-test
//
//  Created by 木村太一朗 on 2018/10/17.
//  Copyright © 2018年 TANOSYS, LLC. All rights reserved.
//
import UIKit
import Starscream
import SwiftJsonUI

protocol ChatManagerDelegate: class {
    func didConnected()
    func failedToConnect(error: Error)
    func onReceiveMessage(chatMessage: ChatMessage)
    func didSendMessage()
    func failedToSendMessage(error: Error)
}

class ChatManager: WebSocketDelegate {
    private static var Instance = ChatManager()
    public static var instance: ChatManager {
        get {
            return Instance
        }
    }
    
    public var isChatEnabled: Bool = false
    {
        willSet {
            if newValue != isChatEnabled {
                newValue ? connectToSocket() : disconnectFromSocket()
            }
        }
    }
    
    weak var delegate: ChatManagerDelegate?
    
    let uuid = UUID().uuidString
    
    private lazy var handleQueue: DispatchQueue = DispatchQueue(label: "socket_queue")
    
    private var _socket: WebSocket?
    
    private func createSocket() -> WebSocket {
        let socket = WebSocket(url: URL(string: "ws://\((Bundle.main.object(forInfoDictionaryKey: "CurrentIp") as? String) ?? ""):3100/cable/")!)
        socket.delegate = self
        socket.callbackQueue = handleQueue
        return socket
    }
    
    private func connectToSocket() {
        guard (self._socket == nil || !self._socket!.isConnected) else {
            return
        }
        handleQueue.async(execute: {
            print("connect to server")
            self._socket = self.createSocket()
            self._socket?.connect()
        })
    }
    
    private func disconnectFromSocket() {
        guard let socket = self._socket, socket.isConnected else {
            return
        }
        handleQueue.async(execute: {
            socket.disconnect()
            self._socket = nil
        })
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        handleQueue.async(execute: {
            let time = Date()
            let data = ["action": "subscribed", "data": "\(time)"]
            do {
                let jsonAction = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonChannel = try JSONSerialization.data(withJSONObject: ["channel": "RoomChannel"], options: JSONSerialization.WritingOptions.prettyPrinted)
                let commandDict = [
                    "command" : "subscribe",
                    "identifier": String(data: jsonChannel, encoding: String.Encoding.utf8)!,
                    "data": String(data: jsonAction, encoding: String.Encoding.utf8)!
                ]
                let jsonData = try JSONSerialization.data(withJSONObject: commandDict, options: JSONSerialization.WritingOptions.prettyPrinted)
                socket.write(string: String(data: jsonData, encoding: String.Encoding.utf8)!)
                DispatchQueue.main.async(execute: {
                    let notification = NSNotification.Name("socketDidConnected")
                    NotificationCenter.default.post(name: notification, object: nil)
                    self.delegate?.didConnected()
                })
            } catch  let error {
                socket.disconnect()
                DispatchQueue.main.async(execute: {
                    self.delegate?.failedToConnect(error: error)
                })
            }
        })
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        DispatchQueue.main.async(execute: {
            let notification = NSNotification.Name("socketDidDisConnected")
            NotificationCenter.default.post(name: notification, object: nil)
        })
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSON(data: data)
                if !json["message"]["chat_message"].isEmpty {
                    DispatchQueue.main.async(execute: {
                        self.delegate?.onReceiveMessage(chatMessage: ChatMessage(json: json["message"]["chat_message"]))
                    })
                }
            } catch let error {
                print("Parse Error: \(error)")
            }
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
    func sendMessage(message: String) {
        handleQueue.async(execute: {
            guard let socket = self._socket, socket.isConnected else {
                DispatchQueue.main.async(execute: {
                    let error = NSError(domain: "Socket not connected", code: 500, userInfo: nil)
                    self.delegate?.failedToSendMessage(error: error)
                })
                return
            }
            let data = ["action": "chat", "message": message, "uuid": self.uuid]
            do {
                let jsonAction = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonChannel = try JSONSerialization.data(withJSONObject: ["channel": "RoomChannel"], options: JSONSerialization.WritingOptions.prettyPrinted)
                let commandDict = [
                    "command" : "message",
                    "identifier": String(data: jsonChannel, encoding: String.Encoding.utf8)!,
                    "data": String(data: jsonAction, encoding: String.Encoding.utf8)!
                ]
                let jsonData = try JSONSerialization.data(withJSONObject: commandDict, options: JSONSerialization.WritingOptions.prettyPrinted)
                socket.write(string: String(data: jsonData, encoding: String.Encoding.utf8)!)
                DispatchQueue.main.async(execute: {
                    self.delegate?.didSendMessage()
                })
            } catch  let error {
                print("Error: \(error)")
                DispatchQueue.main.async(execute: {
                    self.delegate?.failedToSendMessage(error: error)
                })
            }
        })
    }
}


