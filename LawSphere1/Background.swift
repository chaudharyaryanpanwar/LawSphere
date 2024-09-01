//
//  Background.swift
//  LawSphere1
//
//  Created by Aryan Panwar on 01/09/24.
//

import SwiftUI

struct WaveBg : View {
    let minHeight : CGFloat
    let maxHeight : CGFloat
    let width : CGFloat
    let numberOfRectangles = 3
    let waveColors : [Color] = [.orange , .blue , .green ]
    
    @State private var heights  : [CGFloat] = []
    
    var body : some View {
        VStack(spacing : 10) {
            ForEach(0..<numberOfRectangles , id : \.self){ index in
                waveRectangle(height: heights.isEmpty ? CGFloat.random(in: minHeight...maxHeight)  : heights[index] , width: width, color: waveColors[index % waveColors.count])
            }
        }
        .onAppear{
            startAnimating()
        }
    }
    
    func startAnimating(){
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            withAnimation(Animation.easeInOut(duration: 3).repeatForever()){
                heights = (0..<numberOfRectangles).map { _ in
                    CGFloat.random(in: 50...300)
                }
            }
        }
    }
}

struct waveRectangle : View {
    let height : CGFloat
    let width : CGFloat
    let color : Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: height  , height: width)
            .foregroundStyle(color)
    }
}

#Preview {
    WaveBg(minHeight: 200, maxHeight: 400, width: 45)
}

