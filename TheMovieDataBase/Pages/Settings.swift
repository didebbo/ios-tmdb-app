//
//  Settings.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 27/02/25.
//

import Stevia
import SnapKit

class Settings: BaseViewController {
    
    private let avatarImageSize: CGFloat = 60
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.subviews(avatarImageView, ownerView, externalLinkView)
        view.layout {
            0
            |-0--avatarImageView--10--ownerView--0-|
            20
            externalLinkView--0-|
            (>=0)
        }
        
        externalLinkView.Leading == avatarImageView.CenterX / 2
        
        avatarImageView.Width == avatarImageSize
        avatarImageView.heightEqualsWidth()
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Credits"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .ownerAvatar)
        imageView.layer.cornerRadius = avatarImageSize / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var ownerView: UIView = {
        let view = UIView()
        view.subviews(ownerLabel, roleLabel)
        view.layout {
            0
            |-0--ownerLabel--0-|
            |-2--roleLabel--0-|
            0
        }
        return view
    }()
    
    private lazy var ownerLabel: UILabel = {
        let label = UILabel()
        label.text = "Gianluca Napoletano"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var roleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mobile Developer"
        label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        return label
    }()
    
    private lazy var externalLinkView: UIView = {
        let view = UIView()
        
        let title = UILabel()
        title.text = "Links"
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        view.subviews(title, linkedinView, gitHubView, mailToView)
        view.layout {
            0
            |-0--title--0-|
            10
            |-0--linkedinView--0-|
            10
            |-0--gitHubView--0-|
            10
            |-0--mailToView--0-|
            0
        }
        
        return view
    }()
    
    private lazy var linkedinView: UIView = {
        let view = UIView()
        
        let icon = UIImageView()
        icon.image = UIImage(resource: .linkedinIcon)
        
        let attributedString = NSMutableAttributedString(string: "linkedin.com/in/gianlucanapoletano/")
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12, weight: .medium), range: NSRange(location: 0, length: attributedString.length))
        
        let textLabel = UILabel()
        textLabel.text = "LinkedIn:"
        textLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        let linkLabel = UILabel()
        linkLabel.attributedText = attributedString
        linkLabel.textColor = UIColor(resource: .secondary)
        
        view.subviews(icon, textLabel, linkLabel)
        view.layout {
            0
            |-0--icon--5--textLabel--5--linkLabel--(>=0)-|
            0
        }
        icon.Width == 18
        icon.heightEqualsWidth()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openURL))
        tapGesture.accessibilityValue = "https://www.linkedin.com/in/gianlucanapoletano/"
        
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var gitHubView: UIView = {
        let view = UIView()
        
        let icon = UIImageView()
        icon.image = UIImage(resource: .gitHubIcon)
        
        let attributedString = NSMutableAttributedString(string: "github.com/didebbo")
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12, weight: .medium), range: NSRange(location: 0, length: attributedString.length))
        
        let textLabel = UILabel()
        textLabel.text = "GitHub:"
        textLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        let linkLabel = UILabel()
        linkLabel.attributedText = attributedString
        linkLabel.textColor = UIColor(resource: .secondary)
        
        view.subviews(icon, textLabel, linkLabel)
        view.layout {
            0
            |-0--icon--5--textLabel--5--linkLabel--(>=0)-|
            0
        }
        icon.Width == 18
        icon.heightEqualsWidth()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openURL))
        tapGesture.accessibilityValue = "https://github.com/didebbo"
        
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var mailToView: UIView = {
        let view = UIView()
        
        let icon = UIImageView()
        icon.image = UIImage(systemName: "envelope.fill")
        icon.tintColor = UIColor(resource: .primary)
        
        let attributedString = NSMutableAttributedString(string: "gianluca.napoletano.93@gmail.com")
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12, weight: .medium), range: NSRange(location: 0, length: attributedString.length))
        
        let textLabel = UILabel()
        textLabel.text = "Email:"
        textLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        let linkLabel = UILabel()
        linkLabel.attributedText = attributedString
        linkLabel.textColor = UIColor(resource: .secondary)
        
        view.subviews(icon, textLabel, linkLabel)
        view.layout {
            0
            |-0--icon--5--textLabel--5--linkLabel--(>=0)-|
            0
        }
        icon.Width == 18
        icon.heightEqualsWidth()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openURL))
        tapGesture.accessibilityValue = "mailto:gianluca.napoletano.93@gmail.com"
        
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleCloseIcon()
        configureLayout()
    }
    
    private func configureLayout() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    @objc private func openURL(_ sender: UITapGestureRecognizer) {
        guard let accessibilityValue = sender.accessibilityValue else { return }
        if let url = URL(string: accessibilityValue) {
            UIApplication.shared.open(url)
        }
    }
}
