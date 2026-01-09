//
//  FileLeaveAttachmentPresenter.swift
//  LeaveAttachmentModule
//
//  Created by next on 20/12/25.
//
import SwiftUI
class LeaveAttachmentPresenter: ObservableObject {
    @Published var documentData: mDocumentData?
    @Published var attachment: AttachmentEntity?
    @Published var showError = false
    @Published var ErrorMessage: String?
    @Published var showActionSheet = false
    @Published var pickerType: PickerType?

    let interactor: LeaveAttachmentInteractorProtocol
    let router: LeaveAttachmentRouter

    init(interactor: LeaveAttachmentInteractorProtocol,
         router: LeaveAttachmentRouter) {
        self.interactor = interactor
        self.router = router
    }

    
    func attachFile(_ attachment: AttachmentEntity)  {
        do {
            self.attachment = try interactor.persistAttachment(attachment)
            self.documentData =  mDocumentData(attachment: attachment)
        } catch let error as LeaveAttachmentError {
            ErrorMessage = error.errorDescription
            showError = true
        } catch {
            ErrorMessage = "Unknown error"
            showError = true
        }
    }

    func removeAttachment() {
        attachment = nil
    }


    func showAttachOptions() {
        showActionSheet = true
    }

    func selectPicker(_ type: PickerType) {
        pickerType = type
    }

    func dismissPicker() {
        pickerType = nil
    }

    
    func viewAttachment() {
        guard let attachment else { return }
        router.navigateToPreview(attachment: attachment)
    }
}


