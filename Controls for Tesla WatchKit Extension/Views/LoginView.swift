//
//  LoginView.swift
//  Key for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/6/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI
import Combine

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var authState: AuthState
    @State private var isWaitingForResponse: Bool = false
    @State private var shouldShowAlert: Bool = false
    @State private var errorMessage: String?
    @State private var cancellable: AnyCancellable?
    var loginEnabled: Bool {
        email.isEmpty == false && password.isEmpty == false
    }
    
    var buttonBackground: some View {
        RoundedRectangle(cornerRadius: 7).fill(Color.darkModeRed)
    }
    
    var body: some View {
        ZStack {
            VStack {
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
                Button(action: {
                    self.login()
                }) {
                    ZStack {
                        buttonBackground
                        Text("Log in")
                    }
                }.frame(maxWidth: .infinity, maxHeight: 44.0).buttonStyle(PlainButtonStyle()).disabled(!loginEnabled)
            }
            if isWaitingForResponse {
                LoadingView(label: "Logging in...")
            }
        }.onAppear {
            Debug.log()
            #if targetEnvironment(simulator)
            self.email = "luketimallen@gmail.com"
            self.password = "testaccount"
            #endif
        }.alert(isPresented: $shouldShowAlert) { () -> Alert in
            Alert(title: Text(self.errorMessage ?? "Oops! There was an error."))
        }
    }
    
    func login() {
        self.isWaitingForResponse = true
        cancellable = OAuth.login(email: self.email, password: self.password) { (response, error) in
            Debug.log()
            self.isWaitingForResponse = false
            guard response?.access_token.isEmpty == false else {
                Debug.log()
                self.errorMessage = error?.localizedDescription ?? "Invalid username or password"
                self.shouldShowAlert = true
                return
            }
            DispatchQueue.main.async {
                withAnimation {
                    self.authState.isLoggedIn = true
                }
            }
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
