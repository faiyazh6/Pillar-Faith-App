import SwiftUI

struct AuthenticationView: View {
    @AppStorage("accounts") private var accountsData: String = "" // Store accounts as JSON
    @AppStorage("currentUser") private var currentUser: String = "" // Store the currently logged-in user

    @State private var isNewUser = true
    @State private var username = ""
    @State private var password = ""
    @State private var accounts: [Account] = []
    @State private var errorMessage: String? = nil // To display error messages
    @State private var navigateToHome = false // Navigation trigger for HomeView

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text(isNewUser ? "Create an Account" : "Log In")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 40)

                // Username Field
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 16)

                // Password Field
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 16)

                // Error Message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                        .padding(.horizontal, 16)
                        .multilineTextAlignment(.center)
                }

                // Action Button
                Button(action: {
                    if isNewUser {
                        handleSignUp()
                    } else {
                        handleLogIn()
                    }
                }) {
                    Text(isNewUser ? "Sign Up" : "Log In")
                        .font(.system(size: 16, weight: .bold))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 16)

                // Switch between Signup and Login
                Button(action: {
                    isNewUser.toggle()
                    errorMessage = nil // Clear any error message when switching
                }) {
                    Text(isNewUser ? "Already have an account? Log In" : "Don't have an account? Sign Up")
                        .font(.system(size: 14))
                        .foregroundColor(.brown)
                }

                Spacer()

                // Navigation to HomeView
                NavigationLink(
                    destination: HomeView(), // Add constant to simulate binding
                    isActive: $navigateToHome
                ) {
                    EmptyView()
                }
            }
            .onAppear {
                loadAccounts()
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    // Handle Sign Up
    private func handleSignUp() {
        if username.isEmpty || password.isEmpty {
            errorMessage = "Both username and password are required."
            return
        }

        if accounts.contains(where: { $0.username == username }) {
            errorMessage = "Account already exists. Would you like to log in instead?"
            return
        }

        let newAccount = Account(username: username, password: password)
        accounts.append(newAccount)
        saveAccounts()
        currentUser = username
        errorMessage = nil
        navigateToHome = true // Navigate to HomeView
    }

    // Handle Log In
    private func handleLogIn() {
        if let account = accounts.first(where: { $0.username == username && $0.password == password }) {
            currentUser = account.username
            errorMessage = nil
            navigateToHome = true // Navigate to HomeView
        } else {
            errorMessage = "Login information is either inaccurate or does not exist."
        }
    }

    // Save accounts to storage
    private func saveAccounts() {
        if let encodedData = try? JSONEncoder().encode(accounts) {
            accountsData = String(data: encodedData, encoding: .utf8) ?? ""
        }
    }

    // Load accounts from storage
    private func loadAccounts() {
        if let data = accountsData.data(using: .utf8),
           let decodedAccounts = try? JSONDecoder().decode([Account].self, from: data) {
            accounts = decodedAccounts
        }
    }
}

struct Account: Codable, Equatable {
    let username: String
    let password: String
}
