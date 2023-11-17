//
//  NavigationDestinationModifier.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 07.10.2023.
//

import SwiftUI

struct NavigationDestinationsViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: SelectedModulesPathItem.self) { pathItem in
                SelectedModulesView()
            }
            .navigationDestination(for: AboutTheAppPathItem.self) { pathItem in
                AboutAppView()
            }
            .navigationDestination(for: HomeProfilesPathItem.self) { pathItem in
                ProfilesView()
                    .navigationTitle("")
                    .toolbar(.hidden, for: .navigationBar)
            }
            .navigationDestination(for: IgnoreViewPathItem.self) { pathItem in
                IgnoreView()
                    .navigationTitle("")
                    .toolbar(.hidden, for: .navigationBar)
            }
            .navigationDestination(for: PraiseViewPathItem.self) { pathItem in
                PraiseView()
                    .navigationTitle("")
                    .toolbar(.hidden, for: .navigationBar)
            }
            .navigationDestination(for: ParentDetailPathItem.self) { pathItem in
                ParentDetailView(parent: pathItem.parent)
                    .navigationTitle("")
                    .toolbar(.hidden, for: .navigationBar)
            }
            .navigationDestination(for: ChildDetailPathItem.self) { pathItem in
                ChildDetailView(child: pathItem.child)
                    .navigationTitle("")
                    .toolbar(.hidden, for: .navigationBar)
            }
            .navigationDestination(for: CalmBreathsPathItem.self) { pathItem in
                CalmBreathsView()
                    .navigationTitle("")
                    .toolbar(.hidden, for: .navigationBar)
            }
            .navigationDestination(for: SenseCheckPathItem.self) { pathItem in
                SenseCheckView()
                    .navigationTitle("")
                    .toolbar(.hidden, for: .navigationBar)
            }
            .navigationDestination(for: BlowCandlesPathItem.self) { pathItem in
                BlowOutTheCandlesView()
                    .navigationTitle("")
                    .toolbar(.hidden, for: .navigationBar)
            }
            .navigationDestination(for: DistractCardPathItem.self) { pathItem in
                DistractCardView()
                    .navigationTitle("")
                    .toolbar(.hidden, for: .navigationBar)
            }
        
    }
}
