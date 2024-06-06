//
//  ModelUsers.swift
//  Message_chat
//
//  Created by Minh Vũ on 06/06/2024.
//

import Foundation

struct User {
    var email: String
    var numberPhone: String
    var uid: String
    var image: String
    var birthday: String
    var fullName: String
    var password: String
    var followers: [String]
    var following: [String]
    init(email: String,
         numberPhone: String,
         uid: String,
         image: String,
         birthday: String,
         fullName: String,
         password: String,
         followers: [String],
         following: [String]) {
        self.email = email
        self.numberPhone = numberPhone
        self.uid = uid
        self.image = image
        self.birthday = birthday
        self.fullName = fullName
        self.password = password
        self.followers = followers
        self.following = following
    }
    func toJson() -> [String: Any] {
        return [
            "email": email,
            "numberPhone": numberPhone,
            "uid": uid,
            "image": image,
            "birthday": birthday,
            "fullName": fullName,
            "password": password,
            "followers": followers,
            "following": following
        ]
    }
}
