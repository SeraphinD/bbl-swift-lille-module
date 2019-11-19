import MyUIKit

final class OverlayDetailsViewController: UIViewController {
    
    // MARK: - INTERNAL
    
    var onDismiss: (() -> Void)?
    var oldBrightness: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        hideValues()
        setValues()
        oldBrightness = UIScreen.main.brightness
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCloseView(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        closeView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func didTapCloseView(_ sender: UITapGestureRecognizer) {
        hideValues()
        UIView.animate(withDuration: 0.2, animations: {
            self.closeView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.backgroundView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { [weak self] _ in
            self?.onDismiss?()
            self?.dismiss(animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bounceCloseView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.backgroundView.transform = .identity
            self.titleLabel.alpha = 1
            self.descriptionLabel.alpha = 1
            self.codeImageView.alpha = 1
        }
        UIScreen.main.brightness = CGFloat(1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIScreen.main.brightness = oldBrightness
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.first?.view == closeView else { return }
        UIView.animate(withDuration: 0.2) {
            self.closeView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.first?.view == closeView else { return }
        UIView.animate(withDuration: 0.2) {
            self.closeView.transform = .identity
        }
    }
    
    private func bounceCloseView() {
        closeView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                        self?.closeView.transform = .identity
        })
    }
    
    // MARK: - PRIVATE
    
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var closeView: UIView! {
        didSet {
            closeView.backgroundColor = colors.basic(tint: 100)
        }
    }
    @IBOutlet private weak var closeImageView: UIImageView!
    @IBOutlet private weak var closeLabel: UILabel! {
        didSet {
            closeLabel.setStyle(textStyles.button_medium_basic_600)
        }
    }
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.setStyle(textStyles.h2_headline_basic_100)
        }
    }
    @IBOutlet private weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.setStyle(textStyles.p1_paragraph_basic_100)
        }
    }
    @IBOutlet private weak var codeImageView: UIImageView! {
        didSet {
            codeImageView.contentMode = .scaleAspectFit
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .clear
        closeView.layer.cornerRadius = 20
        closeImageView.image = UIImage.clear.withRenderingMode(.alwaysTemplate)
        closeImageView.tintColor = colors.basic(tint: 600)
        backgroundView.backgroundColor = .clear
        closeLabel.text = NSLocalizedString("close", comment: "")
        codeImageView.downloaded(from: NSLocalizedString("code_image", comment: ""))
        backgroundView.layer.cornerRadius = backgroundView.frame.size.width/2
        backgroundView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        let layer = CAGradientLayer()
        layer.frame = backgroundView.bounds
        layer.cornerRadius = backgroundView.layer.cornerRadius
        let firstPoint: CGPoint!
        let secondPoint: CGPoint!
        firstPoint = CGPoint(x: 0.5, y: 0.0)
        secondPoint = CGPoint(x: 0.5, y: 1.0)
        layer.startPoint = firstPoint
        layer.endPoint = secondPoint
        layer.colors = [colors.primary_01(tint: 400)!.cgColor,
                        colors.primary_01(tint: 700)!.cgColor]
        backgroundView.layer.insertSublayer(layer, at: 0)
    }
    
    private func setValues() {
        titleLabel.text = NSLocalizedString("title_details", comment: "")
        descriptionLabel.text = NSLocalizedString("description", comment: "")
    }
    
    private func hideValues() {
        titleLabel.alpha = 0
        descriptionLabel.alpha = 0
        codeImageView.alpha = 0
    }
    
}
