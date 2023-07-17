//
//  SubTitle.swift
//  othent
//
//  Created by 7i7o on 16/07/2023.
//  Copyright © 2023 communitylabs. All rights reserved.
//

import SwiftUI

struct SubTitle: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.custom("DMSans-Regular", size: 18))
            .font(.title)
            .padding()
    }
}

struct SubTitle_Previews: PreviewProvider {
    static var previews: some View {
        SubTitle(text: "Sign in to the Permaweb on the go, all through an extension")
    }
}
