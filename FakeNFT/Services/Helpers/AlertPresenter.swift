import UIKit

struct AlertModel {
    var title: String?
    var message: String?
    var buttonTextFirst: String
    var completionFirst: ((UIAlertAction) -> Void)?
    var buttonTextSecond: String
    var completionSecond: ((UIAlertAction) -> Void)?
    var cancelText: String
    var cancelCompletion: ((UIAlertAction) -> Void)?
}

class AlertPresenter {
    func show(controller: UIViewController?, model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .actionSheet)
        
        let actionFirst = UIAlertAction(
            title: model.buttonTextFirst,
            style: .default,
            handler: model.completionFirst
        )
        
        let actionSecond = UIAlertAction(
            title: model.buttonTextSecond,
            style: .default,
            handler: model.completionSecond
        )
        
        let cancelAction = UIAlertAction(
            title: model.cancelText,
            style: .cancel,
            handler: model.cancelCompletion
        )
        alert.addAction(actionFirst)
        alert.addAction(actionSecond)
        alert.addAction(cancelAction)
        
        controller?.present(alert, animated: true)
    }
}
