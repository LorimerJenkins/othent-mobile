//
//  Title.swift
//  othent
//
//  Created by 7i7o on 16/07/2023.
//  Copyright © 2023 communitylabs. All rights reserved.
//

import SwiftUI

struct Title: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(Font.custom("DMSans-Bold", size: 28))
            .foregroundColor(Color.accentColor)
            .multilineTextAlignment(.center)
            .padding(.bottom, 12)
            .font(.title)
    }
}

struct Title_Previews: PreviewProvider {
    static var previews: some View {
        Title(text: "Experience Arweave on mobile with Othent")
    }
}
