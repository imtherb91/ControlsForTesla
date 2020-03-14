//
//  LoginView.swift
//  Key for Tesla Purchases
//
//  Created by Luke Allen on 2/10/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI
import Combine

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var authState: AuthState
    @ObservedObject var activityModel = NetworkActivityModel()
    @State var cancellable: AnyCancellable?
    
    var loginEnabled: Bool {
        email.isEmpty == false && password.isEmpty == false
    }
    
    var buttonBackground: some View {
        RoundedRectangle(cornerRadius: 7).fill(Color.red)
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Icon.image.resizable().frame(width: 80, height: 80)
                    Text("Controls\nfor Tesla").font(Font.system(size: 32)).fontWeight(.bold).frame(maxHeight: 85)
                }.padding(.top)
                Spacer()
                Text("Email address").fontWeight(.medium).frame(maxWidth: .infinity, alignment: .leading)
                TextField("Email", text: $email).textFieldStyle(RoundedBorderTextFieldStyle()).keyboardType(.emailAddress).disableAutocorrection(true).autocapitalization(.none)
                Text("Password").fontWeight(.medium).frame(maxWidth: .infinity, alignment: .leading)
                SecureField("Password", text: $password).textFieldStyle(RoundedBorderTextFieldStyle()).disableAutocorrection(true).autocapitalization(.none)
                Text("Log in with your Tesla account credentials.").font(.caption).foregroundColor(.gray).padding()
                Button(action: {
                    self.login()
                }) {
                    ZStack {
                        buttonBackground
                        Text("Log in").fontWeight(.medium).foregroundColor(.white)
                    }
                }.frame(maxWidth: .infinity, maxHeight: 50.0).buttonStyle(PlainButtonStyle()).disabled(!loginEnabled)
                Spacer()
                Text("Your credentials will be securely stored in the Keychain. They will never be shared or used outside of the app.").font(.caption).foregroundColor(.gray).multilineTextAlignment(.center).padding()
            }.padding()
            if activityModel.isWaitingForResponse {
                LoadingView(label: "Logging in...")
            }
        }.onAppear {
            Debug.log()
            #if targetEnvironment(simulator)
            self.email = "luketimallen@gmail.com"
            self.password = "testaccount"
            #endif
        }.alert(isPresented: $activityModel.shouldShowAlert) { () -> Alert in
            Alert(title: Text(self.activityModel.errorMessage ?? "Unknown Error"))
        }
    }
    
    func login() {
        self.activityModel.isWaitingForResponse = true
        cancellable = OAuth.login(email: self.email, password: self.password) { (response, error) in
            Debug.log()
            withAnimation {
                DispatchQueue.main.async {
                    self.activityModel.isWaitingForResponse = false
                }
            }
            if self.activityModel.shouldHandleError(error) {
                return
            }
            guard response?.access_token.isEmpty == false else {
                Debug.log()
                self.activityModel.handleError("Error logging in")
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
        LoginView()//.environment(\.colorScheme, .dark)
    }
}
