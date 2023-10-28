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
    static let MembershipSubscriptionCell = "MembershipSubscriptionCell"
    static let RestorePurchasesCell = "RestorePurchasesCell"
    static let LifetimeUnlockCell = "LifetimeUnlockCell"
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
        view.backgroundColor = .customBackgroundColor
    }

    // MARK: Helpers
    func configureTable() {
        tableView.backgroundColor = .customBackgroundColor
        tableView.register(DeleteUserCell.self, forCellReuseIdentifier: CellIdentifiers.DeleteUserCell)
        tableView.register(
            MembershipSubscriptionCell.self,
            forCellReuseIdentifier: CellIdentifiers.MembershipSubscriptionCell)
        tableView.register(
            RestorePurchasesCell.self, forCellReuseIdentifier: CellIdentifiers.RestorePurchasesCell)
        tableView.register(LifetimeUnlockCell.self, forCellReuseIdentifier: CellIdentifiers.LifetimeUnlockCell)
        tableView.rowHeight = 32
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CellIdentifiers.DeleteUserCell,
            for: indexPath)

        let subscribeCell = tableView.dequeueReusableCell(
            withIdentifier: CellIdentifiers.MembershipSubscriptionCell,
            for: indexPath)

        let restorePurchasesCell = tableView.dequeueReusableCell(
            withIdentifier: CellIdentifiers.RestorePurchasesCell,
            for: indexPath)

        let lifetimeUnlockCell = tableView.dequeueReusableCell(
            withIdentifier: CellIdentifiers.LifetimeUnlockCell,
            for: indexPath)

        if indexPath.row == 3, let cell = cell as? DeleteUserCell {
            cell.requestDisplayUIAlert.sink { alert in
                self.present(alert, animated: true)
            }.store(in: &subscriptions)

            cell.deleteAccountReturnToSignIn.sink { deleteResponse in
                switch deleteResponse {
                case .failure(let error):
                    self.showMessage(withTitle: "Uh Oh", message: error.localizedDescription)
                case .success:
                    self.deleteAccountReturnToSignIn.send(true)
                }
            }.store(in: &subscriptions)
            return cell
        } else if indexPath.row == 0, let cell = subscribeCell as? MembershipSubscriptionCell {
            return cell
        } else if indexPath.row == 2,
                  let cell = restorePurchasesCell as? RestorePurchasesCell {
            return cell
        } else if indexPath.row == 1,
                  let cell = lifetimeUnlockCell as? LifetimeUnlockCell {
            return cell
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.settingsItems.count ?? 0
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
