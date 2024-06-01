//
//  RequestFriendsExtensions.swift
//  Message_chat
//
//  Created by Minh Vũ on 01/06/2024.
//

import Foundation
import UIKit
extension RequestFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == acceptFriendsTable {
            return request.count
        } else if tableView == cancelFriendsTable {
            return cancel.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == acceptFriendsTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AcceptFriendsTableViewCell", for: indexPath) as? AcceptFriendsTableViewCell else {
                return UITableViewCell()
            }
            let requestRow = request[indexPath.row]
            cell.setData(request: requestRow)
            return cell
        } else if tableView == cancelFriendsTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CancelFriendsTableViewCell", for: indexPath) as? CancelFriendsTableViewCell else {
                return UITableViewCell()
            }
            let cancelRow = cancel[indexPath.row]
            cell.setData(cancel: cancelRow)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == acceptFriendsTable {
            print("Đã chọn hàng \(indexPath.row) trong acceptFriendsTable")
        } else if tableView == cancelFriendsTable {
            print("Đã chọn hàng \(indexPath.row) trong cancelFriendsTable")
        }
    }
}

