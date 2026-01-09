//
//  ContentView.swift
//  LeaveAttachmentModule
//
//  Created by next on 20/12/25.
//

import SwiftUI
struct LeaveAttachmentView: View {
    @StateObject var presenter: LeaveAttachmentPresenter
    var body: some View {
        VStack {
          

            if let attachment = presenter.attachment {
                AttachmentRowView(
                    attachment: attachment,
                    onDelete: presenter.removeAttachment,
                    onView: presenter.viewAttachment
                )
                .padding()
            } else {
                attachBox
                    .padding()
                   
                    .actionSheet(isPresented: $presenter.showActionSheet) {
                        ActionSheet(
                            title: Text("Upload"),
                            buttons: [
                                .default(Text("Camera")) { presenter.selectPicker(.camera) },
                                .default(Text("Gallery")) { presenter.selectPicker(.gallery) },
                                .default(Text("Document")) { presenter.selectPicker(.document) },
                                .destructive(Text("Cancel")) {}
                            ]
                        )
                    }
            }
        }
        .alert(isPresented: $presenter.showError) {
                    Alert(
                        title: Text(""),
                        message: Text(presenter.ErrorMessage ?? ""),
                        dismissButton: .default(Text("OK"))
                    )
                }
        .sheet(item: $presenter.pickerType) { selectedType in
            pickerView(selectedType)
        }
    }
    private var attachBox: some View {
        HStack {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 28))
                .foregroundColor(.gray)
            Spacer()
            Text("Attach Document")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(10)
        .frame(height: 60)
        .onTapGesture {
            presenter.showAttachOptions()
        }
        .overlay(
            Rectangle()
                .stroke(
                    Color(.lightGray),
                    style: StrokeStyle(lineWidth: 1, dash: [4, 2])
                )
        )
    }


    private func pickerView(_ type: PickerType) -> some View {
        AttachmentPicker(type: type) { attachment in
            presenter.attachFile(attachment)
            presenter.dismissPicker()
        }
    }
}


