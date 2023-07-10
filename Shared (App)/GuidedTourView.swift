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
enum Images: String, CaseIterable {
    case a = "tour1";
    case b = "tour2";
    case c = "tour3";
    case d = "tour4";
    case e = "tour5";
    case f = "tour6";
}
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
    @State private var currentPage = 0
    
    func setCurrentPage(page: Int) {
        self.currentPage = page
    }
    
    var body: some View {
        VStack {
            HeaderView(logo: "logo", skipButtonAction: {})
                .padding(.top, 20)
                .padding(.horizontal, 15)
            TitleView(title: titles[currentPage], subtitle: subtitles[currentPage])
            ImageView(currentPage: currentPage)
            DotsView(currentPage: currentPage, action: setCurrentPage)
            ContinueButton(currentPage: currentPage, action: {
                if self.currentPage < Images.allCases.count - 1 {
                    self.currentPage += 1
                } else {
                    // Go to Safari
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
                    .frame(width: .infinity)
            }
        ).clipped()
    }
}

struct HeaderView: View {
    let logo: String
    let skipButtonAction: () -> Void
    
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
                SkipButton(action: skipButtonAction)
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
                .font(Font.custom("DMSans-Regular", size: 18))
        }
        .font(.title)
        .padding()
    }
}

struct ImageView: View {
    let currentPage: Int
    
    var body: some View {
        VStack {
            Spacer()
            Image(Images.allCases[currentPage].rawValue)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 20)
            Spacer()
        }}
}

struct DotsView: View {
    let currentPage: Int
    let action: (Int) -> Void
    
    var body: some View {
        HStack {
            let count = Images.allCases.count
            ForEach(0..<count,  id: \.self) { index in
                Button(action: {action(index)}) {
                    Circle()
                        .foregroundColor(index == currentPage ? .accentColor : .secondary)
                        .frame(width: 8, height: 8)
                }.padding(.horizontal, 4)
            }
        }.padding(.bottom,16)
    }
}

struct ContinueButton: View {
    let currentPage: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                if currentPage < Images.allCases.count - 1 {
                    Text("Continue")
                    Image(whiteArrow)
                } else {
                    Text("Open Safari")
                }
                Spacer()
            }
        }
        //        .frame(maxWidth: .infinity)
        .padding(.horizontal, 25)
        .padding(.vertical, 10)
        .cornerRadius(20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GuidedTourView()
    }
}
