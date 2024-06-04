//
//  RequestFriendsViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 31/05/2024.
//

import UIKit

class RequestFriendsViewController: UIViewController{

    @IBOutlet weak var acceptFriendsTable: UITableView!
    @IBOutlet weak var cancelFriendsTable: UITableView!
    var acceptFriendRequests: [FriendRequest] = []
    var cancelFriendRequests: [FriendRequest] = []
    enum FriendRequestType: Int {
        case acceptFriend = 0
        case cancelFriend = 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        acceptFriendRequests = friendRequests.filter { $0.type == .accept }
        cancelFriendRequests = friendRequests.filter { $0.type == .cancel }
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
            let cell: AcceptFriendsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            let requestRow = acceptFriendRequests[indexPath.row]
            cell.setData(friendsrequest: requestRow)
            return cell
        } else if tableView.tag == FriendRequestType.cancelFriend.rawValue {
            let cell: CancelFriendsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            let cancelRow = cancelFriendRequests[indexPath.row]
            cell.setData(friendsRequest: cancelRow)
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


