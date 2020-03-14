//
//  SettingsView.swift
//  Key for Tesla Purchases
//
//  Created by Luke Allen on 2/10/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI
import Combine

struct SettingsView: View {
    
    @ObservedObject var model = SettingsViewModel()
    @EnvironmentObject var auth: AuthState
    @Environment(\.presentationMode) var pres
    
    var logoutButton: some View {
        Button(action: {
            self.model.logout { success in
                if success {
                    self.auth.isLoggedIn = false
                    self.pres.wrappedValue.dismiss()
                }
            }
        }) {
            Text("Log out").frame(maxWidth: .infinity, alignment: .center).accentColor(.red)
        }
    }
    
    var tempUnitPicker: some View {
        HStack {
            Text("Temperature")
            Spacer()
            Picker("Temp Unit:", selection: $model.tempUnitIsC) {
                Text("℃").tag(true)
                Text("℉").tag(false)
            }.pickerStyle(SegmentedPickerStyle()).frame(maxWidth: 120)
        }
    }
    
    var version: some View {
        HStack {
            Text("Version")
            Spacer()
            Text(model.version)
        }
    }
    
    var onboardingButton: some View {
        NavigationLink(destination: OnboardingView().environmentObject(ContentViewModel())) {
            Text("Run intro again")
        }
    }
    
    var emailFeedbackButton: some View {
        NavigationButtonLink(title: "Email feedback") {
            self.model.emailFeedback()
        }
    }
    
    var changeAppIcon: some View {
        NavigationLink(destination: ChangeAppIconView()) {
            Text("Change your wheels")
        }
    }
    
    var body: some View {
        ZStack {
            List {
                Section(header: Text("Unit settings")) {
                    tempUnitPicker
                }.modifier(AddLines())
                Section {
                    if UIApplication.shared.supportsAlternateIcons {
                        changeAppIcon
                    }
                    onboardingButton
                    emailFeedbackButton
                    version
                }.modifier(AddLines())
                Section {
                    logoutButton
                }.modifier(AddLines())
                }.listStyle(GroupedListStyle())
                .background(Color(UIColor.systemGroupedBackground))
            if model.isLoggingOut {
                LoadingView(label: "Logging out...")
            }
        }.navigationBarTitle("Settings")
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
