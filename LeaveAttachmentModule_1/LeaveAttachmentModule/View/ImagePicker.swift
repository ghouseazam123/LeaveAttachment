////
////  ImagePicker.swift
////  LeaveAttachmentModule
////
////  Created by next on 20/12/25.
////
//
//  AttachmentPicker.swift
//  LeaveAttachmentModule
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct AttachmentPicker: UIViewControllerRepresentable {
    
    let type: PickerType
    let completion: (AttachmentEntity) -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        switch type {
            
        case .camera, .gallery:
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.sourceType = (type == .camera) ? .camera : .photoLibrary
            picker.allowsEditing = false
            return picker
            
        case .document:
            let types: [UTType] = [
                .pdf,
                .png,
                .jpeg,
                .plainText,
                .image,
                .zip,
                .gzip,
                .bz2
            ]
            let picker = UIDocumentPickerViewController(
                forOpeningContentTypes: types
            )
            picker.delegate = context.coordinator
            return picker
        }
    }
    
    func updateUIViewController(
        _ uiViewController: UIViewController,
        context: Context
    ) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(type: type, completion: completion)
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject,
                       UIImagePickerControllerDelegate,
                       UINavigationControllerDelegate,
                       UIDocumentPickerDelegate {
        
        let type: PickerType
        let completion: (AttachmentEntity) -> Void
        
        init(
            type: PickerType,
            completion: @escaping (AttachmentEntity) -> Void
        ) {
            self.type = type
            self.completion = completion
        }
        
        // MARK: Image Picker
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            
            if type == .camera {
                handleCamera(info)
            } else {
                handleGallery(info)
            }
            
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(
            _ picker: UIImagePickerController
        ) {
            picker.dismiss(animated: true)
        }
        
        private func handleCamera(
            _ info: [UIImagePickerController.InfoKey : Any]
        ) {
            
            guard let image = info[.originalImage] as? UIImage,
                  let data = image.pngData() else { return }
            
            let currentDate =
            Date().timeIntervalSince1970
                .truncatingRemainder(dividingBy: 1000)
            
            let trimmedDate = String("\(currentDate)".suffix(4))
            let fileName = "IMG_\(trimmedDate).png"
            
            let documentsURL =
            FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            )[0]
            
            let fileURL =
            documentsURL.appendingPathComponent(fileName)
            
            do {
                try data.write(to: fileURL)
                
                let size =
                Int64(
                    (try? fileURL.resourceValues(
                        forKeys: [.fileSizeKey]
                    ).fileSize) ?? 0
                )
                
                completion(
                    AttachmentEntity(
                        fileName: fileName,
                        fileSize: size,
                        fileURL: fileURL,
                        fileType: "PNG",
                        fileData: data
                    )
                )
                
            } catch {
                print("Camera save failed:", error)
            }
        }
        
        private func handleGallery(
            _ info: [UIImagePickerController.InfoKey : Any]
        ) {

            guard let url = info[.imageURL] as? URL else { return }

            do {
                let data = try Data.init(contentsOf: url)
                let currentDate =
                            Date().timeIntervalSince1970
                                .truncatingRemainder(dividingBy: 1000)

                        let trimmedDate = String("\(currentDate)".suffix(4))

                        
                        let fileExtension = url.pathExtension.uppercased()


                        let fileName = "IMG_\(trimmedDate).\(fileExtension)"

                let size =
                    Int64(
                        (try? url.resourceValues(
                            forKeys: [.fileSizeKey]
                        ).fileSize) ?? 0
                    )

                completion(
                    AttachmentEntity(
                        fileName: fileName,
                        fileSize: size,
                        fileURL: url,
                        fileType: fileExtension,
                        fileData: data
                    )
                )

            } catch {
                print("Failed to read gallery image data:", error.localizedDescription)
            }
        }

        
        // MARK: Document Picker
        func documentPicker(
            _ controller: UIDocumentPickerViewController,
            didPickDocumentsAt urls: [URL]
        ) {
            
            guard let url = urls.first else { return }
            
            _ = url.startAccessingSecurityScopedResource()
            do {
                
                let data = try Data.init(contentsOf: url)
                let size =
                Int64(
                    (try? url.resourceValues(
                        forKeys: [.fileSizeKey]
                    ).fileSize) ?? 0
                )
                completion(
                    AttachmentEntity(
                        fileName: url.lastPathComponent,
                                fileSize: size,
                                fileURL: url,
                                fileType: url.pathExtension.uppercased(),
                                fileData: data
                    )
                )
            }catch {
                print("Failed to read document data:", error)
            }
            url.stopAccessingSecurityScopedResource()
        }
    }
}
//import SwiftUI
//import UIKit
//
//struct ImagePicker: UIViewControllerRepresentable {
//
//    let type: PickerType
//    let completion: (AttachmentEntity) -> Void
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        picker.sourceType = (type == .camera) ? .camera : .photoLibrary
//        picker.allowsEditing = false
//        return picker
//    }
//
//    func updateUIViewController(
//        _ uiViewController: UIImagePickerController,
//        context: Context
//    ) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(type: type, completion: completion)
//    }
//
//    // MARK: - Coordinator
//    class Coordinator: NSObject,
//                       UIImagePickerControllerDelegate,
//                       UINavigationControllerDelegate {
//
//        let type: PickerType
//        let completion: (AttachmentEntity) -> Void
//
//        init(
//            type: PickerType,
//            completion: @escaping (AttachmentEntity) -> Void
//        ) {
//            self.type = type
//            self.completion = completion
//        }
//
//        func imagePickerController(
//            _ picker: UIImagePickerController,
//            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
//        ) {
//
//            if type == .camera {
//                handleCamera(info)
//            } else {
//                handleGallery(info)
//            }
//
//            picker.dismiss(animated: true)
//        }
//
//        func imagePickerControllerDidCancel(
//            _ picker: UIImagePickerController
//        ) {
//            picker.dismiss(animated: true)
//        }
//
//
//        private func handleCamera(
//            _ info: [UIImagePickerController.InfoKey : Any]
//        ) {
//
//            guard let image = info[.originalImage] as? UIImage,
//                  let data = image.pngData() else { return }
//
//            let currentDate =
//                Date().timeIntervalSince1970
//                    .truncatingRemainder(dividingBy: 1000)
//
//            let trimmedDate = String("\(currentDate)".suffix(4))
//            let fileName = "IMG_\(trimmedDate).png"
//
//            let documentsURL =
//                FileManager.default.urls(
//                    for: .documentDirectory,
//                    in: .userDomainMask
//                )[0]
//
//            let fileURL =
//                documentsURL.appendingPathComponent(fileName)
//
//            do {
//                try data.write(to: fileURL)
//
//                let size =
//                    Int64(
//                        (try? fileURL.resourceValues(
//                            forKeys: [.fileSizeKey]
//                        ).fileSize) ?? 0
//                    )
//
//                completion(
//                    AttachmentEntity(
//                        fileName: fileName,
//                        fileSize: size,
//                        fileURL: fileURL,
//                        fileType: "PNG"
//                    )
//                )
//
//            } catch {
//                print("Camera save failed:", error)
//            }
//        }
//
//
//        private func handleGallery(
//            _ info: [UIImagePickerController.InfoKey : Any]
//        ) {
//
//            guard let url = info[.imageURL] as? URL else { return }
//
//            let size =
//                Int64(
//                    (try? url.resourceValues(
//                        forKeys: [.fileSizeKey]
//                    ).fileSize) ?? 0
//                )
//
//            completion(
//                AttachmentEntity(
//                    fileName: url.lastPathComponent,
//                    fileSize: size,
//                    fileURL: url,
//                    fileType: url.pathExtension.uppercased()
//                )
//            )
//        }
//    }
//}
////import SwiftUI
////import UIKit
////
////struct ImagePicker: UIViewControllerRepresentable {
////    let type: PickerType
////    let completion: (AttachmentEntity) -> Void
////   // @Binding var name: String
////    func makeUIViewController(context: Context) -> UIImagePickerController {
////        let picker = UIImagePickerController()
////        picker.delegate = context.coordinator
////        picker.sourceType = type == .camera ? .camera : .photoLibrary
////       // print(name, "Make UIview method")
////        return picker
////    }
////
////    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
////      //  print(name,"Update method")
////    }
////
////    func makeCoordinator() -> Coordinator { Coordinator(completion) }
////
////    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
////        let completion: (AttachmentEntity) -> Void
////        init(_ completion: @escaping (AttachmentEntity) -> Void) { self.completion = completion }
////
////        func imagePickerController(_ picker: UIImagePickerController,
////                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
////
////            var fileURL: URL?
////            var fileType = "unknown"
////
////            if let url = info[.imageURL] as? URL {
////                    fileURL = url
////                    fileType = url.pathExtension.uppercased()
////
////            } else if let image = info[.originalImage] as? UIImage {
////                let fileName = "\(UUID().uuidString).jpg"
////                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
////                let permanentURL = documentsURL.appendingPathComponent(fileName)
////                if let data = image.jpegData(compressionQuality: 0.9) {
////                    do {
////                        try data.write(to: permanentURL)
////                        fileURL = permanentURL
////                        fileType = "JPG"
////                        print("Captured photo saved permanently:", permanentURL.absoluteString)
////                    } catch {
////                        print("Failed to save photo:", error)
////                    }
////                }
////            }
////
////            if let url = fileURL {
////                let size = Int64((try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0)
////                completion(AttachmentEntity(
////                    fileName: url.lastPathComponent,
////                    fileSize: size,
////                    fileURL: url,
////                    fileType: fileType
////                ))
////            }
////
////            picker.dismiss(animated: true)
////        }
////
////        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
////            //print("clicked on cancel")
////            picker.dismiss(animated: true)
////        }
////    }
////}
