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
    let inputCodeSubtitleString = "Please check your email for your login code. \nIf you don't see it, please check your spam folder."
    let submitButtonString = "Submit"
    
    let inputCodeSubject = PassthroughSubject<Result<Bool, Error>, Never>()
    
    let loginRequestModel: LoginRequestModel
    
    func requestJwtFromServer(code: String) {
        let jwtRequestDto = FetchJwtDtoModel(loginCodeRequestId: loginRequestModel.loginRequestId, userId: loginRequestModel.userId, loginRequestToken: code)
        
        Task {
            do {
                let returnBody = try await AuthenticationService.fetchJwtWithCode(dto: jwtRequestDto)
                print(returnBody.token)
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
}
