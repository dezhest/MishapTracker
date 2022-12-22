//
//  ImagePicker.swift
//  MyCash
//
//  Created by Денис Жестерев on 13.12.2022.
//

import UIKit
import SwiftUI
import CoreData
import class UIKit.UIImage

extension UIImage {
    
    func toData() -> Data? {
        return pngData()
    }
    
    var sizeInBytes: Int {
        if let data = toData() {
            return data.count
        } else {
            return 0
        }
    }
    
    var sizeInMB: Double {
        return Double(sizeInBytes) / 1_000_000
    }
}

class ImageDAO: ObservableObject {
    private let container: NSPersistentContainer

    init(container: NSPersistentContainer) {
        self.container = container
    }

    private func saveContext() {
        try! container.viewContext.save()
    }
    func makeInternallyStoredImage(_ bitmap: UIImage) -> Scam {
        let image = insert(Scam.self, into: container.viewContext)
        image.blob = (bitmap.toData() as NSData?)! // unwrap reccomended
        saveContext()
        return image
    }

    func internallyStoredImage(by id: NSManagedObjectID) -> Scam {
        return container.viewContext.object(with: id) as! Scam
    }
    private func insert<T>(_ type: T.Type, into context: NSManagedObjectContext) -> T {
        return NSEntityDescription.insertNewObject(forEntityName: String(describing: T.self), into: context) as! T
    }
}

 // до сели все для coredata image


struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    var sourceType: UIImagePickerController.SourceType
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerView
    
    init(picker: ImagePickerView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.picker.selectedImage = selectedImage
        self.picker.isPresented.wrappedValue.dismiss()
    }
    
}
