//
//  ViewModifiers.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 09.10.2023.
//

import SwiftUI
import Photos

struct ClearTextfield: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
            .textFieldStyle(PlainTextFieldStyle())
            .onAppear {
                UITextView.appearance().textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
    }
}

struct ImagePickerViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    @State var isPresentedSheet: Bool = false
    @State private var selectedSourceType: UIImagePickerController.SourceType?
    var onImageSelected: ((UIImage) -> Void)?
    
    func body(content: Content) -> some View {
        content
            .confirmationDialog("", isPresented: $isPresented) {
                Button("Camera") {
                    selectedSourceType = .camera
                    isPresentedSheet = true
                }
                Button("Photo Library") {
                    selectedSourceType = .photoLibrary
                    isPresentedSheet = true
                }
            }
            .sheet(isPresented: $isPresentedSheet) {
                Group {
                    if selectedSourceType == .camera {
                        ImagePicker(isPresented: $isPresented, sourceType: selectedSourceType ?? .camera) { img in
                            onImageSelected?(img)
                        }
                    } else {
                        PhotoPicker { img in
                            onImageSelected?(img)
                        }
                    }
                }
                .onDisappear { isPresented = false }
                .ignoresSafeArea(edges: .bottom)
            }
    }
}


//MARK: - Alert View
enum AlertType {
    case blowOutTheCandlesInfo
}

struct AlertView: ViewModifier {
    @Binding public var alertType: AlertType?
    
    func body(content: Content) -> some View { content
        .overlay(contentOverlay)
        .overlay(alert)
        .animation(.spring(), value: alertType)
    }
    
    @ViewBuilder
    private var contentOverlay: some View {
        if alertType != nil {
            Color.black
                .opacity(0.5)
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
      private var alert: some View {
          if let alertType {
              Group {
                  switch alertType {
                  case .blowOutTheCandlesInfo:
                      BlowOutTheCandlesInfoAlertView(alertType: $alertType)
                  }
              }
              .padding(.horizontal)
              .transition(.opacity.combined(with: .scale(scale: 0.5)))
          }
      }
}
