//
//  ViewController.swift
//  TwitterEffectDemo
//
//  Created by 玉垒浮云 on 2022/2/16.
//

import SegementSlide

extension UIView {
    func addSubViews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
}

struct Width {
    static let screen = UIScreen.main.bounds.width
}

struct Height {
    static let screen = UIScreen.main.bounds.height

    static let navigationBar: CGFloat = 44
    
    static let statusBar = UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .map { $0 as? UIWindowScene }
        .compactMap { $0 }
        .first?.windows
        .filter { $0.isKeyWindow }
        .first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
}

class ViewController: SegementSlideViewController {

    // MARK: - properties
    private let topBar: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "tree-sky")
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let topBarBlurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurView.alpha = 0
        
        return blurView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Delisa"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        label.isHidden = true
        
        return label
    }()
    
    private let profilePhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profilePhoto")
        imageView.contentMode = .scaleAspectFill
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = ProfilePhoto.cornerRadius
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        
        return imageView
    }()
    
    private let smallProfilePhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profilePhoto")
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = SmallProfilePhoto.cornerRadius
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Delisa"
        label.font = NameLabel.font
        
        return label
    }()
    
    private let refreshControl = UIRefreshControl()
    
    private var dataSources = ["🐶, 🐱, 🐭, 🐹, 🐰, 🐻, 🐼, 🐨, 🐯, 🦁, 🐮, 🐷, 🐽, 🐸, 🐵, 🙈, 🙉, 🙊, 🐒, 🦍, 🐔, 🐧, 🐦, 🐤, 🐣, 🐥, 🐺, 🦊, 🐗, 🐴, 🦓, 🦒, 🦌, 🦄, 🐝, 🐛, 🦋, 🐌, 🐞, 🐜, 🦗, 🕷, 🕸, 🦂, 🐢, 🐍, 🦎, 🦀, 🦑, 🐙, 🦐, 🐠, 🐟, 🐡, 🐬, 🦈, 🐳, 🐋, 🐊, 🐆, 🐅, 🐃, 🐂, 🐄, 🐪, 🐫, 🐘, 🦏, 🐐, 🐏, 🐑, 🐎, 🐖, 🦇, 🐓, 🦃, 🕊, 🦅, 🦆, 🦉, 🐕, 🐩, 🐈, 🐇, 🐀, 🐁, 🐿, 🦔, 🐾, 🐉, 🐲, 🦕, 🦖".components(separatedBy: ", "), "立春, 雨水, 驚蟄, 春分, 清明, 穀雨, 立夏, 小滿, 芒種, 夏至, 小暑, 大暑, 立秋, 處暑, 白露, 秋分, 寒露, 霜降, 立冬, 小雪, 大雪, 冬至, 小寒, 大寒".components(separatedBy: ", "), ["秦时明月汉时关", "烟花三月下扬州", "秋来相顾尚飘蓬", "落月摇情满江树", "月是故乡明", "明月不归沉碧海", "人事音书漫寂寥", "琉璃钟，琥珀浓，小槽酒滴真珠红", "花发多风雨，人生足别离", "烛龙栖寒门，光曜犹旦开"]]
    
    private let titles = ["Emojis", "节气", "诗句"]
    
    override var headerView: UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: HeaderView.height).isActive = true
        view.addSubViews([profilePhoto, smallProfilePhoto, nameLabel])
        
        return view
    }
    
    override var switcherConfig: SegementSlideSwitcherConfig {
        var config = super.switcherConfig
        config.type = .tab
        config.normalTitleFont = .preferredFont(forTextStyle: .title3)
        config.selectedTitleFont = .preferredFont(forTextStyle: .title3)
        config.selectedTitleColor = .blue
        config.indicatorColor = .blue
        config.indicatorWidth = 100
        config.horizontalMargin = 0
        
        return config
    }
    
    override var titlesInSwitcher: [String] {
        return titles
    }
    
    // MARK: - view controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareViews()
        setupLayout()
        
        reloadData()
        scrollToSlide(at: 0, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.frame = CGRect(
            x: 0, y: TopBar.height, width: Width.screen,
            height: Height.screen - TopBar.height
        )
    }
    
    // MARK: -
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        let viewController = UserContentViewController()
        viewController.models = dataSources[index]
        
        return viewController
    }
    
    // MARK: - private methods
    private func prepareViews() {
        topBar.addSubViews([topBarBlurView, titleLabel])
        view.insertSubview(topBar, belowSubview: slideScrollView)
        
        slideSwitcherView.layer.shadowRadius = 1
        slideSwitcherView.layer.shadowColor = UIColor.gray.cgColor
        slideSwitcherView.layer.shadowOpacity = 0.2
        slideSwitcherView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        slideScrollView.addSubview(refreshControl)
        slideScrollView.backgroundColor = .clear
    }
    
    private func setupLayout() {
        topBar.frame = TopBar.initialFrame
        topBarBlurView.frame = topBar.bounds
        
        titleLabel.frame = TitleLabel.initialFrame
        titleLabel.sizeToFit()
        titleLabel.center.x = topBar.center.x
        TitleLabel.height = titleLabel.frame.height
        
        profilePhoto.frame = ProfilePhoto.initialFrame
        smallProfilePhoto.frame = SmallProfilePhoto.initialFrame
        
        nameLabel.frame = NameLabel.initialFrame
        nameLabel.sizeToFit()
        NameLabel.height = nameLabel.frame.height
    }
    
    @objc private func refreshData() {
        for i in 0..<dataSources.count {
            dataSources[i] = dataSources[i].reversed()
        }
        
        reloadData()
        refreshControl.endRefreshing()
    }
}

// MARK: - scroll view delegate
extension ViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        switch offset {
        case -1000..<0:
            // scroll view 快速滑动时， 在两次相邻的 scrollViewDidScroll(_:) 调用过程中，
            // scrollView.contentOffset.y 可能会出现跳跃。
            // 所以对于滑动过程中变动过的 view，需要在所有阶段都设置默认值，否则会出现混乱。
            titleLabel.isHidden = true
            profilePhoto.isHidden = false
            profilePhoto.transform = CGAffineTransform.identity
            smallProfilePhoto.isHidden = true
            
            // 计算 topBar 的偏移和缩放及 topBarBlurView 的 alpha 值
            let topBarScaleFactor = -offset / TopBar.initialFrame.height
            let topBarYOffset = -offset / 2
            
            topBar.transform = CGAffineTransform(translationX: 0, y: topBarYOffset)
            topBar.transform = CGAffineTransform(
                scaleX: 1 + topBarScaleFactor, y: 1 + topBarScaleFactor
            ).concatenating(topBar.transform)
            
            if offset < 0 && offset > -20 {
                let factor = -offset / 20
                topBarBlurView.alpha = factor
            } else {
                topBarBlurView.alpha = 1
            }
        case 0..<TopBar.extendHeight:
            // 设置默认值
            topBarBlurView.alpha = 0
            titleLabel.isHidden = true
            smallProfilePhoto.isHidden = true
            
            // 计算 topBar 的偏移及 profilePhoto 的偏移和缩放
            let factor = offset / TopBar.extendHeight
            let photoScaleFactor = 1 - (1 - ProfilePhoto.minScaleFactor) * factor
            let photoYOffset = ProfilePhoto.maxYOffset * factor
            
            topBar.transform = CGAffineTransform(translationX: 0, y: -offset)
            
            profilePhoto.isHidden = false
            profilePhoto.transform = CGAffineTransform(translationX: 0, y: photoYOffset)
            profilePhoto.transform = CGAffineTransform(
                scaleX: photoScaleFactor, y: photoScaleFactor
            ).concatenating(profilePhoto.transform)
        case TopBar.extendHeight..<Blur.upStartYOffset:
            // 设置默认值
            topBar.transform = CGAffineTransform(translationX: 0, y: -TopBar.extendHeight)
            topBarBlurView.alpha = 0
            titleLabel.isHidden = true
            
            profilePhoto.isHidden = true
            smallProfilePhoto.isHidden = false
        case Blur.upStartYOffset..<Blur.upEndYOffset:
            // 设置默认值
            topBar.transform = CGAffineTransform(translationX: 0, y: -TopBar.extendHeight)
            profilePhoto.isHidden = true
            smallProfilePhoto.isHidden = false
            
            // 计算 topBarBlurView 的透明度及 titleLabel 的偏移量
            let factor = (offset - Blur.upStartYOffset) / (Blur.upEndYOffset - Blur.upStartYOffset)
            // 透明度线性增长太慢，对 factor 开立方让其增长快一点
            topBarBlurView.alpha = cbrt(factor)
            
            titleLabel.isHidden = false
            titleLabel.transform = CGAffineTransform(
                translationX: 0, y: factor * TitleLabel.maxYOffset
            )
        case Blur.upEndYOffset...:
            // 设置默认值
            topBar.transform = CGAffineTransform(translationX: 0, y: -TopBar.extendHeight)
            topBarBlurView.alpha = 1
            titleLabel.isHidden = false
            titleLabel.transform = CGAffineTransform(
                translationX: 0, y: TitleLabel.maxYOffset
            )
            profilePhoto.isHidden = true
            smallProfilePhoto.isHidden = false
        default:
            return
        }
    }
}

private extension ViewController {
    enum TopBar {
        static let extendHeight: CGFloat = 50
        static let height: CGFloat = Height.statusBar + Height.navigationBar
        static let initialFrame = CGRect(
            x: 0, y: -TopBar.height,
            width: Width.screen, height: TopBar.height + TopBar.extendHeight
        )
    }
    
    enum TitleLabel {
        static let initialFrame = CGRect(x: 0, y: TopBar.initialFrame.height, width: 0, height: 0)
        static var height: CGFloat = 0
        static let maxYOffset = -(TitleLabel.height + 15)
    }
    
    enum HeaderView {
        static let height: CGFloat = NameLabel.initialFrame.maxY + NameLabel.font.lineHeight + 10
    }
    
    enum ProfilePhoto {
        static let cornerRadius: CGFloat = 37
        static let initialFrame = CGRect(
            x: 16, y: -28 + TopBar.extendHeight,
            width: 2 * ProfilePhoto.cornerRadius,
            height: 2 * ProfilePhoto.cornerRadius
        )
        static let minScaleFactor: CGFloat = 24.0 / 37.0
        static let maxYOffset = TopBar.extendHeight + ProfilePhoto.minScaleFactor * ProfilePhoto.cornerRadius - ProfilePhoto.initialFrame.midY
    }
    
    enum SmallProfilePhoto {
        static let cornerRadius: CGFloat = ProfilePhoto.minScaleFactor * ProfilePhoto.cornerRadius
        static let initialFrame = CGRect(
            x: ProfilePhoto.initialFrame.midX - SmallProfilePhoto.cornerRadius,
            y: TopBar.extendHeight,
            width: 2 * SmallProfilePhoto.cornerRadius,
            height: 2 * SmallProfilePhoto.cornerRadius
        )
    }
    
    enum NameLabel {
        static let initialFrame = CGRect(
            x: 20, y: ProfilePhoto.initialFrame.maxY + 10,
            width: 0, height: 0
        )
        static var height: CGFloat = 0
        static let font = UIFont.boldSystemFont(ofSize: 26)
    }
    
    enum Blur {
        static let upStartYOffset = NameLabel.initialFrame.minY - 5
        static let upEndYOffset = Blur.upStartYOffset + NameLabel.height + 10
    }
}

