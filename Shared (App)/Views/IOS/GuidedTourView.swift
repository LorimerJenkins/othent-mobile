//
//  GuidedTourView.swift
//  othent
//
//  Created by 7i7o on 10/07/2023.
//  Copyright © 2023 communitylabs. All rights reserved.
//

import SwiftUI

struct GuidedTourView: View {
    let dismissAction: () -> Void
    let homeURL: String

    @State private var currentScreen = 0
    @State private var offsetX: CGFloat = 0
    private let screenSize = UIScreen.main.bounds.size
    
    private let SCREEN_COUNT = 8

    func setCurrentScreen(page: Int) {
        if (page >= 0 && page < SCREEN_COUNT) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.currentScreen = page
                    offsetX = -CGFloat(page) * screenSize.width
                }
        }
    }
    
    func createGuidedTourScreen(screenNum: Int) -> GuidedTourScreen {
        return GuidedTourScreen(dismissAction: dismissAction, homeURL: homeURL, currentScreen: screenNum, setCurrentScreen: setCurrentScreen)
    }

    var body: some View {
        VStack {
//            Text(self.currentScreen.description)
            // Swipeable content
            HStack(spacing: 0) {
                ForEach(0..<SCREEN_COUNT, id: \.self) { index in
                    GuidedTourScreenView(screen: createGuidedTourScreen(screenNum: index))
                        .frame(width: screenSize.width)
                }
            }
            .frame(width: screenSize.width, alignment: .leading)
            .offset(x: offsetX)
            .gesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .global)
                    .onEnded { value in
                        let horizontalAmount = value.translation.width
                        let verticalAmount = value.translation.height
                        
                        if abs(horizontalAmount) > abs(verticalAmount) {
                            if horizontalAmount < 0 {
                                setCurrentScreen(page: currentScreen + 1)
                            } else {
                                setCurrentScreen(page: currentScreen - 1)
                            }
                        } else {
                            if !(verticalAmount < 0) {
                                dismissAction()
                            }
                        }
                    }
            )
        }
    }
}


struct GuidedTourView_Previews: PreviewProvider {
    static var previews: some View {
        GuidedTourView(dismissAction: {}, homeURL: "https://oth-upload.vercel.app")
    }
}
