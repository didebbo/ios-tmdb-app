//
//  ItemDataInfoView.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 22/02/25.
//

import Stevia

class ItemDataInfoView: UIView {
    
    struct Data {
        let saved: Bool
        let watchTime: Int
        let like: Int
        
        var heartImageString: String { saved ? "heart.fill" : "heart" }
    }
    
    private var data: Data?
    
    private lazy var heartIcon: UIImageView = {
        let heartIcon = UIImageView()
        heartIcon.tintColor = UIColor.systemRed
        return heartIcon
    }()
    
    private lazy var watchIcon: UIImageView = {
        let watchIcon = UIImageView()
        watchIcon.image = UIImage(systemName: "eye.fill")
        watchIcon.tintColor = UIColor(resource: .primary)
        return watchIcon
    }()
    
    private lazy var likeIcon: UIImageView = {
        let likeIcon = UIImageView()
        likeIcon.image = UIImage(systemName: "hand.thumbsup.fill")
        likeIcon.tintColor = UIColor(resource: .primary)
        return likeIcon
    }()
    
    func configureData(with data: Data) {
        self.data = data
        heartIcon.image = UIImage(systemName: data.heartImageString)
    }
    
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
