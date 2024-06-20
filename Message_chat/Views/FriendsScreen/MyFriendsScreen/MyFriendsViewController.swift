//
//  MyFriendsViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 31/05/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class MyFriendsViewController: UIViewController {
    
    @IBOutlet weak var friendsTableView: UITableView!
    var user: User?
    var myFriends: [Friend] = []
    var friendSections: [FriendSection] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchFriends()
        // Add observer for friend request accepted event and cancel friends
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleFriendRequestAccepted(_:)),
            name: Notification.Name("FriendRequestAccepted"),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleFriendRequestCanceled(_:)),
            name: Notification.Name("FriendRequestCanceled"),
            object: nil
        )
    }
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name:Notification.Name("FriendRequestCanceled"),
            object: nil
        )
    }
    //Update UI friends
    @objc private func handleFriendRequestAccepted(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let user = userInfo["friend"] as? User {
            let friend = Friend(uid: user.uid, fullname: user.fullName, image: user.image)
            self.myFriends.append(friend)
            self.sortFriends()
            DispatchQueue.main.async { [weak self] in
                self?.friendsTableView.reloadData()
            }
        }
    }
    // Update UI when friend request is canceled
    @objc private func handleFriendRequestCanceled(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let user = userInfo["friend"] as? User {
            self.myFriends.removeAll { $0.uid == user.uid }
            self.sortFriends()
            DispatchQueue.main.async { [weak self] in
                self?.friendsTableView.reloadData()
            }
        }
    }
    private func setupTableView() {
        let nib = UINib(nibName: "MyFriendsTableViewCell", bundle: nil)
        friendsTableView.register(nib, forCellReuseIdentifier: "MyFriendsTableViewCell")
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
    }
    private func fetchFriends() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Current user ID is nil")
            return
        }
        FirebaseService.shared.fetchFriends(forUserID: currentUserID) { result in
            switch result {
            case .success(let friends):
                self.myFriends = friends
                self.sortFriends()
                DispatchQueue.main.async {
                    self.friendsTableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching friends: \(error.localizedDescription)")
            }
        }
    }
   
    private func sortFriends() {
        let groupedFriends = Dictionary(grouping: myFriends) { friend in
            return String(friend.fullname.prefix(1)).uppercased()
        }
        friendSections = groupedFriends.map { FriendSection(firstLetter: $0.key,
                                                            friends: $0.value) }
        friendSections.sort { $0.firstLetter < $1.firstLetter }
    }
}
extension MyFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return friendSections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendSections[section].friends.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendSections[section].firstLetter
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MyFriendsTableViewCell",
            for: indexPath) as? MyFriendsTableViewCell else {
            return UITableViewCell()
        }
        let friend = friendSections[indexPath.section].friends[indexPath.row]
        cell.setData(friend: friend)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let friend = friendSections[indexPath.section].friends[indexPath.row]
        print("Selected friend: \(friend.fullname)")
    }
}
struct FriendSection {
    let firstLetter: String
    var friends: [Friend]
}


