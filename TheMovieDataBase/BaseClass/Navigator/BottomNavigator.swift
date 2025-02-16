//
//  BottomNavigator.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 15/02/25.
//

import SnapKit

class BottomNavigator: BaseNavigationController {
    
    var destinations: [BottomNavigationBar.Item.Destination] = []
    
    lazy var bottomNavigationBar: BottomNavigationBar = {
        let view = BottomNavigationBar(detstinations: destinations)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.prefersLargeTitles = true
        
        if let destination = destinations.first {
            setViewControllers([destination.viewController], animated: false)
        }
        
        handleBottomNavigationBar()
    }
    
    private func handleBottomNavigationBar() {
        view.addSubview(bottomNavigationBar)
        bottomNavigationBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(BottomNavigationBar.itemHeight)
            make.bottom.equalToSuperview()
        }
    }
}

extension BottomNavigator: BottomNavigationBarDelegate {
    
    func didSelectItemAt(currentIndex: Int, destinationIndex: Int) {
        guard currentIndex != destinationIndex else { return }
        
        guard let currentVC = viewControllers.first else { return }
        let destinationVC = destinations[destinationIndex].viewController
        
        let startDestinationVCTranslationX: CGFloat = currentIndex < destinationIndex ? view.bounds.width : -view.bounds.width
        destinationVC.view.transform = CGAffineTransform(translationX: startDestinationVCTranslationX, y: 0)
        destinationVC.view.alpha = 0
        
        UIView.animate(withDuration: 0.6) { [weak self] in guard let self else { return }
            let currentVCTranslationX: CGFloat = currentIndex < destinationIndex ? -view.bounds.width : view.bounds.width
            currentVC.view.transform = CGAffineTransform(translationX: currentVCTranslationX, y: 0)
        }
        UIView.animate(withDuration: 0.3) {
            currentVC.view.alpha = 0
        } completion: { [weak self] _ in guard let self else { return }
            setViewControllers([destinationVC], animated: false)
            
            UIView.animate(withDuration: 0.3) {
                destinationVC.view.transform = .identity
            }
            UIView.animate(withDuration: 0.6) { [weak self] in guard let self else { return }
                destinationVC.view.alpha = 1
            }
        }
    }
}

