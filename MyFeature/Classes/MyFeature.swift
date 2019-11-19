final public class MyFeature {
    
    private init() {}
    public static let shared = MyFeature()

    public var bundle: Bundle! {
        let podBundle: Bundle! = Bundle(for: MyFeature.self)
        let bundleUrl: URL! = podBundle.url(forResource: "MyFeature",
                                            withExtension: "bundle")
        return Bundle(url: bundleUrl)
    }
    
    @discardableResult
    public func presentOverlay(from viewController: UIViewController) -> OverlayView {
        let overlayView: OverlayView! = bundle
            .loadNibNamed("OverlayView",
                          owner: nil,
                          options: nil)?
            .first as? OverlayView
        overlayView.onTap = { [weak self, weak viewController] in
            guard
                let self = self,
                let viewController = viewController else { return }
            self.showOverlayDetails(from: viewController)
            
        }
        overlayView.appear(from: viewController)
        return overlayView
    }
    
    private func showOverlayDetails(from viewController: UIViewController) {
        let storyboard = UIStoryboard(name: "MyFeature",
                                      bundle: self.bundle)
        let detailsViewController: UIViewController! = storyboard.instantiateInitialViewController()
        detailsViewController.modalPresentationStyle = .overCurrentContext
        detailsViewController.view.backgroundColor = .clear
        detailsViewController.modalPresentationCapturesStatusBarAppearance = true
        viewController.present(detailsViewController, animated: false)
    }
}
