//
//  ContentView.swift
//  Key for Tesla Purchases
//
//  Created by Luke Allen on 2/10/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var authState = AuthState()
    @ObservedObject var viewModel = ContentViewModel()
    var body: some View {
        Group {
            if authState.isLoggedIn || tokenIsGood {
                Group {
                    VehiclesView().environmentObject(authState)
                }
            } else {
                Group {
                    LoginView().environmentObject(authState)
                }
            }
        }.sheet(isPresented: $viewModel.shouldShowOboarding) {
            OnboardingView().environmentObject(self.viewModel)
        }.onAppear {
            Debug.log()
            if SecureData.shouldRefresh {
                Debug.log("Refreshing Token")
                self.viewModel.cancellable = OAuth.refresh()
            }
        }
    }
    
    var tokenIsGood: Bool {
        SecureData.hasValidToken && !SecureData.shouldRefresh
    }
}

struct PurchasesContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
