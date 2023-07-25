//
//  Header.swift
//  othent
//
//  Created by 7i7o on 14/07/2023.
//  Copyright © 2023 communitylabs. All rights reserved.
//

import SwiftUI

struct Header: View {
    let dismissAction: () -> Void

    var body: some View {
        ZStack{
            HStack {
                Spacer()
            }
            HStack {
                Image("logo")
            }
            HStack {
                Spacer()
                Button(action: dismissAction) {
                    HStack {
                        Text("Skip")
                        Label("", systemImage: "arrow.right")
                    }
                }.frame(alignment: .trailing)
            }

        }
        .foregroundColor(.accentColor)
        .font(.custom("DMSans-Bold", size: 18))
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(dismissAction: {})
    }
}
