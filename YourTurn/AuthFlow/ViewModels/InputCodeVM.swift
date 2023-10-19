//
//  InputCodeVM.swift
//  YourTurn
//
//  Created by Robert J. Sarvis Jr on 8/30/23.
//

import Foundation
import Combine

class InputCodeVM {
    let inputCodeLabelTextString = "Input Code"
    let inputCodeSubtitleString =
    "Please check your email for your login code. \nIf you don't see it, please check your spam folder."
    let submitButtonString = "Submit"

    let inputCodeSubject = PassthroughSubject<Result<Bool, Error>, Never>()

    let loginRequestModel: LoginRequestModel

    func requestJwtFromServer(code: String) {
        let jwtRequestDto = FetchJwtDtoModel(
            loginCodeRequestId: loginRequestModel.loginRequestId,
            userId: loginRequestModel.userId,
            loginRequestToken: code)

        Task {
            do {
                let returnBody = try await AuthenticationService.fetchJwtWithCode(dto: jwtRequestDto)
                AppState.getInstance(accessToken: returnBody.token, refreshToken: "")
                inputCodeSubject.send(.success(true))
            } catch {
                inputCodeSubject.send(.failure(error))
                print(error.localizedDescription)
            }
        }
    }

    init(loginRequestModel: LoginRequestModel) {
        self.loginRequestModel = loginRequestModel
    }

    func validateTokenInputFromUser(code: String) -> (Bool, String) {
        if code.count != 6 {
            return (false, "Code length is incorrect.")
        }

        let alphanumericRegEx = "^[a-zA-Z0-9]*$"
        if code.range(of: alphanumericRegEx, options: .regularExpression) != nil {
            return (true, "")
        }

        return (false, "Code should only contain alpha numeric characters")
    }
}
