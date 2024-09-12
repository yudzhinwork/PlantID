//
//  OnboardingReviewViewController.swift
//  PlantID

import UIKit

struct Review {
    var name: String
    var image: UIImage
    var text: String
}

final class OnboardingReviewViewController: BaseViewController, UICollectionViewDelegateFlowLayout {

    // MARK: - UI Elements

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellWithReuseIdentifier: "ReviewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = .zero
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .white
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.text = "New opportunities"
        return label
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor(hexString: "#D9D9D9")
        pageControl.currentPageIndicatorTintColor = UIColor(hexString: "#45814E")
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = UIColor(hexString: "#404A3E")
        label.text = "9.99$/week, 99.9% accuracy of \nidentification, tips and treatment plant"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "NavigationButton-Skip")!, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(skipPressed), for: .touchUpInside)
        button.tintColor = UIColor(hexString: "#404A3E")
        return button
    }()
        
    private let reviews = [Review(name: "Sarah Miller", image: UIImage(named: "Review-Sarah") ?? UIImage(), text: "\"This app feels like a personal plant assistant, offering helpful reminders and plant identification features that make caring for my plants so much easier and enjoyable.\""),
                           Review(name: "Olivia Brown", image: UIImage(named: "Review-Emma") ?? UIImage(), text: "\"This app is a game-changer! Although I’ve only been using it for a short time, my plants have never looked better. I love the easy-to-use reminders for watering and feeding, which take away all the guesswork and keep my plants thriving.\""),
                           Review(name: "James Anderson", image: UIImage(named: "Review-James") ?? UIImage(), text: "\"Incredible tool for plant care. I’ve been using this app for a few weeks now, and it’s made a huge difference. My plants are healthier, and I don’t have to worry about forgetting when to water or fertilize. The notifications are spot-on and really helpful.\"")]
    
    var viewModel: OnboardingViewModel?
    var delegateRouting: OnboardingRouterDelegate?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCollectionView()
    }
    
    @objc func skipPressed() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first else {
             return
         }
         
         let paywallViewController = PaywallViewController()
         window.rootViewController = UINavigationController(rootViewController: paywallViewController)
         UIView.transition(with: window,
                           duration: 0.5,
                           options: .transitionCrossDissolve,
                           animations: nil)
    }

    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(skipButton)
        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            titleLabel.topAnchor.constraint(equalTo: skipButton.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 66),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 316),
            
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 28),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 316)
    }
}

extension OnboardingReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        let review = reviews[indexPath.item]
        cell.fill(review)
        return cell
    }
}

class ReviewCollectionViewCell: UICollectionViewCell {
    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(reviewLabel)
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        NSLayoutConstraint.activate([
            reviewLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            reviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            reviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            reviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        reviewLabel.text = text
    }
}

extension OnboardingReviewViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = collectionView.frame.width
        let currentPage = Int((collectionView.contentOffset.x + pageWidth / 2) / pageWidth)
        pageControl.currentPage = currentPage
    }
}
