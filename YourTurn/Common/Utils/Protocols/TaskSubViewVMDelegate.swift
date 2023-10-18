//
//  TaskSubViewVMDelegate.swift
//  YourTurn
//
//  Created by Robert J. Sarvis Jr on 1/3/23.
//

import UIKit

protocol TaskSubViewVMDelegate: AnyObject {
    func requestHomeReloadFromSubView()
    func requestPopView()
    func requestShowMessage(withTitle: String, message: String)
    func requestPresentViewController(_: UIViewController)
}
