import UIKit

// MARK: - NavigationButtonsDelegate protocol
protocol NavigationButtonsDelegate: AnyObject {
    func addTapped()
}

// MARK: - NavigationController
final class NavigationController: UINavigationController {

    // MARK: - Properties and Initializers
    weak var buttonsDelegate: NavigationButtonsDelegate?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        configureNavigationController()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
extension NavigationController {

    @objc private func addButtonTapped() {
        buttonsDelegate?.addTapped()
    }

    private func configureNavigationController() {
        navigationBar.barTintColor = .snPinkLight
        navigationBar.tintColor = .snPinkDark
        navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.snPinkDark]
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                        style: .plain,
                                        target: nil,
                                        action: #selector(addButtonTapped))
        navigationBar.topItem?.rightBarButtonItem = addButton
        navigationBar.topItem?.backButtonTitle = "Cancel"
    }
}
