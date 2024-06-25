//
//  FirebaseService.swift
//  Message_chat
//
//  Created by Minh Vũ on 06/06/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit
class FirebaseService {
    static let shared = FirebaseService()
    let usersCollection = Firestore.firestore().collection("users")
    let friendRequestsCollection = Firestore.firestore().collection("requestFriends")
    let userFriendsCollection = Firestore.firestore().collection("userFriends")
    let db = Firestore.firestore()
    private init() {}
    //register
    func registerUser(email: String,
                      password: String,
                      name: String,
                      completion: @escaping (Result<User, Error>)
                      -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {
            authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let user = authResult?.user else {
                let error = NSError(domain: "", code: -1,
                                    userInfo: [NSLocalizedDescriptionKey
                                               : "User creation failed"])
                completion(.failure(error))
                return
            }
            let newUser = User(email: email,
                               numberPhone: "",
                               uid: user.uid,
                               image: "",
                               birthday: "",
                               fullName: name,
                               password: password,
                               followers: [],
                               following: [])
            self.saveUserInfo(user: newUser) { result in
                completion(result)
            }
        }
    }
    //save register firebase collections users
    private func saveUserInfo(user: User,
                              completion: @escaping (Result<User, Error>)
                              -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).setData(user.toJson()) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(user))
            }
        }
    }
    func login(email: String,
               password: String,
               completion: @escaping (Result<Message_chat.User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let userAuth = authResult?.user else {
                completion(.failure(
                    NSError(domain: "AuthService",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                return
            }
            let user = User(email: email,
                            numberPhone: "",
                            uid: userAuth.uid,
                            image: "",
                            birthday: "",
                            fullName: "",
                            password: password,
                            followers: [],
                            following: [])
            completion(.success(user))
        }
    }
    //Auto SignIn
    func autoSignIn(completion: @escaping (Result<User, Error>) -> Void) {
        if let userAuth = Auth.auth().currentUser {
            let user = User(email: userAuth.email ?? "",
                            numberPhone: "",
                            uid: userAuth.uid,
                            image: "",
                            birthday: "",
                            fullName: "",
                            password: "",
                            followers: [],
                            following: [])
            completion(.success(user))
        } else {
            completion(.failure(NSError(domain: "AuthService",
                                        code: 401,
                                        userInfo: [NSLocalizedDescriptionKey: "User is not logged in"])))
        }
    }
    // All friends
    func fetchAllUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let snapshot = snapshot else {
                let error = NSError(domain: "", code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "No data found"])
                completion(.failure(error))
                return
            }
            let users = snapshot.documents.compactMap { document -> User? in
                let data = document.data()
                return User(email: data["email"] as? String ?? "",
                            numberPhone: data["numberPhone"] as? String ?? "",
                            uid: data["uid"] as? String ?? "",
                            image: data["image"] as? String ?? "",
                            birthday: data["birthday"] as? String ?? "",
                            fullName: data["fullName"] as? String ?? "",
                            password: data["password"] as? String ?? "",
                            followers: data["followers"] as? [String] ?? [],
                            following: data["following"] as? [String] ?? [])
            }
            completion(.success(users))
        }
    }
    //display add friends
    func fetchFriendRequests(for currentUserID: String,
                             completion: @escaping (Result<[User], Error>) -> Void) {
        friendRequestsCollection.whereField("to", isEqualTo: currentUserID).getDocuments {
            (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let snapshot = snapshot else {
                let error = NSError(domain: "",
                                    code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "No data found"])
                completion(.failure(error))
                return
            }
            let userDispatchGroup = DispatchGroup()
            var users: [User] = []
            for document in snapshot.documents {
                if let fromUserID = document.data()["from"] as? String {
                    userDispatchGroup.enter()
                    self.usersCollection.document(fromUserID).getDocument {
                        (userDoc, error) in
                        defer { userDispatchGroup.leave() }
                        if let userDoc = userDoc, userDoc.exists,
                           let userData = userDoc.data() {
                            let user = User(
                                email: userData["email"] as? String ?? "",
                                numberPhone: userData["numberPhone"] as? String ?? "",
                                uid: fromUserID,
                                image: userData["image"] as? String ?? "",
                                birthday: userData["birthday"] as? String ?? "",
                                fullName: userData["fullName"] as? String ?? "",
                                password: "",
                                followers: userData["followers"] as? [String] ?? [],
                                following: userData["following"] as? [String] ?? []
                            )
                            users.append(user)
                        }
                    }
                }
            }
            userDispatchGroup.notify(queue: .main) {
                completion(.success(users))
            }
        }
    }
    //display cancel request friends
    func fetchSentFriendRequests(for currentUserID: String,
                                 completion: @escaping (Result<[User], Error>) -> Void) {
        friendRequestsCollection.whereField("from", isEqualTo: currentUserID).getDocuments {
            (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let snapshot = snapshot else {
                let error = NSError(domain: "",
                                    code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "No data found"])
                completion(.failure(error))
                return
            }
            let userDispatchGroup = DispatchGroup()
            var users: [User] = []
            for document in snapshot.documents {
                if let toUserID = document.data()["to"] as? String {
                    userDispatchGroup.enter()
                    self.usersCollection.document(toUserID).getDocument {
                        (userDoc, error) in
                        defer { userDispatchGroup.leave() }
                        if let userDoc = userDoc, userDoc.exists,
                           let userData = userDoc.data() {
                            let user = User(
                                email: userData["email"] as? String ?? "",
                                numberPhone: userData["numberPhone"] as? String ?? "",
                                uid: toUserID,
                                image: userData["image"] as? String ?? "",
                                birthday: userData["birthday"] as? String ?? "",
                                fullName: userData["fullName"] as? String ?? "",
                                password: "",
                                followers: userData["followers"] as? [String] ?? [],
                                following: userData["following"] as? [String] ?? []
                            )
                            users.append(user)
                        }
                    }
                }
            }
            userDispatchGroup.notify(queue: .main) {
                completion(.success(users))
            }
        }
    }
    // cancel request friends
    func cancelFriendRequest(from currentUserID: String,
                             to user: User,
                             completion: @escaping (Result<Void, Error>) -> Void) {
        Firestore.firestore().collection("requestFriends")
            .whereField("from", isEqualTo: currentUserID)
            .whereField("to", isEqualTo: user.uid)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    completion(.failure(NSError(domain: "",
                                                code: 404,
                                                userInfo: [NSLocalizedDescriptionKey: "No friend request found"])))
                    return
                }
                for document in documents {
                    document.reference.delete { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(()))
                        }
                    }
                }
            }
    }
    //track changes send request
    func observeSentFriendRequests(for userID: String,
                                   completion: @escaping ([User]) -> Void)
    -> ListenerRegistration {
        return db.collection("requestFriends")
            .whereField("from", isEqualTo: userID)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error fetching sent friend requests: \(error)")
                    completion([])
                    return
                }

                guard let snapshot = snapshot else {
                    print("No data found for sent friend requests")
                    completion([])
                    return
                }
                var updatedCancelRequests: [User] = []
                for document in snapshot.documents {
                    if let toUserID = document.data()["to"] as? String {
                        self.db.collection("users").document(toUserID).getDocument {
                            (userDoc, userError) in
                            if let userError = userError {
                                print("Error fetching user data: \(userError)")
                                return
                            }
                            guard let userDoc = userDoc,
                                  userDoc.exists,
                                  let userData = userDoc.data() else {
                                print("User document does not exist for \(toUserID)")
                                return
                            }
                            let user = User(
                                email: userData["email"] as? String ?? "",
                                numberPhone: userData["numberPhone"] as? String ?? "",
                                uid: toUserID,
                                image: userData["image"] as? String ?? "",
                                birthday: userData["birthday"] as? String ?? "",
                                fullName: userData["fullName"] as? String ?? "",
                                password: "",
                                followers: userData["followers"] as? [String] ?? [],
                                following: userData["following"] as? [String] ?? []
                            )
                            updatedCancelRequests.append(user)
                            completion(updatedCancelRequests)
                        }
                    }
                }
            }
    }
    //track changes received request
    func observeReceivedFriendRequests(for userID: String,
                                       completion: @escaping ([User]) -> Void)
    -> ListenerRegistration {
        return db.collection("requestFriends")
            .whereField("to", isEqualTo: userID)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error fetching received friend requests: \(error)")
                    completion([])
                    return
                }
                guard let snapshot = snapshot else {
                    print("No data found for received friend requests")
                    completion([])
                    return
                }
                var updatedAcceptRequests: [User] = []
                for document in snapshot.documents {
                    if let fromUserID = document.data()["from"] as? String {
                        self.db.collection("users").document(fromUserID).getDocument { (userDoc, userError) in
                            if let userError = userError {
                                print("Error fetching user data: \(userError)")
                                return
                            }
                            guard let userDoc = userDoc,
                                  userDoc.exists,
                                  let userData = userDoc.data() else {
                                print("User document does not exist for \(fromUserID)")
                                return
                            }
                            let user = User(
                                email: userData["email"] as? String ?? "",
                                numberPhone: userData["numberPhone"] as? String ?? "",
                                uid: fromUserID,
                                image: userData["image"] as? String ?? "",
                                birthday: userData["birthday"] as? String ?? "",
                                fullName: userData["fullName"] as? String ?? "",
                                password: "",
                                followers: userData["followers"] as? [String] ?? [],
                                following: userData["following"] as? [String] ?? []
                            )
                            updatedAcceptRequests.append(user)
                            completion(updatedAcceptRequests)
                        }
                    }
                }
            }
    }
    //Allfriends check Friends request add and delete
    func checkFriendRequestStatus(for user: User,
                                  completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "FirebaseService",
                                        code: 401,
                                        userInfo: [NSLocalizedDescriptionKey: "Current user ID is nil"])))
            return
        }
        
        let query = Firestore.firestore().collection("requestFriends")
            .whereField("from", isEqualTo: currentUserID)
            .whereField("to", isEqualTo: user.uid)
        
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let isFriendRequestSent = !(snapshot?.documents.isEmpty ?? true)
                completion(.success(isFriendRequestSent))
            }
        }
    }
    func acceptFriendRequest(currentUserID: String,
                             requesterID: String,
                             completion: @escaping (Result<Void, Error>) -> Void) {
        let batch = db.batch()
        // Add current user to request friends list
        let requesterFriendRef =
            db.collection("friends")
            .document(requesterID)
            .collection("userFriends")
            .document(currentUserID)
        batch.setData(["status": "accepted"], forDocument: requesterFriendRef)
        // Add request to current users friends list
        let currentUserFriendRef =
            db.collection("friends")
            .document(currentUserID)
            .collection("userFriends")
            .document(requesterID)
        batch.setData(["status": "accepted"], forDocument: currentUserFriendRef)
        // remove the friend request after acceptance
        let requestRef =
            db.collection("requestFriends")
            .whereField("from", isEqualTo: requesterID)
            .whereField("to", isEqualTo: currentUserID)
        requestRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let documents = snapshot?.documents {
                for document in documents {
                    batch.deleteDocument(document.reference)
                }
            }
            batch.commit { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    // Fetch friends 
    func fetchFriends(forUserID userID: String,
                      completion: @escaping (Result<[Friend], Error>) -> Void) {
        db.collection("friends").document(userID).collection("userFriends").getDocuments { [self] snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            var friends: [Friend] = []
            for document in snapshot?.documents ?? [] {
                let friendUserID = document.documentID
                self.db.collection("users").document(friendUserID).getDocument {
                    userSnapshot, userError in
                    if let userError = userError {
                        completion(.failure(userError))
                        return
                    }
                    if let userData = userSnapshot?.data(),
                       let fullname = userData["fullName"] as? String,
                       let image = userData["image"] as? String {
                        let friend = Friend(uid: friendUserID,
                                            fullname: fullname,
                                            image: image)
                        friends.append(friend)
                        if friends.count == snapshot?.documents.count {
                            completion(.success(friends))
                        }
                    } else {
                        print("User data not found for userID: \(friendUserID)")
                    }
                }
            }
        }
    }
    //check friends
    func fetchFriendsIDs(forUserID userID: String,
                         completion: @escaping (Result<[String], Error>) -> Void) {
        db.collection("friends").document(userID).collection("userFriends").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let friendIDs = snapshot?.documents.map { $0.documentID } ?? []
                completion(.success(friendIDs))
            }
        }
    }
    func getChatID(forUserID userID: String,
                   completion: @escaping (Result<String, Error>) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(.failure(FirebaseError.userNotAuthenticated))
            return
        }
        print("Fetching chat ID for user: \(userID)")
        let chatRef = db.collection("chats")
            .whereField("participants", arrayContains: currentUserID)
        chatRef.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                completion(.failure(FirebaseError.documentNotFound))
                return
            }
            for document in documents {
                let data = document.data()
                if let participants = data["participants"] as? [String], participants.contains(userID) {
                    print("Found chat ID: \(document.documentID)")
                    completion(.success(document.documentID))
                    return
                }
            }

            print("Chat ID not found")
            completion(.failure(FirebaseError.documentNotFound))
        }
    }
    func sendMessage(chatID: String,
                     senderID: String,
                     receiverID: String,
                     messageContent: String,
                     completion: @escaping (Result<Void, Error>) -> Void) {
        let timestamp = Timestamp(date: Date())
        // Update or create chat document in the chats collection
        let chatRef = db.collection("chats").document(chatID)
        chatRef.setData([
            "last_msg": messageContent,
            "toId": receiverID,
            "fromId": senderID,
            "created_on": timestamp,
        ], merge: true) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            // Add message to the messages subcollection
            let messageData: [String: Any] = [
                "senderID": senderID,
                "messageContent": messageContent,
                "timestamp": timestamp
            ]
            chatRef.collection("messages").addDocument(data: messageData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    func createNewChat(with friend: Friend,
                       completion: @escaping (Result<String, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            print("Error: User is not logged in")
            return
        }
        let currentUserID = currentUser.uid
        let userDocRef = db.collection("users").document(currentUserID)
        userDocRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let document = document,
                  document.exists,
                  let userData = document.data() else {
                let error = NSError(domain: "FirebaseService",
                                    code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "User data does not exist"])
                completion(.failure(error))
                return
            }
            let senderName = userData["fullName"] as? String ?? "Unknown Sender"
            let senderImage = userData["image"] as? String ?? ""
            let chatData: [String: Any] = [
                "participants": [currentUserID, friend.uid],
                "senderImage": senderImage,
                "receiverImage": friend.image,
                "senderName": senderName,
                "receiverName": friend.fullname
            ]
            let newChatRef = self.db.collection("chats").document()
            newChatRef.setData(chatData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(newChatRef.documentID))
                }
            }
        }
    }
    func fetchMessages(chatID: String,
                       completion: @escaping (Result<[Messages], Error>) -> Void) {
        db.collection("chats")
        .document(chatID)
        .collection("messages")
        .order(by: "timestamp", descending: false)
        .getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No messages found"])))
                return
            }
            
            let messages = documents.compactMap { document -> Messages? in
                let data = document.data()
                guard let senderID = data["senderID"] as? String,
                      let messageContent = data["messageContent"] as? String,
                      let timestamp = data["timestamp"] as? Timestamp else {
                    return nil
                }
                return Messages(senderID: senderID,
                                messageContent: messageContent,
                                timestamp: timestamp.dateValue())
            }
            completion(.success(messages))
        }
    }
    // Save or Update user
    func saveUserToFirestore(_ user: User, completion: @escaping (Result<Void, Error>) -> Void)
    {
        db.collection("users").document(user.uid).setData(user.toJson()) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // Upload image and update user
    func uploadImageAndUpdateUser(_ user: User,
                                  image: UIImage,
                                  completion: @escaping (Result<Void, Error>) -> Void)
    {
        uploadProfileImage(user.uid, image: image) { result in
            switch result {
            case .success(let imageURL):
                // Update user's image URL
                var updatedUser = user
                updatedUser.image = imageURL
                
                // Save updated user to Firestore
                self.saveUserToFirestore(updatedUser) { result in
                    completion(result)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Upload profile image
    private func uploadProfileImage(_ uid: String,
                                    image: UIImage,
                                    completion: @escaping (Result<String, Error>) -> Void)
    {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(NSError(domain: "ImageError",
                                        code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "Unable to convert image to data"])))
            return
        }
        let storageRef = Storage.storage().reference().child("profile_images").child(uid)
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url.absoluteString))
                    } else {
                        completion(.failure(NSError(domain: "ImageError",
                                                    code: -1,
                                                    userInfo: [NSLocalizedDescriptionKey: "URL not found"])))
                    }
                }
            }
        }
    }
    //Display users information
    func loadCurrentUser(completion: @escaping (User?) -> Void) {
        if let currentUserID = Auth.auth().currentUser?.uid {
            usersCollection.document(currentUserID).getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    if let email = data?["email"] as? String,
                       let numberPhone = data?["numberPhone"] as? String,
                       let image = data?["image"] as? String,
                       let birthday = data?["birthday"] as? String,
                       let fullName = data?["fullName"] as? String {
                        let user = User(email: email,
                                        numberPhone: numberPhone,
                                        uid: currentUserID,
                                        image: image,
                                        birthday: birthday,
                                        fullName: fullName,
                                        password: "",
                                        followers: [],
                                        following: [])
                        completion(user)
                    } else {
                        print("Failed to parse user data")
                        completion(nil)
                    }
                } else {
                    print("User document does not exist")
                    completion(nil)
                }
            }
        } else {
            print("User is not authenticated")
            completion(nil)
        }
    }
    //custom error types for Firebase errors
    enum FirebaseError: Error {
        case userNotAuthenticated
        case documentNotFound
        case unknownError
    }
}
