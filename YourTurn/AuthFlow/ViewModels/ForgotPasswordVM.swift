//
// Created by rjs on 12/8/22.
//

import Foundation

struct ForgotPasswordVM {
    let screenTitle: String = "Forgot Password"
    let resetPasswordButtonLabelString: String = "Request Password Reset"
    let resetEmailPlaceholderString: String = "Email Address"
    
    func requestPasswordReset(emailAddress: String, completion: @escaping(((Error?) -> Void))) {
        AuthenticationService.requestPasswordReset(emailAddress: emailAddress) { error in
            completion(error)
        }
    }
}
