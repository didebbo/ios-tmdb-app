//
//  Detail.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 18/02/25.
//

import Stevia
import SnapKit

class Detail: BaseViewController {
    
    private var item: Item
    
    private lazy var safeViewContainer: UIView = {
        let view = UIView()
        
        view.subviews(coverView, descriptionView)
        view.layout {
            0
            |-0--coverView--0-|
            0
            |-0--descriptionView--0-|
            0
        }
        coverView.Height == view.Height / 2
        
        return view
    }()
    
    private lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.subviews(coverImageView)
        view.layout {
            0
            |-0--coverImageView--0-|
            0
        }
        return view
    }()
    
    private lazy var coverImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.alpha = 0
        return view
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.plain())
        button.backgroundColor = UIColor(resource: .primary)
        button.addTarget(self, action: #selector(tapOnSave), for: .touchUpInside)
        button.layer.cornerRadius = 2.5
        button.isHidden = true
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.subviews(saveButton, titleLabel, descriptionLabel)
        view.layout {
            20
            |-10--saveButton--(>=10)-|
            20
            titleLabel
            10
            descriptionLabel
            0
        }
        
        titleLabel.Width == view.Width - 20
        titleLabel.centerHorizontally()
        
        descriptionLabel.Width == view.Width - 20
        descriptionLabel.centerHorizontally()
        
        return view
    }()
    
    private func configureLayout() {
        view.addSubview(safeViewContainer)
        safeViewContainer.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureData() {
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        guard let coverImageData = item.coverImageData else { return }
        coverImageView.image = UIImage(data: coverImageData)
        UIView.animate(withDuration: 0.5) { [weak self] in guard let self else { return }
            coverImageView.alpha = 1
        }
        
        var savedResult: UnWrappedResult<Bool> {
            switch item.type {
            case .movie:
                DataProvider.shared.hasSavedMovie(item.id).result
            case .tvShow:
                DataProvider.shared.hasSavedTvShow(item.id).result
            }
        }
        
        if let saved = savedResult.data {
            let saveButtonAttributedString = NSAttributedString(string: saved ? "DELETE" : "SAVE", attributes: [
                .font: UIFont.systemFont(ofSize: 17, weight: .bold),
                .foregroundColor: UIColor(resource: .tertiary)
            ])
            saveButton.isHidden = false
            saveButton.setAttributedTitle(saveButtonAttributedString, for: .normal)
        }
    }
    
    private func updateWatchTime() {
        let itemDataInfoResult = DataProvider.shared.getItemDataInfo(from: item).result
        if var data = itemDataInfoResult.data {
            data.watchTime += 1
            if let error = DataProvider.shared.saveItemDataInfo(data).result.error {
                let vc = CoreAlertController(title: "Attenzione", message: error.description, preferredStyle: .alert)
                present(vc, animated: true)
            }
        }
    }
    
    @objc private func tapOnSave() {
        let saveMovieResult = DataProvider.shared.saveMovie(item).result
        if let error = saveMovieResult.error {
            let vc = CoreAlertController(title: "Attenzione", message: error.description, preferredStyle: .alert)
            present(vc, animated: true)
        }
        if let saved = saveMovieResult.data {
            if var itemDataInfo = DataProvider.shared.getItemDataInfo(from: item).result.data {
                itemDataInfo.saved = saved
                let _ = DataProvider.shared.saveItemDataInfo(itemDataInfo)
            }
            configureData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateWatchTime()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureLayout()
        configureData()
    }
    
    init(of item: Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
