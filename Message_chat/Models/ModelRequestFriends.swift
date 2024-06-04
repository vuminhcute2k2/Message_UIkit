//
//  ModelRequestFriends.swift
//  Message_chat
//
//  Created by Minh Vũ on 01/06/2024.
//

import Foundation
struct FriendRequest {
    enum RequestType {
        case accept
        case cancel
    }
    let avatarImageName: String
    let name: String
    let type: RequestType
}
var friendRequests: [FriendRequest] = [
    FriendRequest(avatarImageName: "image_avatar", name: "Vũ Minh", type: .accept),
    FriendRequest(avatarImageName: "image_avatar", name: "Hoàng", type: .accept),
    FriendRequest(avatarImageName: "image_avatar", name: "DeCao", type: .accept),
    FriendRequest(avatarImageName: "image_avatar", name: "Vũ Minh", type: .cancel),
    FriendRequest(avatarImageName: "image_avatar", name: "Hoàng", type: .cancel),
    FriendRequest(avatarImageName: "image_avatar", name: "DeCao", type: .cancel)
]
