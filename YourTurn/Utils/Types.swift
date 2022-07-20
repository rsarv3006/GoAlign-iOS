//
//  Types.swift
//  YourTurn
//
//  Created by rjs on 6/24/22.
//

import Foundation

typealias GqlTasksByAssignedUserIdTaskObject = TasksByAssignedUserIdQuery.Data.GetTasksByAssignedUserId

typealias GqlTeamsByUserIdTeamObject = GetTeamsByUserIdQuery.Data.GetTeamsByUserId

enum ShowHideLabelVariant {
    case show
    case hide
}
