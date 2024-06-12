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
    // Save or Update user
    func saveUserToFirestore(_ user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).setData(user.toJson()) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // Upload image and update user
    func uploadImageAndUpdateUser(_ user: User, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
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
    private func uploadProfileImage(_ uid: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to convert image to data"])))
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
                        completion(.failure(NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL not found"])))
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
                    // Lấy dữ liệu từ tài liệu Firestore
                    let data = document.data()
                    // Kiểm tra và rút trích các trường cần thiết từ dữ liệu
                    if let email = data?["email"] as? String,
                       let numberPhone = data?["numberPhone"] as? String,
                       let image = data?["image"] as? String,
                       let birthday = data?["birthday"] as? String,
                       let fullName = data?["fullName"] as? String {
                        
                        // Khởi tạo đối tượng User từ dữ liệu đã rút trích được
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
}
