//
//  SettingsView.swift
//  Key for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/9/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var model = SettingsViewModel()
    @EnvironmentObject var auth: AuthState
    @Environment(\.presentationMode) var pres
    
    var logoutButton: some View {
        Button(action: {
            self.logout()
        }) {
            Text("Log out").frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    var tempUnitPicker: some View {
        HStack {
            Text("Temp Unit:")
            Spacer(minLength: 0.0)
            Button(action: {
                self.model.tempUnitIsC.toggle()
            }) {
                Text("\(model.tempUnit)")
            }.buttonStyle(PlainButtonStyle()).frame(maxWidth: 44.0, maxHeight: 40.0).background(RoundedRectangle(cornerRadius: 7).fill(Color.darkModeRed))
        }
    }
    
    var version: some View {
        HStack {
            Text("Version")
            Spacer(minLength: 0.0)
            Text(model.version)
        }
    }
    
    var body: some View {
        ZStack {
            List {
                Section(header: Text("Unit settings")) {
                    tempUnitPicker
                    version
                }
                Section {
                    logoutButton
                }
            }
            if model.isLoggingOut {
                LoadingView(label: "Logging out...")
            }
        }
    }
    
    func logout() {
        model.isLoggingOut = true
        model.cancellable = Logout.send { success in
            if success {
                Debug.log("Logout succeeded")
                DispatchQueue.main.async {
                    self.model.isLoggingOut = false
                    SecureData.clearKeychain()
                    self.auth.isLoggedIn = false
                    self.pres.wrappedValue.dismiss()
                }
            } else {
                Debug.log("Logout failed")
            }
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
