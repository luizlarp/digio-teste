//
//  AlertWarning.swift
//  Teste IOs Developer Digio
//
//  Created by Luiz on 25/01/23.
//

import UIKit
class AlertWarning {
    class func alert(title: String,
                     msgDesc: String,
                     viewController: UIViewController) {
        let alert = UIAlertController(title: title,
                                      message:msgDesc,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        viewController.present(alert, animated: true, completion : nil)
    }
}
