import UIKit
import SwiftUI
import AVFoundation

class MainViewController: UIViewController {
    // MARK: - Properties
    var delegateRouting: MainRouterDelegate?
    var viewModel: MainViewModel?
    @AppStorage("timesMeasured") var timesMeasured = 0

    // MARK: - Outlets
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Measure App"
        label.textColor = UIColor.dynamicColor(
            light: Theme.perpleColor, 
            dark: Theme.cyanColor
        )
        label.font = Fonts.bold.addFont(24)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var trialView: CustomTrialView = {
        let view = CustomTrialView(theme: .light)
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = UIColor(hexString: "#3879BB")
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = UIColor.dynamicColor(
            light: Theme.backgroundColor,
            dark: Theme.blackColor
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            MeasureIdeasCell.self,
            forCellWithReuseIdentifier: "MeasureIdeas"
        )
        collectionView.register(
            HowToUseCell.self,
            forCellWithReuseIdentifier: "HowToUse"
        )
        collectionView.register(
            MainCellHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "MainCellHeader"
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var measureButton: UIButton = {
        let button = UIButton(type: .system)
        Theme.buttonStyle(button, title: "Measure Now")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(measureButtonPressed),
            for: .touchUpInside
        )
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.dynamicColor(
            light: Theme.backgroundColor,
            dark: Theme.blackColor
        )
        setupNavigationBar()
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setup

    private func handleCameraAccessGranted() {
//        if PremiumManager.shared.isUserPremium {
//             trialView.isHidden = true
//            let vc = AreaViewController()
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(
//                vc, animated: true
//            )
//         } else {
//             trialView.isHidden = true
//             delegateRouting?.routeToTrial()
//         }
    }

    private func handleCameraAccessDenied() {
        let alertController = UIAlertController(
            title: "Camera Access Denied",
            message: "To use this app, please allow access to your camera in Settings.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        }))
        present(alertController, animated: true, completion: nil)
    }

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }

    private func setupHierarchy() {
        view.addSubviews([
            trialView, collectionView,
            measureButton, pageControl
        ])
//        trialView.isHidden = PremiumManager.shared.isUserPremium
    }

    private func setupLayout() {
        
        let collectionHeight = UIDevice.current.name.contains("SE") ? 320 : 415
        
        if trialView.isHidden {
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

                collectionView.heightAnchor.constraint(lessThanOrEqualToConstant: 450),
                
                measureButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                measureButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                measureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

                measureButton.heightAnchor.constraint(equalToConstant: 64),
                
                pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
                pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                trialView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                trialView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                trialView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

                trialView.heightAnchor.constraint(equalToConstant: 80),

                collectionView.topAnchor.constraint(equalTo: trialView.bottomAnchor, constant: 14),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                collectionView.heightAnchor.constraint(lessThanOrEqualToConstant: CGFloat(collectionHeight)),

                measureButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                measureButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                measureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

                measureButton.heightAnchor.constraint(equalToConstant: 64),
                
                pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
                pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
    }

    // MARK: - Actions

    @objc func measureButtonPressed() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard let self = self else { return }
            if granted {
                DispatchQueue.main.async {
                    self.handleCameraAccessGranted()
                }
            } else {
                DispatchQueue.main.async {
                    self.handleCameraAccessDenied()
                }
            }
        }
    }
    
    func updatePageControl(with index: Int) {
        pageControl.currentPage = index
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension MainViewController: 
        UICollectionViewDataSource,
        UICollectionViewDelegate, 
        UICollectionViewDelegateFlowLayout
{
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        MainViewItems.itemsArray[section].count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let item = collectionView.dequeueReusableCell(
                withReuseIdentifier: "MeasureIdeas",
                for: indexPath
            ) as? MeasureIdeasCell else {
                return UICollectionViewCell()
            }
            item.configuration(
                item: MainViewItems
                    .itemsArray[indexPath.section][indexPath.item]
            )
            return item
        
        case 1:
            guard let item = collectionView.dequeueReusableCell(
                withReuseIdentifier: "HowToUse",
                for: indexPath
            ) as? HowToUseCell else {
                return UICollectionViewCell()
            }
            item.configuration(
                item: MainViewItems
                    .itemsArray[indexPath.section][indexPath.item]
            )
            return item
        
        default: return collectionView.dequeueReusableCell(
                withReuseIdentifier: "Other",
                for: indexPath
            )
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "MainCellHeader",
                for: indexPath
            ) as! MainCellHeader
            header.configure(title: "Measure Ideas")
            return header
        
        default:
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "MainCellHeader",
                for: indexPath
            ) as! MainCellHeader
            header.configure(title: "How to Use")
            return header
        }
    }

    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        MainViewItems.itemsArray.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.deselectItem(
            at: indexPath,
            animated: true
        )

    }
}

// MARK: - CustomTrialViewDelegate
extension MainViewController: CustomTrialViewDelegate {
    func premiumButtonTapped() {
        delegateRouting?.routeToTrial()
    }
}
