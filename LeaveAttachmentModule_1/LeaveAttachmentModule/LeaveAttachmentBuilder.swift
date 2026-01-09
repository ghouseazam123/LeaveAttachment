//
//  LeaveAttachmentBuilder.swift
//  LeaveAttachmentModule
//
//  Created by next on 20/12/25.

import SwiftUI
import SwiftUI

class LeaveAttachmentBuilder {
    func build() -> some View {
        let interactor = LeaveAttachmentInteractor()
        let router = LeaveAttachmentRouter()
        let presenter = LeaveAttachmentPresenter(
            interactor: interactor,
            router: router
        )
        let view = LeaveAttachmentView(presenter: presenter)
        return view
    }
}







