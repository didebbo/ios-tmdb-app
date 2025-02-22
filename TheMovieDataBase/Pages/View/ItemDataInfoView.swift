//
//  ItemDataInfoView.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 22/02/25.
//

import Stevia

class ItemDataInfoView: UIView {
    
    private let itemSize = 10
    
    private lazy var heartIcon: UIImageView = {
        let heartIcon = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: itemSize, height: itemSize)))
        heartIcon.image = UIImage(systemName: "heart.fill")
        heartIcon.tintColor = UIColor.systemRed
        return heartIcon
    }()
    
    private lazy var watchIcon: UIImageView = {
        let watchIcon = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: itemSize, height: itemSize)))
        watchIcon.image = UIImage(systemName: "eye.fill")
        watchIcon.tintColor = UIColor(resource: .primary)
        return watchIcon
    }()
    
    private lazy var likeIcon: UIImageView = {
        let likeIcon = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: itemSize, height: itemSize)))
        likeIcon.image = UIImage(systemName: "hand.thumbsup.fill")
        likeIcon.tintColor = UIColor(resource: .primary)
        return likeIcon
    }()
    
    private func configureLayout() {
        subviews(heartIcon, watchIcon, likeIcon)
        layout {
            0
            |-0--heartIcon--10--watchIcon--10--likeIcon--0-|
            0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
