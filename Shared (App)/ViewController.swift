//
//  ViewController.swift
//  Shared (App)
//
//  Created by 7i7o on 04/07/2023.
//

import WebKit

#if os(iOS)
import UIKit
typealias PlatformViewController = UIViewController
#elseif os(macOS)
import Cocoa
import SafariServices
typealias PlatformViewController = NSViewController
#endif

let extensionBundleIdentifier = "com.yourCompany.Othent.Extension"

extension UIColor {
    convenience init(hex: String) {
        var hexValue = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexValue.hasPrefix("#") {
            hexValue.remove(at: hexValue.startIndex)
        }
        var rgbValue: UInt64 = 0
        Scanner(string: hexValue).scanHexInt64(&rgbValue)
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

class ViewController: PlatformViewController, WKNavigationDelegate, WKScriptMessageHandler {

    @IBOutlet var webView: WKWebView!

    lazy var titleFont: UIFont = {
        guard let customFont = UIFont(name: "DMSans-Bold", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "DMSans-Medium" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        return customFont
    }()

    // Add Guided Tour
    lazy var walkthroughButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Guided Tour", for: .normal)
        // Style Button
        button.backgroundColor = UIColor(hex: "#2375ef")
        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.titleLabel?.font = titleFont.withSize(16)
        button.layer.cornerRadius = 8
        button.contentHorizontalAlignment = .center // Center aligns the text horizontally
        button.contentVerticalAlignment = .center // Center aligns the text vertically
        // End Style Button
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startWalkthrough), for: .touchUpInside)
        return button
    }()
    
    @objc func startWalkthrough() {
        let guidedTourVC = GuidedTourVC()
        guidedTourVC.modalPresentationStyle = .fullScreen // Set the presentation style to full screen
        self.present(guidedTourVC, animated: true, completion: nil)
    }
    
    func setupGuidedTourView() {
        self.webView.addSubview(walkthroughButton)
        
        NSLayoutConstraint.activate([
            walkthroughButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            walkthroughButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            walkthroughButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            walkthroughButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    // End of added Guided Tour

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.navigationDelegate = self

#if os(iOS)
        self.webView.scrollView.isScrollEnabled = false
        setupGuidedTourView()
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
//        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
//            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
//        }
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
