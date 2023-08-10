//
//  IOSView.swift
//  othent
//
//  Created by 7i7o on 16/07/2023.
//  Copyright © 2023 communitylabs. All rights reserved.
//

import SwiftUI

struct IOSView: View {
    var homeURL: String
    var openSettingsAction: () -> Void
    var openGuidedTourAction: () -> Void
    var guidedTourCompleted: Bool
    
    var body: some View {
        @Environment(\.openURL) var openURL
        VStack {
            Spacer()
            Image("logo")
                .resizable(resizingMode: .stretch)
                .scaledToFit()
                .frame(width: 132)
            if guidedTourCompleted {
                Text("Nothing to see here,")
                    .padding(.top, 40)
                    .padding(.bottom, 3)
                HStack(spacing: 0) {
                    Text("go ")
                    Button(action: {
                        openURL(URL(string: homeURL)!)
                    }, label: {
                        Text("Upload")
                    })
                    Text(" some files")
                }
                Spacer()
                HStack(spacing: 0) {
                    Text("Want to replay the ")
                    Button(action: openGuidedTourAction) {
                        Text("Guided Tour")
                            .font(.custom("DMSans-Bold", size: 18))
                            .foregroundColor(.accentColor)
                    }
                    Text(" instead?")
                }
            } else {
                Text("To enable Othent, open")
                    .padding(.top, 40)
                    .padding(.bottom, 3)
                HStack(spacing: 0) {
                    Button(action: openSettingsAction, label: {
                        Text("Settings")
                    })
                    Text(" > Safari > Extensions")
                }
                Spacer()
                ActionButton(action: openGuidedTourAction, content: {Text("Guided Tour")})
            }
        }.preferredColorScheme(.light)
    }
}

struct IOSView_Previews: PreviewProvider {
    static var previews: some View {
        IOSView(homeURL: "https://oth-upload.vercel.app", openSettingsAction: {}, openGuidedTourAction: {}, guidedTourCompleted: false)
    }
}
