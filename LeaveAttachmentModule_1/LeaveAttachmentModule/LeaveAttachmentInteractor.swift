//
//  LeaveAttachmentInteractor.swift
//  LeaveAttachmentModule
//
//  Created by next on 20/12/25.
//

import Foundation

class LeaveAttachmentInteractor: LeaveAttachmentInteractorProtocol {
    
    private let maxSize: Int64 = 10 * 1024 * 1024
    
    func validateFileSize(_ size: Int64) -> Bool {
        size <= maxSize
    }
    func persistAttachment(_ attachment: AttachmentEntity) throws -> AttachmentEntity {
        
        
        guard validateFileSize(attachment.fileSize) else {
            throw LeaveAttachmentError.fileTooLarge
        }
        return attachment
        
    }
}

