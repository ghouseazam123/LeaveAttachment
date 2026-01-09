//
//  LeaveAttachmentContracts.swift
//  LeaveAttachmentModule
//
//  Created by next on 20/12/25.
//


import SwiftUI

protocol LeaveAttachmentPresenterProtocol {
    func attachFile(_ attachment: AttachmentEntity)
    func removeAttachment()
    func viewAttachment()
}

protocol LeaveAttachmentInteractorProtocol {
    func validateFileSize(_ size: Int64) -> Bool
    func persistAttachment(_ attachment: AttachmentEntity) throws -> AttachmentEntity
    
}

