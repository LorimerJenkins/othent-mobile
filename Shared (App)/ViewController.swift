//
//  ViewController.swift
//  Shared (App)
//
//  Created by 7i7o on 04/07/2023.
//

import WebKit

#if os(iOS)
import UIKit
import SwiftUI
typealias PlatformViewController = UIViewController
#elseif os(macOS)
import Cocoa
import SafariServices
typealias PlatformViewController = NSViewController
#endif

let extensionBundleIdentifier = "com.communitylabs.Othent.Extension"

class ViewController: PlatformViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    var guidedTourCompleted = UserDefaults().bool(forKey: "guidedTourCompleted")
    @IBOutlet var webView: WKWebView!
    
    func startGuidedTour() {
        let guidedTourVC = GuidedTourVC()
        guidedTourVC.modalPresentationStyle = .fullScreen // Set the presentation style to full screen
        self.present(guidedTourVC, animated: true, completion: nil)
    }
    
    func setupIOSView() {
        
        let vc = UIHostingController(rootView: IOSView(homeURL: "https://oth-upload.vercel.app", openSettingsAction: openSafariSettings, openGuidedTourAction: startGuidedTour, guidedTourCompleted: guidedTourCompleted))
        let swiftUIView = vc.view!
        swiftUIView.translatesAutoresizingMaskIntoConstraints = false

        addChild(vc)
        self.webView.addSubview(swiftUIView)
        
        NSLayoutConstraint.activate([
            swiftUIView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            swiftUIView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            swiftUIView.topAnchor.constraint(equalTo: view.topAnchor),
            swiftUIView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.webView.navigationDelegate = self
        
#if os(iOS)
        self.webView.scrollView.isScrollEnabled = false
        
        setupIOSView()
#endif
        
        self.webView.configuration.userContentController.add(self, name: "controller")
        
        self.webView.loadFileURL(Bundle.main.url(forResource: "Main", withExtension: "html")!, allowingReadAccessTo: Bundle.main.resourceURL!)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
#if os(iOS)
        webView.evaluateJavaScript("show('ios')")
#elseif os(macOS)
        webView.evaluateJavaScript("show('mac')")

        SFSafariExtensionManager.getStateOfSafariExtension(withIdentifier: extensionBundleIdentifier) { (state, error) in
            guard let state = state, error == nil else {
                // Insert code to inform the user that something went wrong.
                return
            }

            DispatchQueue.main.async {
                if #available(macOS 13, *) {
                    webView.evaluateJavaScript("show('mac', \(state.isEnabled), true)")
                } else {
                    webView.evaluateJavaScript("show('mac', \(state.isEnabled), false)")
                }
            }
        }
#endif
    }
    
    func openSafariSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.body as! String != "open-preferences") {
            return;
        }
#if os(iOS)
        openSafariSettings()
#elseif os(macOS)
        
        SFSafariApplication.showPreferencesForExtension(withIdentifier: extensionBundleIdentifier) { error in
            guard error == nil else {
                // Insert code to inform the user that something went wrong.
                return
            }
            
            DispatchQueue.main.async {
                NSApplication.shared.terminate(nil)
            }
        }
#endif
    }
    
}
