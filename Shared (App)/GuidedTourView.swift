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
]
let titles: [String] = [
    "Experience Arweave on mobile with Othent",
    "Get Started",
    "Get Started","Jump In",
    "Get Started",
    "Manage with ease"
]
let subtitles: [String] = [
    "Sign in to the Permaweb on the go, all through an extension",
    "Enable Othent Safari extension",
    "Review permissions",
    "Interact with your favorite Arweave dApps",
    "Sign up to Othent",
    "View recent transactions and an overview of your account, through the easy-to-use app",
]

struct GuidedTourView: View {
    let dismissAction: () -> Void
    
    @State private var currentPage = 0
    
    func setCurrentPage(page: Int) {
        self.currentPage = page
    }
    
    var body: some View {
        @Environment(\.openURL) var openURL
        
        GeometryReader { metrics in
            VStack {
                HeaderView(logo: "logo", dismissAction: dismissAction)
                    .padding(.top, 20)
                    .padding(.horizontal, 15)
                TitleView(title: titles[currentPage], subtitle: subtitles[currentPage])
                ImageView(currentPage: currentPage)
                DotsView(currentPage: currentPage, action: setCurrentPage)
                ContinueButton(currentPage: currentPage, action: {
                    if self.currentPage < titles.count - 1 {
                        self.currentPage += 1
                    } else {
                        dismissAction()
                        openURL(URL(string: "https://oth-upload.vercel.app")!)
                    }
                })
                .background(Color.accentColor)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
            }
            .font(Font.custom("DMSans-regular", size: 18))
            .background(
                VStack {
                    Spacer()
                    Image(backgroundImages[currentPage])
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                    //                        .frame(width: .infinity)
                }
            )
            .swipeActions(edge: .leading ,content: {
                self
            })
            .frame(height: metrics.size.height)
        }}
}

struct HeaderView: View {
    let logo: String
    let dismissAction: () -> Void
    
    var body: some View {
        ZStack{
            HStack {
                Spacer()
            }
            HStack {
                Image(logo)
            }
            HStack {
                Spacer()
                SkipButton(action: dismissAction)
            }
        }
    }
}

struct SkipButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text("Skip")
                    .font(.custom("DMSans-Medium", size: 18))
                Image(blueArrow)
            }
        }
    }
}

struct TitleView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(Font.custom("DMSans-Bold", size: 28))
                .foregroundColor(Color.accentColor)
                .multilineTextAlignment(.center)
                .padding(.bottom, 12)
            Text(subtitle)
                .font(.custom("DMSans-Regular", size: 18))
        }
        .font(.title)
        .padding()
    }
}


struct DotsView: View {
    let currentPage: Int
    let action: (Int) -> Void
    
    var body: some View {
        HStack {
            let count = titles.count
            ForEach(0..<count,  id: \.self) { index in
                Button(action: {action(index)}) {
                    Circle()
                        .foregroundColor(index == currentPage ? .accentColor : .secondary)
                        .frame(width: 8, height: 8)
                }.padding(.horizontal, 4)
            }
        }.padding(.bottom,5)
    }
}

struct ContinueButton: View {
    let currentPage: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                if currentPage < titles.count - 1 {
                    Text("Continue")
                    Image(whiteArrow)
                } else {
                    Text("Open Safari")
                }
                Spacer()
            }.font(Font.custom("DMSans-Medium", size: 18))
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 10)
        .cornerRadius(20)
    }
}

struct ImageView: View {
    let currentPage: Int
    let pageOneTexts: [String] = ["Simple setup","Secure Infrastructure","Decentralized architechture"]
    
    var body: some View {
        VStack {
            if currentPage == 0 {
                HStack{
                    Spacer()
                    LazyVGrid(columns: [GridItem(.flexible(minimum:32,maximum:40), alignment: .trailing), GridItem(alignment: .leading)], spacing: 20) {
                        ForEach(1..<4) { row in
                            Image("tour1"+row.formatted())
                                .padding(.trailing, 40)
                            Text(pageOneTexts[row-1])
                                .font(.custom("DMSans-Regular", size: 24))
                        }
                    }
                    .frame(maxWidth: 250)
                    .padding(.leading, 50)
                    Spacer()
                }.padding(.top, 40)

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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GuidedTourView(dismissAction: {})
    }
}
