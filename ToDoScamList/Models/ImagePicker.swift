//
//  ImagePicker.swift
//  imagePickerTest
//
//  Created by Денис Жестерев on 26.12.2022.
//
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var show: Bool
    @Binding var image: Data
    var source: UIImagePickerController.SourceType

    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePicker.Coordinator(parent1: self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = source
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        init(parent1: ImagePicker) {
            parent = parent1
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.show.toggle()

        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            let image = info[.originalImage] as? UIImage
            let data = image?.jpegData(compressionQuality: 0.50)
            self.parent.image = data!
            self.parent.show.toggle()
        }
    }
}
