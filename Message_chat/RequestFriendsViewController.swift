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
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    private func setupTableView() {
        let nib = UINib(nibName: "AcceptFriendsTableViewCell", bundle: nil)
        acceptFriendsTable.register(nib, forCellReuseIdentifier: "AcceptFriendsTableViewCell")
        let add = UINib(nibName: "CancelFriendsTableViewCell", bundle: nil)
        cancelFriendsTable.register(add, forCellReuseIdentifier: "CancelFriendsTableViewCell")
        acceptFriendsTable.delegate = self
        acceptFriendsTable.dataSource = self
        cancelFriendsTable.delegate = self
        cancelFriendsTable.dataSource = self
    }
}
