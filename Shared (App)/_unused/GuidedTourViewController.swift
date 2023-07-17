//
//  GuidedTourViewController.swift
//  Othent
//
//  Created by 7i7o on 05/07/2023.
//

import UIKit

class GuidedTourViewController: UIViewController {
    let logo: UIImage = UIImage(named: "logo")!
    let images: [UIImage] = [
        UIImage(named: "tour1")!,
        UIImage(named: "tour2")!,
        UIImage(named: "tour3")!,
        UIImage(named: "tour4")!,
        UIImage(named: "tour5")!,
        UIImage(named: "tour6")!
    ]
    let bgImages: [UIImage] = [
        UIImage(named: "bgCircles")!,
        UIImage(named: "bgDots")!,
        UIImage(named: "bgDots")!,
        UIImage(named: "bgCircles")!,
        UIImage(named: "bgDots")!,
        UIImage(named: "bgCircles")!
    ]
    let stepImages: [UIImage] = [
        UIImage(named: "steps1")!,
        UIImage(named: "steps2")!,
        UIImage(named: "steps3")!,
        UIImage(named: "steps4")!,
        UIImage(named: "steps5")!,
        UIImage(named: "steps6")!
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
    var currentIndex: Int = 0
    
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
    
    lazy var subtitleFont: UIFont = {
        guard let customFont = UIFont(name: "DMSans-Regular", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "DMSans-Regular" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        return customFont
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let arrowImage = UIImage(named: "arrow-narrow-right-blue")
        let arrowAttachment = NSTextAttachment()
        arrowAttachment.image = arrowImage
        arrowAttachment.bounds = CGRect(x: 0, y: -6, width: arrowImage?.size.width ?? 0, height: arrowImage?.size.height ?? 0)
        let attributedTitle = NSMutableAttributedString(string: "Skip ")
        attributedTitle.append(NSAttributedString(attachment: arrowAttachment))
        button.setAttributedTitle(attributedTitle, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.titleLabel?.font = titleFont.withSize(16)
        button.tintColor = UIColor(.primary)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        let arrowImage = UIImage(named: "arrow-narrow-right")
        let arrowAttachment = NSTextAttachment()
        arrowAttachment.image = arrowImage
        arrowAttachment.bounds = CGRect(x: 0, y: -6, width: arrowImage?.size.width ?? 0, height: arrowImage?.size.height ?? 0)
        let attributedTitle = NSMutableAttributedString(string: "Continue ")
        attributedTitle.append(NSAttributedString(attachment: arrowAttachment))
        button.setAttributedTitle(attributedTitle, for: .normal)
        // Style Button
        button.backgroundColor = UIColor(.primary)
        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.titleLabel?.font = titleFont.withSize(16)
        button.layer.cornerRadius = 8
        button.contentHorizontalAlignment = .center // Center aligns the text horizontally
        button.contentVerticalAlignment = .center // Center aligns the text vertically
        // End Style Button
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var logoView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .topLeft
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(.primary)
        label.font = titleFont.withSize(28)
        label.textAlignment = NSTextAlignment.center
        label.preferredMaxLayoutWidth = 320
        label.numberOfLines = 0
        return label
    }()
    
    lazy var subtitleView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = subtitleFont.withSize(18)
        label.preferredMaxLayoutWidth = 320
        label.numberOfLines = 0
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var stepsView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .topLeft
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        showImage(at: currentIndex)
    }
    
    func setupViews() {
        view.addSubview(backgroundView)
        view.addSubview(backgroundImageView)
        view.addSubview(logoView)
        view.addSubview(closeButton)
        view.addSubview(titleView)
        view.addSubview(subtitleView)
        view.addSubview(stepsView)
        view.addSubview(nextButton)
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),

            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.centerYAnchor.constraint(equalTo: logoView.topAnchor, constant: logoView.center.y),

            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleView.topAnchor.constraint(equalTo: logoView.topAnchor, constant: logoView.frame.height + 20),

            subtitleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16),

            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            nextButton.heightAnchor.constraint(equalToConstant: 50),

            stepsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stepsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),

            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: stepsView.topAnchor, constant: -16),
            imageView.topAnchor.constraint(greaterThanOrEqualTo: subtitleView.bottomAnchor, constant: 30),
        ])
    }
    
    func showImage(at index: Int) {
        guard index >= 0 && index < images.count else {
            return
        }
        
        backgroundImageView.image = bgImages[index]
        titleView.text = titles[index]
        subtitleView.text = subtitles[index]
        imageView.image = images[index]
        stepsView.image = stepImages[index]
    }
    
    @objc func nextButtonTapped() {
        if (currentIndex < images.count - 1) {
            currentIndex += 1
            showImage(at: currentIndex)
            if (currentIndex == images.count - 1) {
                nextButton.setAttributedTitle(nil, for: .normal)
                nextButton.setTitle("Open Safari", for: .normal)
            }
        } else {
            closeButtonTapped()
            if let url = URL(string: "https://oth-upload.vercel.app") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

