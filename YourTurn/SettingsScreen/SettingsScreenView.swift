//
//  SettingsScreenView.swift
//  YourTurn
//
//  Created by rjs on 9/14/22.
//

import UIKit
import Combine

struct CellIdentifiers {
    static let DeleteUserCell = "DeleteUserCell"
}

class SettingsScreenView: UITableViewController {
    var subscriptions = Set<AnyCancellable>()
    
    var deleteAccountReturnToSignIn = PassthroughSubject<Bool, Never>()
    
    var viewModel: SettingsScreenVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            self.title = viewModel.screenTitle
        }
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        configureTable()
    }
    
    // MARK: Helpers
    func configureTable() {
        tableView.register(DeleteUserCell.self, forCellReuseIdentifier: CellIdentifiers.DeleteUserCell)
        tableView.rowHeight = 32
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.DeleteUserCell, for: indexPath) as! DeleteUserCell
        
        cell.requestDisplayUIAlert.sink { alert in
            self.present(alert, animated: true)
        }.store(in: &subscriptions)
        
        cell.deleteAccountReturnToSignIn.sink { val in
            self.deleteAccountReturnToSignIn.send(val)
        }.store(in: &subscriptions)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.settingsItems.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
