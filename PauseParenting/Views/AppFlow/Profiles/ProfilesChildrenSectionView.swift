//
//  ProfilesChildrenSectionView.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 19.10.2023.
//

import SwiftUI

struct ProfilesChildrenSectionView: View {
    let children: [ChildModel]
    let action: (ChildModel) -> ()
    
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(children) { child in
                let isLast = children.last == child
                
                Button {
                    action(child)
                } label: {
                    ProfilesChildCard(child: child)
                }
                .foregroundStyle(Color.textDark)
                
                if !isLast {
                    Divider()
                }
            }
        }
        .card()
    }
}

#Preview {
    ProfilesChildrenSectionView(children: ChildModel.mockChildren, action: { _ in })
}
