//
//  TeamAddModalVM.swift
//  YourTurn
//
//  Created by rjs on 8/23/22.
//

import Foundation

struct TeamAddModalVM {
    let closeButtonTitleText = "Create Team"
    let createTeamAndInviteButtonText = "Create Team & Invite Users"
    let modalTitleText = "Create a Team"
    let teamNameFieldPlacholderText = "Team Name"

    func createTeam(viewController: TeamAddModal, teamName: String) {
        viewController.showLoader(true)
        viewController.createButton.isEnabled = false
        defer {
            viewController.showLoader(false)
            viewController.createButton.isEnabled = true
        }

        Task {
            do {
                let createTeamDto = CreateTeamDto(teamName: teamName)
                let team = try await TeamService.createTeam(teamDto: createTeamDto)
                Logger.log(logLevel: .verbose, name: Logger.Events.Team.teamCreated, payload: ["teamId": team.teamId, "teamName": teamName])
                await viewController.closeModal()
                await viewController.delegate?.onTeamAddScreenComplete(viewController: viewController)
            } catch {
                self.handleTeamCreateFail(viewController: viewController, error: error, teamName: teamName)
            }
        }
    }

    func createTeamAndGoToInvite(viewController: TeamAddModal, teamName: String) {
        viewController.showLoader(true)
        viewController.createAndInviteButton.isEnabled = false
        defer {
            viewController.showLoader(false)
            viewController.createAndInviteButton.isEnabled = true
        }

        Task {
            do {
                let createTeamDto = CreateTeamDto(teamName: teamName)
                let team = try await TeamService.createTeam(teamDto: createTeamDto)
                Logger.log(logLevel: .verbose, name: Logger.Events.Team.teamCreated, payload: ["teamId": team.teamId, "teamName": teamName])
                await viewController.closeModal()
                await viewController.delegate?.onTeamAddGoToInvite(viewController: viewController, teamId: team.teamId)
            } catch {
                self.handleTeamCreateFail(viewController: viewController, error: error, teamName: teamName)
            }
        }
    }

    func createTeamCreateFailErrorMessageString(error: Error) -> String {
        return "Problem encountered creating the team. \(error.localizedDescription)"
    }

    private func handleTeamCreateFail(viewController: TeamAddModal, error: Error, teamName: String) {
        Logger.log(logLevel: .prod, name: Logger.Events.Team.teamCreateFailed, payload: ["error": error, "teamName": teamName])
        viewController.showMessage(withTitle: "Uh Oh", message: createTeamCreateFailErrorMessageString(error: error))
    }
}
