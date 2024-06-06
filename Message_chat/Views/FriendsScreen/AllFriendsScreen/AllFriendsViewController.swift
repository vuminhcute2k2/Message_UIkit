//
//  AllFriendsViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 31/05/2024.
//

import UIKit
import FirebaseFirestore
class AllFriendsViewController: UIViewController {
    
    @IBOutlet weak var allFriendsTableView: UITableView!
    var sortedFriends: [User] = []
    var friendsByAlphabet: [[User]] = []
    var sectionTitles: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadAllUsers()
    }
    private func setupTableView() {
        let nib = UINib(nibName: "AllFriendsTableViewCell", bundle: nil)
        allFriendsTableView.register(nib, forCellReuseIdentifier: "AllFriendsTableViewCell")
        allFriendsTableView.dataSource = self
        allFriendsTableView.delegate = self
    }
    private func loadAllUsers() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error users: \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot else { return }
            self.sortedFriends = snapshot.documents.compactMap { document -> User? in
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
            self.sortFriends()
            self.allFriendsTableView.reloadData()
        }
    }
    private func sortFriends() {
        sortedFriends.sort { $0.fullName < $1.fullName }
        var indexMap: [String: Int] = [:]
        for friend in sortedFriends {
            let firstLetter = String(friend.fullName.prefix(1)).uppercased()
            if indexMap[firstLetter] != nil {
                let index = indexMap[firstLetter]!
                if !friendsByAlphabet[index].contains(where: { $0.uid == friend.uid }) {
                    friendsByAlphabet[index].append(friend)
                }
            } else {
                sectionTitles.append(firstLetter)
                let newIndex = sectionTitles.count - 1
                friendsByAlphabet.append([friend])
                indexMap[firstLetter] = newIndex
            }
        }
    }
}
extension AllFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsByAlphabet[section].count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllFriendsTableViewCell", for: indexPath) as? AllFriendsTableViewCell else {
            return UITableViewCell()
        }
        let friend = friendsByAlphabet[indexPath.section][indexPath.row]
        cell.setData(user: friend)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let friend = friendsByAlphabet[indexPath.section][indexPath.row]
        print("Selected friend: \(friend.fullName)")
    }
}


