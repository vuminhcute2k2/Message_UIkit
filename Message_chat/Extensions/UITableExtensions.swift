//
//  UITableExtensions.swift
//  Message_chat
//
//  Created by Minh Vũ on 03/06/2024.
//

import Foundation
import UIKit
extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Cannot dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
    func configureCell<T: UITableViewCell>(for indexPath: IndexPath,
                                               with users: [User],
                                               cellIdentifier: String,
                                               cellType: T.Type) -> T {
        let cell = self.dequeueReusableCell(withIdentifier: cellIdentifier,
                                            for: indexPath) as! T
        let user = users[indexPath.row]
        if let cell = cell as? AcceptFriendsTableViewCell {
            cell.setData(user: user)
        } else if let cell = cell as? CancelFriendsTableViewCell {
            cell.setData(user: user)
        }
        return cell
    }
}
// MARK: - UITableViewCell extension
extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
