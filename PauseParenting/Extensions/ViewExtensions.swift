//
//  ViewExtensions.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 10.10.2023.
//

import SwiftUI

extension View {
    func clearTextfield() -> some View {
        modifier(ClearTextfield())
    }
    
    func tabbar(isPresented: Bool) -> some View { self
        .safeAreaInset(edge: .bottom) {
            if isPresented {
                TabBarView()
                    .zIndex(2)
            }
        }
        .animation(.easeIn(duration: 0.08), value: isPresented)
        .ignoresSafeArea(.keyboard)
    }
    
    func card(cornerRadius: CGFloat = 28, backgroundColor: Color = .white, shadowColor: Color = .black.opacity(0.1), isShowingShadow: Bool = true) -> some View { self
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .shadow(color: isShowingShadow ? shadowColor : .clear, radius: 8, x: 0, y: 0)
    }
    
    func addHideKeyboardButton() -> some View {
        self.toolbar {
            ToolbarItem(placement: .keyboard) {
                Button {
                    UIApplication.shared.endEditing()
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
    
    func navigationDestinations() -> some View {
        modifier(NavigationDestinationsViewModifier())
    }
    
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    ///should be used if view is not root in navigation stack and tabbar is visible
    func tabbarSafearea() -> some View {
        modifier(TabBarSafeArea())
    }
    
    func imagePicker(isPresented: Binding<Bool>, onImageSelected: ((UIImage) -> Void)? = nil) -> some View {
        self.modifier(ImagePickerViewModifier(isPresented: isPresented, onImageSelected: onImageSelected))
    }
    
    func onChangeInitially<Element: Equatable>(
        of element: Element,
        _ perform: @escaping (Element) -> ()
    ) -> some View { self
        .onChange(of: element, perform: perform)
        .onAppear { perform(element) }
    }
    
    func showAlert(_ alert: Binding<AlertType?>) -> some View {
        modifier(AlertView(alertType: alert))
    }
}


//MARK: Fixes swipe to back with hidden navbar
extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}


struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

struct TabBarSafeArea: ViewModifier {
    @EnvironmentObject private var navigationManager: NavigationManager
    
    func body(content: Content) -> some View {
        content.safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: navigationManager.tabBarSize.height + 16)
        }
    }
}
