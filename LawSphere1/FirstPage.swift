//
//  FirstPage.swift
//  LawSphere1
//
//  Created by Aryan Panwar on 01/09/24.
//

import SwiftUI


struct FirstPage: View {
    @State private var chooseCharacter : String = ""
    @State private var isNavigationActive = false
    @State private var topic  = "Preamble"
    
    let topics = ["Preamble" , "Judiciary" , "Legislative"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red : 53/225 , green : 114/255 , blue : 123/255)
                    .ignoresSafeArea()
                VStack {
                    Text("Law Sphere")
                        .font(.largeTitle.bold())
                        .frame(alignment: .top)
                        .foregroundStyle(.white)
                    Text("Learn Constitution easily ")
                        .foregroundStyle(.white)
                        
                    Text("Choose a topic")
                        .foregroundStyle(.white)
                        .padding(.top)
                    Picker("Select a topic", selection: $topic) {
                        ForEach(topics , id : \.self){ topic in
                            Text(topic)
                                .foregroundStyle(.black)
                        }
                    }
                    .pickerStyle(.palette)
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 20), style : FillStyle())
                    .padding([.horizontal , .bottom])
                    
                    Text("Choose a character")
                        .padding()
                    HStack {
                        Button(action: {
                            chooseCharacter = "character_maleAdventurer_"
                            isNavigationActive = true
                        }, label: {
                            VStack {
                                Text("Dev")
                                    .offset(y : 50)
                                    .font(.title.bold().monospaced())
                                    .foregroundStyle(.yellow)
                                Image("character_maleAdventurer_wide")
                                    .resizable()
                                    .scaledToFit()
                                    .shadow(color: .white, radius: 5)
                                    .shadow(color: .white, radius: 5)
                            }
                            .background(.mint)
                            .clipShape(.rect(cornerRadius: 20))
                        })
                        
                        Button(action: {
                            chooseCharacter = "character_femalePerson_"
                            isNavigationActive = true
                        }, label: {
                            VStack {
                                Text("Devi")
                                    .offset(y : 50)
                                    .font(.title.bold().monospaced())
                                    .foregroundStyle(.yellow)
                                Image("character_femalePerson_wide")
                                    .resizable()
                                    .scaledToFit()
                                    .shadow(color: .white, radius: 5)
                                    .shadow(color: .white, radius: 5)
                            }
                            .background(.mint)
                            .clipShape(.rect(cornerRadius: 20))
                        })
                    }
                    .padding()
                    
                    
                }
//                .padding()
            }
            .navigationDestination(isPresented: $isNavigationActive) {
                SecondPage(numberOfQuestions: .constant(10), character: $chooseCharacter, topic: $topic)
            }
        }
    }
}

#Preview {
    FirstPage()
}
