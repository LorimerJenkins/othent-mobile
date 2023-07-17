//
//  DotsPagination.swift
//  othent
//
//  Created by 7i7o on 16/07/2023.
//  Copyright © 2023 communitylabs. All rights reserved.
//

import SwiftUI

struct DotsPagination: View {
    let total: Int
    let current: Int
    let action: (Int) -> Void
    
    var body: some View {
        HStack {
            let count = total
            ForEach(0..<count,  id: \.self) { index in
                Button(action: {action(index)}) {
                    Circle()
                        .foregroundColor(index == current ? .accentColor : .secondary)
                        .frame(width: 8, height: 8)
                }.padding(.horizontal, 4)
            }
        }.padding(.bottom,5)
    }
}

struct DotsPagination_Previews: PreviewProvider {
    static var previews: some View {
        DotsPagination(total: 6, current: 3, action: {_ in })
    }
}
