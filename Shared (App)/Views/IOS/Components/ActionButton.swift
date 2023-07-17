//
//  ActionButton.swift
//  othent
//
//  Created by 7i7o on 16/07/2023.
//  Copyright © 2023 communitylabs. All rights reserved.
//

import SwiftUI

struct ActionButton<Content: View>: View {
    var action: () -> Void
    @ViewBuilder var content: Content
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                content
                Spacer()
            }.font(Font.custom("DMSans-Bold", size: 18))
        }
        .frame(height: 50)
        .foregroundColor(.white)
        .background(Color.accentColor)
        .cornerRadius(10)
        .padding(.horizontal, 25)
        .padding(.vertical, 10)
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ActionButton(action: {}, content: {
                Text("Continue")
                Image(systemName:"arrow.right")
            })
            Spacer().frame(height: 10)
            ActionButton(action: {}, content: {Text("Open Safari")})
        }
    }
}
