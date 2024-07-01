//
//  ModelMessages.swift
//  Message_chat
//
//  Created by Minh Vũ on 30/05/2024.
//

import Foundation
import FirebaseFirestoreSwift
//struct Message {
//    let avatarImageName: String
//    let name: String
//    let message: String
//    let time: String
//}
//var message: [Message] = [
//    Message(avatarImageName: "image_avatar", name: "Vũ Minh", message: "Xin chào gọi là Shicalo", time: "11:11"),
//    Message(avatarImageName: "image_avatar", name: "Hoàng", message: "Xin chào gọi là Shicalo", time: "12:11"),
//    Message(avatarImageName: "image_avatar", name: "DeCao", message: "Mặc thì chất đấm thì ngất", time: "13:11"),
//    Message(avatarImageName: "image_avatar", name: "Vũ Minh", message: "Xin chào gọi là Shicalo", time: "11:11"),
//    Message(avatarImageName: "image_avatar", name: "Hoàng", message: "Xin chào gọi là Shicalo", time: "12:11"),
//    Message(avatarImageName: "image_avatar", name: "DeCao", message: "Mặc thì chất đấm thì ngất", time: "13:11"),
//    Message(avatarImageName: "image_avatar", name: "Vũ Minh", message: "Xin chào gọi là Shicalo", time: "11:11"),
//    Message(avatarImageName: "image_avatar", name: "Hoàng", message: "Xin chào gọi là Shicalo", time: "12:11"),
//    Message(avatarImageName: "image_avatar", name: "DeCao", message: "Mặc thì chất đấm thì ngất", time: "13:11"),
//]
struct Messages: Codable {
    let senderID: String
    let messageContent: String
    let imageURL: String?
    let timestamp: Date
    
   
}
