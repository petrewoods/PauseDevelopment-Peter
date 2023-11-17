//
//  ImagePicker.swift
//  PauseParenting
//
//  Created by Ihor Vozhdai on 25.10.2023.
//

import Foundation
import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var sourceType: UIImagePickerController.SourceType
    var onImageSelected: ((UIImage) -> Void)?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        
        checkAndRequestCameraPermission { granted in
            if granted {
                self.isPresented = true
            }
        }
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    private func checkAndRequestCameraPermission(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        default:
            completion(false)
        }
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.onImageSelected?(uiImage)
            }
            picker.dismiss(animated: true)
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
            parent.isPresented = false
        }
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        
        init(parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let result = results.first else {
                picker.dismiss(animated: true)
                return
            }
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                guard let uiImage = object as? UIImage else { return }
                
                DispatchQueue.main.async {
                    self.parent.onImageSelected?(uiImage)
                }
            }
            
            picker.dismiss(animated: true)
        }
    }
    
    var onImageSelected: ((UIImage) -> Void)?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var picker: PHPickerViewController?
        
        checkAndRequestPhotoLibraryPermission { granted in
            guard granted else {
                print("[Error][PhotoPicker] permission is not granted")
                return
            }
            
            var config = PHPickerConfiguration()
            config.selectionLimit = 1
            config.filter = .images
            
            picker = PHPickerViewController(configuration: config)
            picker?.delegate = context.coordinator
        }
        
        picker = picker ?? PHPickerViewController(configuration: PHPickerConfiguration())
        picker?.delegate = context.coordinator
        
        return picker!
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    private func checkAndRequestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        default:
            completion(false)
        }
    }
}
