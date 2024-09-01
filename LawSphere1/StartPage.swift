//
//  StartPage.swift
//  LawSphere1
//
//  Created by Aryan Panwar on 01/09/24.
//

import SwiftUI

struct StartView: View {
    
    @State private var logoScale: CGFloat = 1.0
    @State private var isButtonPressed = false
    @State private var navigateToHomeView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 53/255, green: 114/255, blue: 123/255)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    if !isButtonPressed {
                        Button {
                            withAnimation {
                                logoScale = 1.2
                                isButtonPressed = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                navigateToHomeView = true
                            }
                        } label: {
                            Text("Law📖🇮🇳 Sphere🌐")
                                .padding()
                                .font(.largeTitle.bold().monospaced())
                                .foregroundStyle(.white)
                                .scaleEffect(logoScale)
                                .animation(.easeInOut, value: logoScale)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                        }
                    }
                    
                    Spacer()
                    
//                    if !isButtonPressed {
//                        VStack(spacing: 50) {
//                            Button("Start") {
//                                withAnimation {
//                                    isButtonPressed = true
//                                }
//                            }
//                            .font(.title)
//                            .padding(.horizontal)
//                            .foregroundStyle(.white)
//                            .padding()
//                            .background(.blue)
//                            .clipShape(.rect(cornerRadius: 20))
//                        }
//                    }
                    
                    WaveBg(minHeight: 300, maxHeight: 400, width: 65)
                        .opacity(1)
                    
                    Spacer()
                }
                .navigationDestination(isPresented: $navigateToHomeView) {
                    FirstPage()
                }
            }
        }
        #if os(iOS)
        .navigationViewStyle(StackNavigationViewStyle())
        #endif
    }
}

#Preview {
    StartView()
}
