import SwiftUI

struct ForgotPasswordView: View {
    @Binding var isPresented: Bool
    @State private var phoneNumber = ""
    @State private var isPhoneNumberValid = true
    @State private var showAlert = false
    
    let gradientColors = [
        Color(hex: "1E2B6F"),
        Color(hex: "193469"),
        Color(hex: "12264A")
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: gradientColors),
                         startPoint: .topLeading,
                         endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Text("Reset Password")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                Text("Enter your phone number to receive\na password reset link")
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Phone Number")
                        .foregroundColor(.white.opacity(0.9))
                        .font(.system(size: 16, weight: .medium))
                    
                    TextField("Enter phone number", text: $phoneNumber)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.white.opacity(0.12))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isPhoneNumberValid ? Color.clear : Color.red, lineWidth: 1)
                        )
                        .onChange(of: phoneNumber) { newValue in
                            isPhoneNumberValid = newValue.count >= 10
                        }
                    
                    if !isPhoneNumberValid {
                        Text("Please enter a valid phone number")
                            .foregroundColor(.red)
                            .font(.system(size: 12))
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    if phoneNumber.count >= 10 {
                        // Add your password reset logic here
                        showAlert = true
                    } else {
                        isPhoneNumberValid = false
                    }
                }) {
                    Text("Send Reset Link")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(hex: "193469"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
                .padding(.horizontal)
                
                Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                        .foregroundColor(.white.opacity(0.9))
                        .font(.system(size: 16))
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding(.vertical, 30)
        }
        .alert("Reset Link Sent", isPresented: $showAlert) {
            Button("OK") {
                isPresented = false
            }
        } message: {
            Text("A password reset link has been sent to your phone number.")
        }
    }
}
