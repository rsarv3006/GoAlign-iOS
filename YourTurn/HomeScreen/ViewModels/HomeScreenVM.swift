//
//  HomeScreenVM.swift
//  YourTurn
//
//  Created by rjs on 6/21/22.
//

import Combine
import UIKit
import NotificationBannerSwift

class HomeScreenVM {
    private(set) var subscriptions = Set<AnyCancellable>()

    var loadViewControllerSubject = PassthroughSubject<UIViewController, Never>()

    let taskTitleLabel: NSAttributedString = NSAttributedString(string: "My Tasks",
                                                                attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
    let teamTitleLabel: NSAttributedString = NSAttributedString(string: "My Groups",
                                                                attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])

    var tasksSubject = PassthroughSubject<Result<TaskModelArray, Error>, Never>()

    var teamsSubject = PassthroughSubject<Result<[TeamModel], Error>, Never>()

    func loadTasks() {
        Task {
            do {
                let tasks = try await TaskService.getTasksByAssignedUserId()

                tasksSubject.send(.success(tasks.filter({ task in
                    if task.status != TaskStatusVariant.completed.rawValue {
                        return true
                    } else {
                        return false
                    }
                })))

            } catch {
                tasksSubject.send(.failure(error))
            }
        }
    }

    func loadTeams() {
        Task {
            do {
                let teams = try await TeamService.getTeamsByCurrentUser()
                teamsSubject.send(.success(teams))
            } catch {
                teamsSubject.send(.failure(error))
            }
        }
    }

    func onMarkTaskComplete(viewController: UIViewController, taskEntryId: UUID) {
        Task {
            do {
                _ = try await TaskService.markTaskComplete(taskEntryId: taskEntryId)
                self.loadTasks()
            } catch {
                await viewController.showMessage(withTitle: "Uh Oh", message: error.localizedDescription)
            }
        }
    }

    func loadTeamsAndTasks() {
        loadTasks()
        loadTeams()
    }

    func checkAndDisplayPendingInviteBaner(viewController: UIViewController) {
        Task {
            do {
                let invites = try await TeamInviteService.getTeamInvitesByCurrentUser()

                if !invites.isEmpty {
                    var title = ""
                    var subTitle = ""

                    if invites.count > 1 {
                        title = "Invites Pending"
                        subTitle = "You have \(invites.count) pending invites."
                    } else {
                        title = "Invite Pending"
                        subTitle = "\(invites[0].inviteCreator.username) as invited you to a team."
                    }

                    let banner = await FloatingNotificationBanner(title: title, subtitle: subTitle)

                    await banner.show(on: viewController, cornerRadius: 12, shadowEdgeInsets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
                }

            } catch {
                Logger.log(logLevel: .Verbose, name: Logger.Events.Team.Invite.fetchFailed, payload: ["message": error.localizedDescription])
            }
        }

    }
}
