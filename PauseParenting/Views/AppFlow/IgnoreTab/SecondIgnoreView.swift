//
//  SecondIgnoreView.swift
//  PauseParenting
//
//  Created by Peter Woods on 09/11/2023.
//

import Foundation


import SwiftUI

//MARK: Needs to figure out card on stack here see figma 

struct SecondIgnoreView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var parentData: ParentDataManager
    
    
    //TODO: Need to finish this flow and make Well done card appear
    
    //some booleans for flow
    
    //has the start ignore button been pressed?
    @State private var startIgnoreFlow = false
    //has the count down reached zero?
    
    //has the child stopped doing the ignorable action?
    
//@State private var showAddNewEntrySheet = false
        
    var body: some View {
        NavigationStack(path: $navigationManager.ignorePath) {
            ScrollView{
                VStack(spacing: 30) {
                    
                    ignoreImage
                        .padding(.top, 42)
                    
                   
                        ignoreText
                        
                    
                    .padding(.trailing, -20)
                    .padding(.top, 20)
                    if startIgnoreFlow {
                        //format
                        Spacer()
                        Spacer()
                                            Text("Keep Ignoring...")
                                                .padding(20)
                        Spacer()
                                               
                                        } else {
                                            infoText
                                                .padding(20)
                                        }
                    
                 
                    
                   
                        startIgnore
                        openDistractButton
                    
                }
                .padding()
                
            }
            .background(
                background,
                alignment: .top
            )
            .onDisappear {
                navigationManager.removeLast()
            }
        }
    }
    
    private var background: some View {
        Image("notificationBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    private var doneButton: some View {
        Button{
            dismiss.callAsFunction()
        } label: {
            Text("Done")
                .foregroundStyle(Color.greenSuccess)
                .font(.poppins500, size: 16)
        }
    }
    
    private var ignoreImage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 27)
                .foregroundStyle(Color.ignore)
                .frame(width: 110, height: 110)
            
            Image("ignoreIcon")
                .resizable()
                .renderingMode(.template)
                .frame(width: 70, height: 70)
                .foregroundStyle(Color.white)
        }
    }
    
    private var ignoreText: some View {
        Text("Ignore")
            .foregroundStyle(Color.textDark)
            .font(.poppins700, size: 40)
    }
    
    private var sendButton: some View {
        Button {
            
        } label: {
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .frame(width: 20, height: 29)
        }
    }
    
    private var infoText: some View {
        Text("You can ignore whining, crying or tantrums when nothing is physically wrong or hurting\n\nDon't react angrily, instead")
            .font(.poppins600, size: 18)
            .foregroundStyle(Color.textDark)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    
    
    private var startIgnore: some View {
        Button{
            startIgnoreFlow = true
        } label: {
            HStack{
                if startIgnoreFlow {
                    //timer logic in here or as function
                    Text("Count Down Here")
                    Spacer()
                    Image("pauseButton")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding()
                }
                else{
                    Text("Start Ignore")
                    Spacer()
                    Image("playIcon")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding()
                }
            }
        }
        .frame(width: 300)
        .buttonStyle(.darkGreenButton)
        .padding()
    }
        
    
    
    //make this try distract instead
    private var openDistractButton: some View {
        Button {
            
        } label: {
            Text("Try Distract instead")
                
        }
        .frame(width: 300)
        .buttonStyle(.darkGrayButton)
        .padding(.horizontal, 50)
    }
        
}


#Preview {
    NavigationStack {
        SecondIgnoreView()
            .environmentObject(NavigationManager())
            .environmentObject(ParentDataManager())
    }
}

