//
//  SecondPage.swift
//  LawSphere1
//
//  Created by Aryan Panwar on 01/09/24.
//

//
//  SecondPage.swift
//  LawSphere
//
//  Created by Aryan Panwar on 31/08/24.
//

import GoogleGenerativeAI
import SwiftUI

struct SecondPage: View {
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    @Environment(\.dismiss) private var dismiss
    @State private var userInput = "generate 10 questions from Preamble of Indian Constitution and prepare their answer YOUR OUTPUT SHOULD BE COMPLETELEY IN AN JSON ARRAY FORMAT IN WHICH EVERY QUESTION IS MAPPED WITH ITS ANSWER WITHOUT ANY OTHER DETAIL"
    @Binding var numberOfQuestions  : Int
    @Binding var character : String
    @Binding var topic : String
    @State private var score : Int = 0
    @State private var totalQuestions = 0
    @State private var answer : String = ""
    @State private var animationAngle = Angle.zero
    
    @FocusState private var isAnswerFocused  : Bool
    
    @State private var questions = [Question]()
    @State private var question : String?
    @State private var correctAnswer  : String?
    
    @State private var isCorrect = false
    @State private var isAlerting = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var isFinal = false
    @State private var isLoading = true
    @State private var response = ""
    
    @State private var answerResponse : LocalizedStringKey = ""
    @State private var showingSolutionSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 53/255, green: 114/255 , blue: 123/255)
                    .ignoresSafeArea()
                VStack {
                    Text(!isLoading ? "Score : \(score) / \(totalQuestions)" : "Loading ...")
                        .font(.title.bold().monospacedDigit())
                        .foregroundStyle(.black)
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(.rect(cornerRadius: 30))
                    if isAnswerFocused {
                        Spacer()
                    }
                    if !isLoading {
                        VStack{
                            Text(  question ?? "wait")
                                .font(.title.bold())
                                .multilineTextAlignment(.leading)
                                .padding()
                                .background(.gray)
                                .font(.title)
                                .clipShape(.rect(cornerRadius: 20))
                                .foregroundStyle(.white)
                                .frame(alignment: .trailing)
                                .shadow(color: .white , radius: isAnswerFocused ? 10 : 0)
                                .shadow(color: .white , radius: isAnswerFocused ? 10 : 0)
//                                .animation(.spring, value: isAnswerFocused)
//                                .animation(.bouncy(duration:1), value: question)
//                                .offset(y : 95)
                            
                            if !isAnswerFocused {
                                Image("\(character)think")
                                    .frame(width : 410 , alignment: .leading)
                                    .shadow(color: .white , radius: isAnswerFocused ? 10 : 0)
                                    .shadow(color: .white , radius: isAnswerFocused ? 10 : 0)
                                    .animation(.spring, value: isAnswerFocused)
                                    .animation(.bouncy(duration:1), value: question)
                                    .offset(y:-95)
                            }
                        }
//                        .animation(.bouncy(duration:1), value: question)
                        
                        .rotation3DEffect(
                            animationAngle,
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        if isAnswerFocused {
                            Spacer()
                        }
                        TextField("  Enter answer", text : $answer )
                            .focused($isAnswerFocused)
                            .padding()
                            .foregroundStyle(.white)
                            .background(.ultraThinMaterial)
                            .clipShape(.rect(cornerRadius: 20), style: FillStyle())
                            .padding()
                            .font(.title)
                    } else {
                        VStack {
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
//                                .tint(Color(red: 53/255, green: 114/255 , blue: 123/255))
                                .tint(.white)
                                .scaleEffect(4)
                                .padding(80)
                                
                        }
                        
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar(content: {
                if isAnswerFocused {
                    
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Button("Done") {
                            isAnswerFocused.toggle()
                            checkAnswer()
                        }
                        .foregroundStyle(.white)
//                        .background(.ultraThinMaterial)
                    })
                    
                }
                ToolbarItem(placement : .topBarLeading){
                    Button("< Back"){
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
                
            })
            .onAppear {
                generateResponse()
            }
            .sheet(isPresented: $showingSolutionSheet , onDismiss: {
                showingSolutionSheet = false
                if ( totalQuestions != numberOfQuestions ) {
                    generateQuestion()
                }
                else {
                    withAnimation(.bouncy(duration: 2)){
                        isFinal = true
                        isAlerting = false
                    }
                }
                withAnimation {
                    animationAngle += Angle(degrees: 360)
                }
            } ,content: {
                VStack {
                    Text("\(question ?? "") : ")
                        .font(.title.bold().monospaced())
                        .padding()
                        .foregroundStyle(.white)
                        .background(.ultraThinMaterial)
                        .clipShape(.rect(cornerRadius: 10))
                    
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .tint(.white)
                            .scaleEffect(4)
                            .padding(80)
                    } else {
                        ScrollView {
                            Text(answerResponse)
                                .font(.title2)
                                .foregroundStyle(.white)
                            
                            Button( totalQuestions == numberOfQuestions  ? "Show Score" : "Next Question"){
                                showingSolutionSheet = false
                                if ( totalQuestions != numberOfQuestions ) {
                                    generateQuestion()
                                }
                                else {
                                    withAnimation(.bouncy(duration: 2)){
                                        isFinal = true
                                        isAlerting = false
                                    }
                                }
                                withAnimation {
                                    animationAngle += Angle(degrees: 360)
                                }
                            }
                            .font(.title)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(.rect(cornerRadius: 20))
                            .foregroundStyle(.white)
                        }
                        .scrollIndicators(.hidden
                        )
                        .padding(.horizontal)
                    }
                    
                }
                .frame(maxWidth: .infinity , maxHeight: .infinity)
                .background(.brown)
            })
            .sheet(isPresented: $isAlerting, onDismiss: {
                generateQuestion()
            } ,content: {
                VStack {
                    Text(alertTitle)
                        .font(.title.bold().monospaced())
                        .foregroundStyle(.white)
                    VStack {
                        Text(isCorrect ? "Good job"  : "Oops ")
                            .font(.title.bold().monospaced())
                            .foregroundStyle(.yellow)
                            .offset(y : 50)
                        Image(isCorrect ? "\(character)cheer1" : "\(character)fallDown")
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(1, contentMode: .fit)
                            .shadow(color : .white ,radius: 10)
                            .shadow(color : .white , radius: 10)
                        
                        
                    }
                    .frame(width: 300)
                    .background(.mint)
                    .clipShape(.rect(cornerRadius: 20))
                    .shadow(color : .white ,radius: 10)
                    .shadow(color : .white , radius: 10)
                    .padding()
                    
                    if !isCorrect {
                        Button("Ask solution from AI 🤖"){
                            isAlerting = false
                            showingSolutionSheet = true
                            generateAnswer()
                        }.font(.title)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(.rect(cornerRadius: 20))
                            .foregroundStyle(.white)
                    }
                    Button( totalQuestions == numberOfQuestions  ? "Show Score" : "Next Question"){
                        if ( totalQuestions != numberOfQuestions ) {
                            generateQuestion()
                        }
                        else {
                            withAnimation(.bouncy(duration: 2)){
                                isFinal = true
                                isAlerting = false
                            }
                        }
                        withAnimation {
                            animationAngle += Angle(degrees: 360)
                        }
                    }
                    .font(.title)
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 20))
                    .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity , maxHeight: .infinity)
                .background(isCorrect ? .green : .red)
            })
            .sheet(isPresented: $isFinal, onDismiss: {
                resetGame()
            } , content: {
                VStack {
                    VStack {
                        Text("Final Score : \(score) / \(totalQuestions)")
                            .font(.title.bold().monospacedDigit())
                            .foregroundStyle(.black)
                            .padding()
                            .background(.thinMaterial)
                            .clipShape(.rect(cornerRadius: 30))
                            .offset(y : 50)
                        Image( "\(character)cheer0")
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(1, contentMode: .fit)
                            .shadow(color : .white ,radius: 10)
                            .shadow(color : .white , radius: 10)
                    }
                    .frame(width: 300)
                    .background(.mint)
                    .clipShape(.rect(cornerRadius: 20))
                    .shadow(color : .white ,radius: 10)
                    .shadow(color : .white , radius: 10)
                    .onTapGesture {
                        resetGame()
                    }
                    .padding()
                    .rotation3DEffect(
                        animationAngle,
                                              axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                    Text("Restart")
                        .font(.title.bold().monospaced())
                        .foregroundStyle(.white)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(.rect(cornerRadius: 20))
                        .onTapGesture {
                            resetGame()
                        }
                        
                }
                .frame(maxWidth: .infinity , maxHeight: .infinity)
                .background(Color(red: 53/255, green: 114/255 , blue: 123/255)
                    .ignoresSafeArea())
            })

        }
    }
    func generateQuestion()->Void{
        question = questions[totalQuestions].question
        print("ANSWER : \(answer)")
        correctAnswer = questions[totalQuestions].answer
        isAlerting = false
        isAnswerFocused = false
        answer = ""
    }
    func checkAnswer(){
        if correctAnswer == answer {
            score += 1
            alertTitle = "Correct Answer"
            isCorrect = true
        }
        else {
            print("correct answer is : \(correctAnswer ?? "") and the other \(answer)")
            alertTitle = "Wrong Answer"
            isCorrect = false
        }
        totalQuestions += 1
        isAlerting = true
    }
    func resetGame(){
        score  = 0
        totalQuestions = 0
        isFinal = false
        generateResponse()
    }
    
    func generateAnswer(){
        isLoading = true
        answerResponse = ""
        let userInput = "solve this question \(question!) from the \(topic) of Indian Constitution step by step so it is easy to understand for beginners"
        Task {
            do  {
                let result = try await model.generateContent(userInput)
                isLoading = false
                answerResponse = LocalizedStringKey (  result.text ?? "No response found" )
            } catch {
                answerResponse = "Something went wrong \n \(error.localizedDescription)"
            }
        }
        
    }
    func generateResponse() {
        isLoading = true
        response = ""
        let userInput = "generate \(numberOfQuestions) questions of the \(topic) form the Indian Constitution and the answer should be string only , your output should be completely an json array in which every question is mapped with its answer without any other detail"
        Task {
            do {
                let result = try await model.generateContent(userInput)
                isLoading = false
                response = result.text ?? "No response found"
                
                loadQuestions()
            } catch {
                response = "Something went wrong \n \(error.localizedDescription)"
            }
        }
        
    }
    
    func loadQuestions() {
        let uncleanedJsonString = response
        let jsonString = cleanJsonString(uncleanedJsonString)
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Failed to convert JSON string to Data")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            questions = try decoder.decode([Question].self, from: jsonData)
            print("Successfully decoded JSON: \(questions)")
        } catch {
            print("Failed to decode JSON: \(error.localizedDescription)")
            generateResponse()
            
            // Additional debugging information
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .typeMismatch(let type, let context):
                    print("Type mismatch error: \(type), context: \(context)")
                    generateResponse()
                case .valueNotFound(let type, let context):
                    print("Value not found error: \(type), context: \(context)")
                    generateResponse()
                case .keyNotFound(let key, let context):
                    print("Key not found error: \(key), context: \(context)")
                    generateResponse()
                case .dataCorrupted(let context):
                    print("Data corrupted error: \(context) ,data : \(jsonData)")
                    generateResponse()
                    
                @unknown default:
                    print("Unknown decoding error")
                }
            }
        }
        isLoading = false
        generateQuestion()
    }
    func cleanJsonString(_ jsonString: String) -> String {
            // Remove any backticks and unwanted characters
            let cleanedJsonString = jsonString
                .replacingOccurrences(of: "`", with: "")
                .replacingOccurrences(of: "\\", with: "") // Add more replacements as needed
                .replacingOccurrences(of: "json", with: "")
            print("Cleanded JSON String : \(cleanedJsonString)")
        return cleanedJsonString
        }

}

#Preview {
    SecondPage(numberOfQuestions: .constant(10), character: .constant("character_femalePerson_"), topic: .constant("Preamble"))
}
