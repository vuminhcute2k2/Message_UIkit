//
//  AllFriendsViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 31/05/2024.
//

import UIKit

class AllFriendsViewController: UIViewController {

    @IBOutlet weak var allFriendsTableView: UITableView!
    var sortedFriends: [String: [AllFriends]] = [:]
    var sectionTitles: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        sortFriends()
    }
    private func setupTableView() {
        let nib = UINib(nibName: "AllFriendsTableViewCell", bundle: nil)
        allFriendsTableView.register(nib, forCellReuseIdentifier: "AllFriendsTableViewCell")
        allFriendsTableView.dataSource = self
        allFriendsTableView.delegate = self
    }
    private func sortFriends() {
        sortedFriends = Dictionary(grouping: allFriends) { friend in
            return String(friend.name.prefix(1)).uppercased()
        }
        sectionTitles = sortedFriends.keys.sorted()
    }
}
extension AllFriendsViewController: UITableViewDelegate, UITableViewDataSource {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllFriendsTableViewCell", for: indexPath) as? AllFriendsTableViewCell else {
            return UITableViewCell()
        }
        let sectionKey = sectionTitles[indexPath.section]
        if let friend = sortedFriends[sectionKey]?[indexPath.row] {
            cell.setData(allFriends: friend)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionKey = sectionTitles[indexPath.section]
        if let friend = sortedFriends[sectionKey]?[indexPath.row] {
            print("Selected friend: \(friend.name)")
        }
    }
}


