//
//  AllFriendsViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 31/05/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
class AllFriendsViewController: UIViewController {
    
    @IBOutlet weak var allFriendsTableView: UITableView!
    var sortedFriends: [User] = []
    var friendsByAlphabet: [[User]] = []
    var sectionTitles: [String] = []
    var isFriendRequestSentList: [[Bool]] = []
    var currentUserFriendIDs: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadAllUsers()
        fetchCurrentUserFriends()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAllUsers()
        fetchCurrentUserFriends()
    }
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: Notification.Name("FriendRequestAccepted"),
            object: nil
        )
    }
    private func setupTableView() {
        let nib = UINib(nibName: "AllFriendsTableViewCell", bundle: nil)
        allFriendsTableView.register(nib, forCellReuseIdentifier: "AllFriendsTableViewCell")
        allFriendsTableView.dataSource = self
        allFriendsTableView.delegate = self
    }
    
    @objc private func handleFriendRequestAccepted(_ notification: Notification) {
        print("Handling FriendRequestAccepted notification...")
        if let userInfo = notification.userInfo,
            let friend = userInfo["friend"] as? User {
            // Update UI button "kết bạn"
            if let indexPath = getIndexPath(for: friend) {
                isFriendRequestSentList[indexPath.section][indexPath.row] = true
                DispatchQueue.main.async { [weak self] in
                    self?.allFriendsTableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
    @objc private func handleFriendRequestCanceled(_ notification: Notification) {
        print("Handling FriendRequestCancel notification...")
        if let userInfo = notification.userInfo,
           let friend = userInfo["friend"] as? User {
            if let indexPath = getIndexPath(for: friend) {
                isFriendRequestSentList[indexPath.section][indexPath.row] = false
                DispatchQueue.main.async { [weak self] in
                    self?.allFriendsTableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
    private func fetchCurrentUserFriends() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Current user ID is nil")
            return
        }

        FirebaseService.shared.fetchFriendsIDs(forUserID: currentUserID) {
            [weak self] result in
            switch result {
            case .success(let friendIDs):
                self?.currentUserFriendIDs = friendIDs
                self?.loadAllUsers()
            case .failure(let error):
                print("Error fetching friends IDs: \(error.localizedDescription)")
            }
        }
    }
    private func loadAllUsers() {
        FirebaseService.shared.fetchAllUsers { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                self.sortedFriends = users
                self.sortFriends()
                DispatchQueue.main.async {
                    self.allFriendsTableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching users: \(error.localizedDescription)")
            }
        }
    }
    private func sortFriends() {
        sortedFriends.sort { $0.fullName < $1.fullName }
        var indexMap: [String: Int] = [:]
        friendsByAlphabet.removeAll()
        sectionTitles.removeAll()
        for friend in sortedFriends {
            let firstLetter = String(friend.fullName.prefix(1)).uppercased()
            if let index = indexMap[firstLetter] {
                // Optional binding to check and add you to the correct group
                if !friendsByAlphabet[index].contains(where: { $0.uid == friend.uid }) {
                    friendsByAlphabet[index].append(friend)
                }
            } else {
                // If firstLetter does not exist in indexMap, create a new group
                sectionTitles.append(firstLetter)
                let newIndex = sectionTitles.count - 1
                friendsByAlphabet.append([friend])
                indexMap[firstLetter] = newIndex
            }
        }
        sectionTitles.sort()
        isFriendRequestSentList.removeAll()
        for _ in sortedFriends {
            isFriendRequestSentList.append(Array(repeating: false,
                                                 count: friendsByAlphabet.count))
        }
        // Arrange the friendsByAlphabet
        var sortedFriendsByAlphabet: [[User]] = []
        for title in sectionTitles {
            if let index = indexMap[title] {
                sortedFriendsByAlphabet.append(friendsByAlphabet[index])
            }
        }
        friendsByAlphabet = sortedFriendsByAlphabet
        // Arrange friends in each group alphabetically
        for i in 0..<friendsByAlphabet.count {
            friendsByAlphabet[i].sort { $0.fullName < $1.fullName }
        }
    }
    private func sendFriendRequest(to user: User) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No current user ID")
            return
        }
        FirebaseService.shared.loadCurrentUser { senderUser in
            guard let senderUser = senderUser else {
                print("Failed to load current user")
                return
            }
            let friendRequest = [
                "from": currentUserID,
                "to": user.uid,
                "senderName": senderUser.fullName,
                "senderImage": senderUser.image,
                "friendName": user.fullName,
                "friendImage": user.image,
                "timestamp": FieldValue.serverTimestamp()
            ] as [String: Any]
            
            Firestore.firestore().collection("requestFriends").addDocument(data: friendRequest)
            { [weak self] error in
                if let error = error {
                    print("Error sending friend request: \(error.localizedDescription)")
                } else {
                    print("Friend request sent to \(user.fullName)")
                    self?.updateFriendRequestStatus(for: user, isSent: true)
                }
            }
        }
    }
    
    private func cancelFriendRequest(to user: User) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No current user ID")
            return
        }
        FirebaseService.shared.cancelFriendRequest(from: currentUserID, to: user) {
            [weak self] result in
            switch result {
            case .success:
                print("Friend request canceled for \(user.fullName)")
                self?.updateFriendRequestStatus(for: user, isSent: false)
            case .failure(let error):
                print("Error canceling friend request: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateFriendRequestStatus(for user: User, isSent: Bool) {
        if let indexPath = getIndexPath(for: user) {
            isFriendRequestSentList[indexPath.section][indexPath.row] = isSent
            allFriendsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    private func getIndexPath(for user: User) -> IndexPath? {
        for (sectionIndex, section) in friendsByAlphabet.enumerated() {
            if let rowIndex = section.firstIndex(where: { $0.uid == user.uid }) {
                return IndexPath(row: rowIndex, section: sectionIndex)
            }
        }
        return nil
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
        let isAlreadyFriend = currentUserFriendIDs.contains(friend.uid)
        cell.isFriendRequestSent = isFriendRequestSentList[indexPath.section][indexPath.row]
        cell.setData(user: friend, isAlreadyFriend: isAlreadyFriend)
        cell.addFriendAction = { [weak self] user in
            self?.sendFriendRequest(to: user)
        }
        cell.cancelFriendAction = { [weak self] user in
            self?.cancelFriendRequest(to: user)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let friend = friendsByAlphabet[indexPath.section][indexPath.row]
        print("Selected friend: \(friend.fullName)")
    }
}


