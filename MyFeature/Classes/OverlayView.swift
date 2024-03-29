import MyUIKit

final public class OverlayView: UIView {
    
    // MARK: - PUBLIC
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(tapGestureRecognizer)
        titleLabel.text = NSLocalizedString("title", comment: "")
        titleLabel.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.titleLabel.alpha = 1
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
        }
    }
    
    public func appear(from topViewController: UIViewController) {
        
        let offsetY: CGFloat = topViewController.tabBarController?.tabBar.frame.height ?? 16
        let viewControllerHeight: CGFloat = topViewController.view.frame.size.height
        var finalY: CGFloat = viewControllerHeight - height - offsetY - CGFloat(48)

        if #available(iOS 11.0, *) {
            finalY -= UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 // Handle safe area
        }
        
        frame = CGRect(x: topViewController.view.frame.midX - width/2,
                       y: finalY,
                       width: width,
                       height: height)
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height,
                                                  relatedBy: .equal, toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: CGFloat(height))
        let widthConstraint = NSLayoutConstraint(item: self, attribute: .width,
                                                 relatedBy: .equal, toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant: CGFloat(width))
        
        addConstraints([heightConstraint, widthConstraint])
        
        topViewController.view.addSubview(self)
        show()
    }
    
    // MARK: - INTERNAL
    
    let height: CGFloat = 38
    let width: CGFloat = 120
    
    var onTap: (() -> Void)?
    
    // MARK: - PRIVATE
    
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.setStyle(textStyles.button_medium_basic_100)
        }
    }
    
    @IBOutlet private weak var topView: UIView! {
        didSet {
            topView.backgroundColor = colors.primary_01(tint: 600)
            topView.layer.cornerRadius = 20
        }
    }
    
    @objc private func didTapView(_ sender: UITapGestureRecognizer) {
        onTap?()
    }
}


