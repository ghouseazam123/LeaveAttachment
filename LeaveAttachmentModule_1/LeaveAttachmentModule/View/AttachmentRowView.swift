//
//  AttachmentRowView.swift
//  LeaveAttachmentModule
//
//  Created by next on 20/12/25.
//


import SwiftUI
struct AttachmentRowView: View {
    let attachment: AttachmentEntity
    let onDelete: () -> Void
    let onView: () -> Void

    var body: some View {
        HStack {
            Text(attachment.fileType.uppercased())
                .font(.system(size: 14))
                .frame(width: 40, height: 40)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(6)
                 Spacer()
            VStack(alignment: .leading) {
                Text(attachment.fileName)
                    .font(.system(size: 14))
                Text("\(attachment.fileSize / 1024) KB")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
                        Spacer()

            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.black)
                    .frame(width: 10, height: 10)
            }
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            .padding(.trailing, 10)
        }
        .padding(10)
        .frame(height: 60)
        .onTapGesture { onView() }
        .overlay(
            Rectangle()
                .stroke(
                    Color(.lightGray),
                    style: StrokeStyle(lineWidth: 1, dash: [4, 2])
                )
        )
    }
}

