//
//  TeamTasksTabVMDelegate.swift
//  YourTurn
//
//  Created by Robert J. Sarvis Jr on 1/5/23.
//

import Foundation

protocol TeamTasksTabVMDelegate: AnyObject {
    func requestTableReload()
    func showMessage(withTitle: String, message: String, completion: (() -> Void)?)
}
