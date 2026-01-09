//
//  AttachmentFileEntity.swift
//  LeaveAttachmentModule
//
//  Created by next on 20/12/25.
//

import Foundation

struct AttachmentEntity: Identifiable {
    let id = UUID()
    let fileName: String
    let fileSize: Int64
    let fileURL: URL
    let fileType: String
    let fileData: Data
}


class mDocumentData {
    private(set) var documentData: Data
    private(set) var documentName: String
    init(attachment: AttachmentEntity) {
        self.documentData = attachment.fileData
        self.documentName = attachment.fileName
    }
}
