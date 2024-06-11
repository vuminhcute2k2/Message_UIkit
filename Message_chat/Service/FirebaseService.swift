//
//  FirebaseService.swift
//  Message_chat
//
//  Created by Minh Vũ on 06/06/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
class FirebaseService {
    static let shared = FirebaseService()
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
}
