//
//  PraiseView.swift
//  PauseParenting
//
//  Created by Peter Woods on 14/11/2023.
//



import SwiftUI

struct PraiseView: View {
    
    @EnvironmentObject private var navigationManager: NavigationManager
    @State private var showingBest = false
    @State private var showingWhy = false
    
   
    
    var body: some View {
        
            VStack(spacing: 52) {
                Spacer()
                header
                
                subHeader
                
                bestPraise
                
                whyPraise
                
                
                
                HStack{
                    Image("koala1")
                        .padding(50)
                    Spacer()
                    Spacer()
                }
                Spacer()
            }
               //TODO: Change below once praise flow is made
            .sheet(isPresented: $showingBest) {
                SecondIgnoreView()
            }
            .sheet(isPresented: $showingWhy) {
                SecondIgnoreView()
            }
            .background(
                background,
                alignment: .top
            )
                }
            
            
        
      
        

    
    private var header: some View {
        
        Text("Learn about Praise")
            .font(.poppins700, size: 40)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.1)
            .padding(.horizontal, 28)
            .padding(.top, 22)
            .foregroundStyle(Color.textDark)
            .frame(width: 311, height: 135, alignment: .center)
    }
    
    private var subHeader: some View {
        
        Text("Limits like time out and consequences only work if you encourage good behaviour too!")
        .font(
        Font.custom("Poppins", size: 18)
        .weight(.semibold)
        )
        .multilineTextAlignment(.center)
        .foregroundColor(Color.textSecondary)
        .frame(width: 335, height: 80, alignment: .center)
    }
    
   
    
    private var bestPraise: some View {
        Button{
            showingBest = true
        } label: {
            HStack{
                Text("Best ways to praise")
                    .padding()
                    .frame(width: 238, height: 60)
            }
        }
        .buttonStyle(.mainGreenButton)
        .padding(.horizontal, 40)
    }
    
    
    private var whyPraise: some View {
        Button{
            showingWhy = true
        } label: {
            HStack{
                Text("Why Praise")
                    .padding()
                    .frame(width: 238, height: 60)
            }
        }
        .buttonStyle(.mainGreenButton)
        .padding(.horizontal, 40)
    }
        
    
    
    private var background: some View {
        Image("mainLargeBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    
}



#Preview {
    NavigationStack {
        PraiseView()
            .environmentObject(NavigationManager())
            .environmentObject(ParentDataManager())
    }
}
