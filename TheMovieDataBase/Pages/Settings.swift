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
            10
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
        title.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        view.subviews(title, linkedinView)
        view.layout {
            0
            |-0--title--0-|
            |-0--linkedinView--0-|
            0
        }
        
        return view
    }()
    
    private lazy var linkedinView: UIView = {
        let view = UIView()
        
        let icon = UIImageView()
        icon.image = UIImage(resource: .linkedinIcon)
        
        let attributedString = NSMutableAttributedString(string: "gianlucanapoletano")
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.font, value: UIFont.italicSystemFont(ofSize: 12), range: NSRange(location: 0, length: attributedString.length))
        
        let label = UILabel()
        label.attributedText = attributedString
        label.textColor = UIColor(resource: .secondary)
        
        view.subviews(icon, label)
        view.layout {
            0
            |-5--icon--5--label--0-|
            0
        }
        icon.Width == 16
        icon.heightEqualsWidth()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openURL))
        tapGesture.accessibilityValue = "https://www.linkedin.com/in/gianlucanapoletano/"
        
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
