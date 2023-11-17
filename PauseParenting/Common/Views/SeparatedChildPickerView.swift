//
//  SeparatedChildPickerView.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 19.10.2023.
//

import SwiftUI

struct SeparatedChildPickerView: View {
    @Binding var selectedChild: ChildModel
    @Binding var isExpanded: Bool
    
    let children: [ChildModel]
    
    var body: some View {
        VStack(spacing: 0) {
            ChildLineView(selectedChild: $selectedChild, child: $selectedChild, isExpanded: $isExpanded)
                .card(cornerRadius: 27, shadowColor: Color.black.opacity(0.2), isShowingShadow: isExpanded)
            
            if isExpanded {
                ForEach(children.filter ({$0 != selectedChild }), id: \.self) { child in
                    ChildLineView(selectedChild: $selectedChild, child: .constant(child), isExpanded: $isExpanded)
                    
                    if child != children.filter ({$0 != selectedChild }).last {
                        darkDivider
                    }
                }
            }
            
        }
    }
    
    private var darkDivider: some View {
        Rectangle()
            .foregroundStyle(Color.textDark)
            .frame(height: 0.25)
    }
}

fileprivate struct ChildLineView: View {
    @Binding var selectedChild: ChildModel
    @Binding var child: ChildModel
    @Binding var isExpanded: Bool
    
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
            }
            withAnimation {
                isExpanded.toggle()
            }
        }
    }
    
    private var title: some View {
        Text(isExpanded ? child.name : (isChildSelected ? "Journal" : child.name))
            .foregroundStyle(Color.textDark)
            .font(isChildSelected ? .poppins600 : .poppins400, size: isChildSelected ? 24 : 20)
    }
    
    private var subtitle: some View {
        var subtitleText = ""
        if isChildSelected {
            subtitleText = isExpanded ? "Helping with \(child.name)" : "Look back at \(child.name)’ progress"
        } else {
            subtitleText = "Switch to \(child.name)"
        }
        
        return Text(subtitleText)
            .foregroundStyle(isChildSelected ? child.color : Color.textDark)
            .font(isChildSelected ? .poppins500 : .poppins400, size: 14)
    }
    
    private var image: some View {
        PersonImage(image: child.image, color: child.color, size: 62)
    }
}

#Preview {
    SeparatedChildPickerView(selectedChild: .constant(.mockChildJess), isExpanded: .constant(true), children: ChildModel.mockChildren)
        .padding(.horizontal)
}
