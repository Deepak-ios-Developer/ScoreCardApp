import SwiftUI

struct LoginView: View {
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var isPhoneNumberValid = true
    @State private var isPasswordValid = true
    @State private var showPassword = false
    @State private var showForgotPassword = false
    @State private var navigateToDashboard = false
    
    // Gradient colors
    let gradientColors = [
        Color(hex: "1E2B6F"),
        Color(hex: "193469"),
        Color(hex: "12264A")
    ]
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: gradientColors),
                         startPoint: .topLeading,
                         endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Logo or App Name
                    Text("Welcome Back")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 50)
                    
                    // Phone Number Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phone Number")
                            .foregroundColor(.white.opacity(0.9))
                            .font(.system(size: 16, weight: .medium))
                        
                        HStack {
                            TextField("Enter phone number", text: $phoneNumber)
                                .keyboardType(.numberPad)
                                .onChange(of: phoneNumber) { newValue in
                                    isPhoneNumberValid = newValue.count >= 10
                                }
                        }
                        .padding()
                        .background(Color.white.opacity(0.12))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isPhoneNumberValid ? Color.clear : Color.red, lineWidth: 1)
                        )
                        
                        if !isPhoneNumberValid {
                            Text("Please enter a valid phone number")
                                .foregroundColor(.red)
                                .font(.system(size: 12))
                        }
                    }
                    .padding(.horizontal)
                    
                    // Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .foregroundColor(.white.opacity(0.9))
                            .font(.system(size: 16, weight: .medium))
                        
                        HStack {
                            if showPassword {
                                TextField("Enter password", text: $password)
                            } else {
                                SecureField("Enter password", text: $password)
                            }
                            
                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.12))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isPasswordValid ? Color.clear : Color.red, lineWidth: 1)
                        )
                        
                        if !isPasswordValid {
                            Text("Password must be at least 6 characters")
                                .foregroundColor(.red)
                                .font(.system(size: 12))
                        }
                    }
                    .padding(.horizontal)
                    
                    if #available(iOS 16.0, *) {
                        Button(action: {
                            if validateInputs() {
                                navigateToDashboard = true
                            }
                        }) {
                            Text("Sign In")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(hex: "193469"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        }
                        .padding(.horizontal)
                        .navigationDestination(isPresented: $navigateToDashboard) {
                            CricketScoreView()
                                .navigationBarBackButtonHidden(true)
                        }
                        .padding(.top, 20)
                    } else {
                        NavigationLink(destination: CricketScoreView().navigationBarBackButtonHidden(true),
                                     isActive: $navigateToDashboard) {
                            Button(action: {
                                if validateInputs() {
                                    navigateToDashboard = true
                                }
                            }) {
                                Text("Sign In")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color(hex: "193469"))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Forgot Password
                    Button(action: {
                        showForgotPassword = true
                    }) {
                        Text("Forgot Password?")
                            .foregroundColor(.white.opacity(0.9))
                            .font(.system(size: 16))
                    }
                    .padding(.top, 10)
                    .sheet(isPresented: $showForgotPassword) {
                        ForgotPasswordView(isPresented: $showForgotPassword)
                    }
                }
                .padding(.vertical, 30)
            }
        }
    }
    
    private func validateInputs() -> Bool {
        isPhoneNumberValid = phoneNumber.count >= 10
        isPasswordValid = password.count >= 6
        return isPhoneNumberValid && isPasswordValid
    }
}

// Color extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
