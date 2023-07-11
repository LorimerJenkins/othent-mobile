//
//  GuidedTourViewController.swift
//  Othent
//
//  Created by 7i7o on 05/07/2023.
//

import UIKit
import SwiftUI

class GuidedTourVC: UIViewController {
    
    @objc func dismissTour() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        
        let vc = UIHostingController(rootView: GuidedTourView(dismissAction: dismissTour))
        
        let swiftuiView = vc.view!
        swiftuiView.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(vc)
        view.addSubview(swiftuiView)
        
        NSLayoutConstraint.activate([
            swiftuiView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            swiftuiView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            swiftuiView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            swiftuiView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
