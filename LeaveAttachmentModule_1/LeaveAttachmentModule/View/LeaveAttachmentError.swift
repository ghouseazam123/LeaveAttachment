//
//  LeaveAttachmentError.swift
//  LeaveAttachmentModule
//
//  Created by next on 23/12/25.
//

import Foundation

enum LeaveAttachmentError: Error {
    case fileTooLarge


    var errorDescription: String {
        switch self {
        case .fileTooLarge: return "File size must be less than 10 MB"
       
        }
    }
}
enum PickerType: String, Identifiable {
    case camera, gallery, document
    var id: String { rawValue }
}


