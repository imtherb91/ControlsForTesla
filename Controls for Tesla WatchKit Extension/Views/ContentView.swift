//
//  ContentView.swift
//  Key for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/6/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var authState = AuthState()
    @State var cancellable: AnyCancellable?
    
    var body: some View {
        Group {
            if authState.isLoggedIn || tokenIsGood {
                AnyView(VehiclesView().environmentObject(authState))
            } else {
                AnyView(LoginView().environmentObject(authState))
            }
        }.onAppear {
            Debug.log()
            if SecureData.shouldRefresh {
                Debug.log("Refreshing Token")
                self.cancellable = OAuth.refresh()
            }
        }
    }
    
    var tokenIsGood: Bool {
        SecureData.hasValidToken && !SecureData.shouldRefresh
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
