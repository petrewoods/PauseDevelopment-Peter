//
//  ChildPickerView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 12.10.2023.
//

import SwiftUI

struct ChildPickerView: View {
    @Binding var selectedChild: ChildModel
    @Binding var isExpanded: Bool
    @State private var showWelcomeText = true
    
    let children: [ChildModel]
    
    var body: some View {
        VStack(spacing: 0) {
            ChildLineView(
                selectedChild: $selectedChild,
                child: $selectedChild,
                isExpanded: $isExpanded,
                showWelcomeText: $showWelcomeText
            )
            
            if isExpanded {
                darkDivider
                ForEach(children.filter ({$0 != selectedChild }), id: \.self) { child in
                    ChildLineView(selectedChild: $selectedChild, child: .constant(child), isExpanded: $isExpanded, showWelcomeText: $showWelcomeText)
                        .background(
                            Color.grayBackground
                        )
                    
                    if child != children.filter ({$0 != selectedChild }).last {
                        darkDivider
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 27))
        .background(
            RoundedRectangle(cornerRadius: 27)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.1), radius: 8)
        )
    }
    
    private var darkDivider: some View {
        Rectangle()
            .foregroundStyle(Color.textDark)
            .frame(height: 0.5)
    }
}

fileprivate struct ChildLineView: View {
    @Binding var selectedChild: ChildModel
    @Binding var child: ChildModel
    @Binding var isExpanded: Bool
    @Binding var showWelcomeText: Bool
    
    var isChildSelected:Bool {
        return child == selectedChild
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                title
                subtitle
            }
            Spacer()
            image
        }
        .padding(.horizontal)
        .frame(height: 82)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            if !isChildSelected {
                selectedChild = child
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.spring(duration: 0.6)) {
                        showWelcomeText.toggle()
                    }
                }
            } else {
                showWelcomeText.toggle()
            }
            withAnimation {
                isExpanded.toggle()
            }
        }
    }
    
    private var title: some View {
        Text(showWelcomeText && isChildSelected ? "Welcome back" : child.name)
            .foregroundStyle(Color.textDark)
            .font(isChildSelected ? .poppins600 : .poppins400, size: isChildSelected ? 24 : 20)
    }
    
    private var subtitle: some View {
        Text((isChildSelected ? "Helping with \(child.name)" : "Switch to \(child.name)"))
            .foregroundStyle(isChildSelected ? child.color : Color.textDark)
            .font(isChildSelected ? .poppins500 : .poppins400, size: 14)
    }
    
    private var image: some View {
        PersonImage(
            image: child.image,
            color: child.color,
            size: 62,
            lineWidth: 3
        )
    }
}

#Preview {
    VStack(spacing: 50) {
        ChildPickerView(selectedChild: .constant(.mockChildJess), isExpanded: .constant(true), children: ChildModel.mockChildren)
                                 
        Spacer()
    }
    .padding()
}
