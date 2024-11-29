//
//  PassWordView.swift
//  dauphin
//
//  Created by \u8b19 on 11/25/24.
//
import SwiftUI
import LocalAuthentication

struct PassWordView: View {
    @State private var password: String = ""
    @State private var inputPassword: String = ""
    @State private var newPassword: String = ""
    @State private var isAuthenticated = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var isUpdatingPassword = false

    var body: some View {
        VStack(spacing: 20) {
            if isAuthenticated {
                Text("Welcome!")
                    .font(.largeTitle)

                if isUpdatingPassword {
                    SecureField("Enter new password", text: $newPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button(action: updatePassword) {
                        Text("Update Password")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    SecureField("Enter your password", text: $inputPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button(action: { isUpdatingPassword = true }) {
                        Text("Update Password")
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            } else {
                Button(action: authenticateWithBiometrics) {
                    Text("Unlock with Biometrics")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }

    func updatePassword() {
        guard !newPassword.isEmpty else {
            errorMessage = "New password cannot be empty!"
            showErrorAlert = true
            return
        }

        password = newPassword
        KeychainManager.shared.save(password, forKey: "userPassword")
        isUpdatingPassword = false
        errorMessage = "Password updated successfully!"
        showErrorAlert = true
    }

    func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to access or update your password"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        isAuthenticated = true
                    } else {
                        errorMessage = authError?.localizedDescription ?? "Biometric authentication failed"
                        showErrorAlert = true
                    }
                }
            }
        } else {
            errorMessage = error?.localizedDescription ?? "Biometrics not available"
            showErrorAlert = true
        }
    }
}

#Preview {
    PassWordView()
}
