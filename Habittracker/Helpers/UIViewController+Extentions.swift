import UIKit

extension UIViewController {
    func showAlert(
        title: String,
        description: String? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: description,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

        alert.addAction(okAction)

        present(alert, animated: true)
    }
}
