//
//  HomeMessageExtensions.swift
//  Message_chat
//
//  Created by Minh Vũ on 30/05/2024.
//

import Foundation
import UIKit
extension HomeMessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesTableViewCell", for: indexPath) as? MessagesTableViewCell else {
            return UITableViewCell()
        }
        let messageRow = message[indexPath.row]
        cell.setData(message: messageRow)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Đã chọn hàng \(indexPath.row + 1)")
    }
}
