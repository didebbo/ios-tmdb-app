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
    
    private lazy var watchIconView: UIView = {
        let view = UIView()
        view.subviews(watchIcon, watchIconLabel)
        view.layout {
            0
            |-(>=0)--watchIcon--(>=0)-|
            0
            |-0--watchIconLabel--0-|
            0
        }
        watchIcon.centerHorizontally()
        return view
    }()
    
    private lazy var watchIcon: UIImageView = {
        let watchIcon = UIImageView()
        watchIcon.image = UIImage(systemName: "eye.fill")
        watchIcon.tintColor = UIColor(resource: .primary)
        return watchIcon
    }()
    
    private lazy var watchIconLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 9, weight: .bold)
        label.textColor = UIColor(resource: .primary)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var likeIconView: UIView = {
        let view = UIView()
        view.subviews(likeIcon, likeIconLabel)
        view.layout {
            0
            |-(>=0)--likeIcon--(>=0)-|
            0
            |-0--likeIconLabel--0-|
            0
        }
        likeIcon.centerHorizontally()
        return view
    }()
    
    private lazy var likeIcon: UIImageView = {
        let likeIcon = UIImageView()
        likeIcon.image = UIImage(systemName: "hand.thumbsup.fill")
        likeIcon.tintColor = UIColor(resource: .primary)
        return likeIcon
    }()
    
    private lazy var likeIconLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 9, weight: .bold)
        label.textColor = UIColor(resource: .primary)
        label.textAlignment = .center
        return label
    }()
    
    func configureData(with data: Data) {
        self.data = data
        heartIcon.image = UIImage(systemName: data.heartImageString)
        watchIconLabel.text = String(data.watchTime)
        likeIconLabel.text = String(data.like)
    }
    
    private func configureLayout() {
        subviews(heartIcon, watchIconView, likeIconView)
        layout {
            0
            |-0--heartIcon--(>=10)--watchIconView--10--likeIconView--0-|
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
