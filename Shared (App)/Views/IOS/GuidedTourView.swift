//
//  GuidedTourView.swift
//  othent
//
//  Created by 7i7o on 10/07/2023.
//  Copyright © 2023 communitylabs. All rights reserved.
//

import SwiftUI

let whiteArrow: String = "arrow-narrow-right"
let blueArrow: String = "arrow-narrow-right-blue"

let backgroundImages: [String] = [
    "bgCircles",
    "bgDots",
    "bgDots",
    "bgCircles",
    "bgDots",
    "bgCircles",
    "bgCircles",
]
let titles: [String] = [
    "Experience Arweave on mobile with Othent",
    "Get Started",
    "Get Started","Jump In",
    "Get Started",
    "Manage with ease",
    "Upload files"
]
let subtitles: [String] = [
    "Sign in to the Permaweb on the go, all through an extension",
    "Enable Othent Safari extension",
    "Review permissions",
    "Interact with your favorite Arweave dApps",
    "Sign up to Othent",
    "View recent transactions and an overview of your account, through the easy-to-use extension",
    "Easily upload files in 2 steps from the extension and keep them forever in the Permaweb.",
]

struct GuidedTourView: View {
    let dismissAction: () -> Void
    let homeURL: String
    
    @State private var currentPage = 0
    
    func setCurrentPage(page: Int) {
        self.currentPage = page
    }
    
    func nextView() {
        self.currentPage = min(self.currentPage + 1, titles.count - 1)
    }

    func prevView() {
        self.currentPage = max(self.currentPage - 1, 0)
    }

    var body: some View {
        @Environment(\.openURL) var openURL
        
        GeometryReader { metrics in
            VStack {
                Header(dismissAction: dismissAction)
                    .padding(.top, 20)
                    .padding(.horizontal, 10)
                Title(text: titles[currentPage])
                SubTitle(text: subtitles[currentPage])
                ImageView(currentPage: currentPage)
                DotsPagination(total: titles.count, current: currentPage, action: setCurrentPage)
                if self.currentPage < titles.count - 1 {
                    ActionButton(action:nextView, content: {
                        Text("Continue")
                        Image(systemName: "arrow.right")
                    })
                } else {
                    ActionButton(action:{
                        UserDefaults().set(true, forKey: "guidedTourCompleted")
                        dismissAction()
                        openURL(URL(string: homeURL)!)
                    }, content: {Text("Open Safari")})
                }
            }
            .font(Font.custom("DMSans-regular", size: 18))
            .background(
                VStack {
                    Spacer()
                    Image(backgroundImages[currentPage])
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                }
            )
            .frame(height: metrics.size.height)
            .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onEnded { value in
                let horizontalAmount = value.translation.width
                let verticalAmount = value.translation.height
                
                if abs(horizontalAmount) > abs(verticalAmount) {
                    if horizontalAmount < 0 {
                        nextView()
                    } else {
                        prevView()
                    }
                } else {
                    if !(verticalAmount < 0) {
                        dismissAction()
                    }
                }
            })
        }
    }
}

struct ImageView: View {
    let currentPage: Int
    let pageOneTexts: [[String]] = [["Simple","Setup once, use forever."],["Secure","Personal data encrypted end-to-end."],["Seamless","Log in with a single click."]]
    
    var body: some View {
        VStack {
            if currentPage == 0 {
                Spacer()
                HStack{
                    LazyVGrid(columns: [GridItem(.flexible(minimum:32,maximum:40), alignment: .trailing), GridItem(.flexible(minimum:50,maximum:155), alignment: .leading)], spacing: 20) {
                        ForEach(1..<4) { row in
                            Image("tour1"+row.formatted())
                                .padding(.trailing, 40)
                            VStack(alignment: .leading) {
                                Text(pageOneTexts[row-1][0])
                                    .font(.custom("DMSans-Regular", size: 24))
                                    .multilineTextAlignment(.leading)
                                Text(pageOneTexts[row-1][1])
                                    .font(.custom("DMSans-Regular", size: 14))
                                    .multilineTextAlignment(.leading)
                            }
                            .multilineTextAlignment(.leading)
                        }
                    }
                    .frame(maxWidth: 250)
                    .padding(.leading, 50)
                }
                Spacer()

            } else if currentPage == 3 {
                VStack{
                    HStack{
                        ForEach(1..<4) { row in
                            Image("tour4"+row.formatted())
                                .padding(.horizontal, 10)
                                .shadow(color: Color(CGColor(red: 0, green: 0, blue: 0, alpha: 0.2)), radius: 12, x: 2, y: 3)
                        }
                    }
                    Image("tour4")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                                            .padding(10)
                        .shadow(color: Color(CGColor(red: 0, green: 0, blue: 0, alpha: 0.2)), radius: 12, x: 2, y: 3)
                }
            } else {
                Image("tour"+(currentPage+1).formatted())
                    .resizable(resizingMode: .stretch)
                    .scaledToFit()
                    .padding(.horizontal, 20)
                    .aspectRatio(contentMode: .fit)
                    .shadow(color: Color(CGColor(red: 0, green: 0, blue: 0, alpha: 0.2)), radius: 12, x: 2, y: 3)
            }
            Spacer()
        }
    }
}


struct GuidedTourView_Previews: PreviewProvider {
    static var previews: some View {
        GuidedTourView(dismissAction: {}, homeURL: "https://oth-upload.vercel.app")
    }
}
