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
    func registerUser(email: String, password: String, name: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let user = authResult?.user else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "User creation failed"])
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
    private func saveUserInfo(user: User, completion: @escaping (Result<User, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).setData(user.toJson()) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(user))
            }
        }
    }
}
