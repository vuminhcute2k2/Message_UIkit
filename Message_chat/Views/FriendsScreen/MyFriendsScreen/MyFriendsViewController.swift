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
    var sortedFriends: [String: [Friend]] = [:]
    var sectionTitles: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchFriends()
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
        sortedFriends = Dictionary(grouping: myFriends) { friend in
            return String(friend.fullname.prefix(1)).uppercased()
        }
        sectionTitles = sortedFriends.keys.sorted()
    }
}
extension MyFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey = sectionTitles[section]
        return sortedFriends[sectionKey]?.count ?? 0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendsTableViewCell", for: indexPath) as? MyFriendsTableViewCell else {
            return UITableViewCell()
        }
        let sectionKey = sectionTitles[indexPath.section]
        if let friend = sortedFriends[sectionKey]?[indexPath.row] {
            cell.setData(friend: friend)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionKey = sectionTitles[indexPath.section]
        if let friend = sortedFriends[sectionKey]?[indexPath.row] {
            print("Selected friend: \(friend.fullname)")
        }
    }
}

