//
//  OnboardingView.swift
//  Controls for Tesla Purchases
//
//  Created by Luke Allen on 2/19/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.presentationMode) var pres
    @EnvironmentObject var model: ContentViewModel
    
    var buttonBackground: some View {
        RoundedRectangle(cornerRadius: 7).fill(Color.red)
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)
            VStack {
                Text("Welcome!").font(Font.system(size: 52)).fontWeight(.black).frame(maxWidth: .infinity, alignment: .leading).padding(.vertical)
                Text("Controls for Tesla was built to allow easy-access actions from the watch.\n\nOf course those actions are available on the iPhone app as well, but I hope you enjoy the convenience of the watch app, thanks for downloading!").font(Font.system(size: 20)).fontWeight(.medium).multilineTextAlignment(.leading)
                Spacer()
                VStack {
                    Text("NOTE").font(.caption).fontWeight(.bold).padding(.top)
                    Text("While the app is free to download and you can login, none of the controls will be activated until you become a premium member. If you choose the monthly subscription, you'll enjoy a free month trial during which you can cancel anytime 👍🏼").padding()
                }.background(Color(UIColor.systemGray5))
                Spacer()
                Spacer()
                Button(action: {
                    self.pres.wrappedValue.dismiss()
                }) {
                    ZStack {
                        buttonBackground
                        Text("Continue").fontWeight(.medium).foregroundColor(Color.white)
                    }
                }.frame(maxWidth: .infinity, maxHeight: 50.0)
            }.padding()
        }.onAppear {
            self.model.setOboarded(true)
        }
        
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView().environmentObject(ContentViewModel()).environment(\.colorScheme, .dark)
    }
}
