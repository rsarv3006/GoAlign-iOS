//
// Created by rjs on 12/8/22.
//

import UIKit

struct ForgotPasswordVM {
    let screenTitle: String = "Forgot Password"
    let resetPasswordButtonLabelString: String = "Request Password Reset"
    let resetEmailPlaceholderString: String = "Email Address"
    
    func requestPasswordReset(viewController: UIViewController, email: String?) {
        guard let email = email, !email.isEmpty, email.contains("@") else {
            viewController.showMessage(withTitle: "", message: "Invalid email address")
            return
        }
        
        Task{
            do {
                try await AuthenticationService.requestPasswordReset(emaillAddress: email)
                await viewController.showMessage(withTitle: "Reset Requested", message: "Password reset has been requested. If you don't see it in your email please check your spam folder.")
            } catch {
                await viewController.showMessage(withTitle: "Uh Oh", message: error.localizedDescription)
            }
        }
        
    }
}
