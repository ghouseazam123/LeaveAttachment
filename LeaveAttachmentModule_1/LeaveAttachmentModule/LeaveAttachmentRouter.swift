//
//  LeaveAttachmentRouter.swift
//  LeaveAttachmentModule
//
//  Created by next on 20/12/25.
//

import Foundation
import UIKit

class LeaveAttachmentRouter: NSObject, UIDocumentInteractionControllerDelegate {

    private var documentController: UIDocumentInteractionController?

    func navigateToPreview(attachment: AttachmentEntity) {
        let controller =
            UIDocumentInteractionController(url: attachment.fileURL)

        controller.delegate = self
        self.documentController = controller   
        controller.presentPreview(animated: true)
    }

    
    func documentInteractionControllerViewControllerForPreview(
        _ controller: UIDocumentInteractionController
    ) -> UIViewController {

        UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
        ?? UIViewController()
    }
}






