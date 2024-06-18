//
//  RequestFriendsViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 31/05/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class RequestFriendsViewController: UIViewController{

    @IBOutlet weak var acceptFriendsTable: UITableView!
    @IBOutlet weak var cancelFriendsTable: UITableView!
    var acceptFriendRequests: [User] = []
    var cancelFriendRequests: [User] = []
    enum FriendRequestType: Int {
        case acceptFriend = 0
        case cancelFriend = 1
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadFriendRequests()
        loadSentFriendRequests()
        observeFriendRequests()
    }
    private func setupTableView() {
        let nib = UINib(nibName: "AcceptFriendsTableViewCell", bundle: nil)
        acceptFriendsTable.register(nib, forCellReuseIdentifier: "AcceptFriendsTableViewCell")
        acceptFriendsTable.tag = FriendRequestType.acceptFriend.rawValue
        let add = UINib(nibName: "CancelFriendsTableViewCell", bundle: nil)
        cancelFriendsTable.register(add, forCellReuseIdentifier: "CancelFriendsTableViewCell")
        cancelFriendsTable.tag = FriendRequestType.cancelFriend.rawValue
        acceptFriendsTable.delegate = self
        acceptFriendsTable.dataSource = self
        cancelFriendsTable.delegate = self
        cancelFriendsTable.dataSource = self
    }
    private func loadFriendRequests() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        FirebaseService.shared.fetchFriendRequests(for: currentUserID) { result in
            switch result {
            case .success(let users):
                self.acceptFriendRequests = users
                self.acceptFriendsTable.reloadData()
            case .failure(let error):
                print("Error fetching friend requests: \(error)")
            }
        }
    }
    private func loadSentFriendRequests() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        FirebaseService.shared.fetchSentFriendRequests(for: currentUserID) { result in
            switch result {
            case .success(let users):
                self.cancelFriendRequests = users
                self.cancelFriendsTable.reloadData()
            case .failure(let error):
                print("Error fetching sent friend requests: \(error)")
            }
        }
    }
    private func observeFriendRequests() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let cancelListener = FirebaseService.shared.observeSentFriendRequests(for: currentUserID) { [weak self] (cancelRequests) in
            self?.cancelFriendRequests = cancelRequests
            self?.cancelFriendsTable.reloadData()
        }
        let acceptListener = FirebaseService.shared.observeReceivedFriendRequests(for: currentUserID) { [weak self] (acceptRequests) in
            self?.acceptFriendRequests = acceptRequests
            self?.acceptFriendsTable.reloadData()
        }
    }
    private func acceptFriendFromRequest(from user: User) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Current user ID is nil")
            return
        }
        FirebaseService.shared.acceptFriendRequest(currentUserID: currentUserID, requesterID: user.uid) { result in
            switch result {
            case .success:
                print("Friend request accepted successfully!")
                self.acceptFriendRequests.removeAll { $0.uid == user.uid }
                self.acceptFriendsTable.reloadData()
            case .failure(let error):
                print("Error accepting friend request: \(error.localizedDescription)")
            }
        }
    }
    private func cancelFriendRequest(to user: User) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No current user ID")
            return
        }
        FirebaseService.shared.cancelFriendRequest(from: currentUserID, to: user) { [weak self] result in
            switch result {
            case .success:
                print("Friend request canceled for \(user.fullName)")
                NotificationCenter.default.post(
                    name: Notification.Name("FriendRequestAccepted"),
                    object: nil,
                    userInfo: ["user": user])
                self?.cancelFriendRequests.removeAll { $0.uid == user.uid }
                self?.cancelFriendsTable.reloadData()
            case .failure(let error):
                print("Error canceling friend request: \(error.localizedDescription)")
            }
        }
    }
    
}
extension RequestFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == FriendRequestType.acceptFriend.rawValue {
            return acceptFriendRequests.count
        } else if tableView.tag == FriendRequestType.cancelFriend.rawValue {
            return cancelFriendRequests.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == FriendRequestType.acceptFriend.rawValue {
            let cell: AcceptFriendsTableViewCell = tableView.configureCell(for: indexPath, cellIdentifier: "AcceptFriendsTableViewCell", cellType: AcceptFriendsTableViewCell.self)
            let user = acceptFriendRequests[indexPath.row]
            cell.setData(user: user)
            cell.acceptButtonTapped = { [weak self] in
                self?.acceptFriendFromRequest(from: user)
            }
            return cell
        } else if tableView.tag == FriendRequestType.cancelFriend.rawValue {
            let cell: CancelFriendsTableViewCell = tableView.configureCell(for: indexPath, cellIdentifier: "CancelFriendsTableViewCell", cellType: CancelFriendsTableViewCell.self)
            let user = cancelFriendRequests[indexPath.row]
            cell.setData(user: user)
            cell.cancelButtonTapped = { [weak self] in
                self?.cancelFriendRequest(to: user)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let requestType = FriendRequestType(rawValue: tableView.tag) {
            switch requestType {
            case .acceptFriend:
                print("Đã chọn hàng \(indexPath.row) trong acceptFriendsTable")
            case .cancelFriend:
                print("Đã chọn hàng \(indexPath.row) trong cancelFriendsTable")
            }
        }
    }
}


