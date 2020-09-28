//
//  AnalogClock.swift
//  Clock_SwuiftUI
//
//  Created by Maxim Macari on 28/09/2020.
//

import SwiftUI

struct AnalogClock: View {
    
    @State var seconds: Bool = false
    
    var body: some View {
        
        ZStack{
            RadialGradient(gradient: Gradient(colors: [Color.gray, .black]), center: .center, startRadius: 5, endRadius: 700).scaleEffect(1.5)
            
            bgDots()
            
            Circle()
                .frame(maxWidth: 20)
                .foregroundColor(.white)
            Circle()
                .frame(maxWidth: 10)
            
            
            //hour, min , sec pointers
            pointers()
        }
        
    }
}

struct AnalogClock_Previews: PreviewProvider {
    static var previews: some View {
        AnalogClock()
    }
}


//TODO mejor los dos structos en uno: Dots
struct bgDots: View {
    var body: some View{
        ZStack{
            ForEach(0..<60, id: \.self){ i in
                
                Circle()
                    // 60 / 12 = 5
                    .frame(maxWidth: i % 5 == 0 ? 8 : 3)
                    .foregroundColor(.white)
                    .offset(y: -155)
                    .rotationEffect(.degrees(Double(i * (360/60))))
                
                
            }
            
            ForEach(0..<12, id: \.self){ i in
                
                Text(toRoman(number: (i == 0 ? 12 : i)))
                    .font(.body).bold()
                    .foregroundColor(.white)
                    .offset(y: -170)
                    .rotationEffect(.degrees(Double(i * (360/12))))
                
            }
            
        }
        
        
        
    }
    
    private func toRoman(number: Int) -> String {
        let conversionTable: [(intNumber: Int, romanNumber: String)] =
            [(1000, "M"),
             (900, "CM"),
             (500, "D"),
             (400, "CD"),
             (100, "C"),
             (90, "XC"),
             (50, "L"),
             (40, "XL"),
             (10, "X"),
             (9, "IX"),
             (5, "V"),
             (4, "IV"),
             (1, "I")]
        var roman = ""
        var remainder = 0
        
        for entry in conversionTable {
            let quotient = (number - remainder) / entry.intNumber
            remainder += quotient * entry.intNumber
            roman += String(repeating: entry.romanNumber, count: quotient)
        }
        
        return roman
    }
}

struct pointers: View {
    @State var currentTime = Time(min: 0, sec: 0, hour: 0)
    @State var receiver = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    
    var body: some View {
        ZStack{
            //Hour
            Rectangle()
                .frame(width: 2, height: 90)
                .foregroundColor(.white)
                .offset(y: -60)
                .rotationEffect(.init(degrees: Double(currentTime.hour + currentTime.min / 60) * 30))
            
            //Min
            Rectangle()
                .frame(width: 2, height: 140)
                .foregroundColor(.white)
                .offset(y: -75)
                .rotationEffect(.init(degrees: Double(currentTime.min) * 60))
            
            //Sec
            Rectangle()
                .frame(width: 2, height: 180)
                .foregroundColor(.orange)
                .offset(y: -55)
                .rotationEffect(.init(degrees: Double(currentTime.sec) * 6))
            
            Text(getTime())
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(Color.white.opacity(0.8))
                .offset(y:85)
            
        }
        .onAppear(perform: {
            let calendar = Calendar.current
            
            let min = calendar.component(.minute, from: Date())
            let sec = calendar.component(.second, from: Date())
            let hour = calendar.component(.hour, from: Date())
            
            withAnimation(Animation.linear(duration: 0.01)){
                self.currentTime = Time(min: min, sec: sec, hour: hour)
            }
            
        })
        .onReceive(receiver){ _ in
            
            let calendar = Calendar.current
            
            let min = calendar.component(.minute, from: Date())
            let sec = calendar.component(.second, from: Date())
            let hour = calendar.component(.hour, from: Date())
            
            withAnimation(Animation.linear(duration: 0.01)){
                self.currentTime = Time(min: min, sec: sec, hour: hour)
            }
        }
    }
    private func getTime() -> String{
        
        let format = DateFormatter()
        format.dateFormat = "hh:mm:ss"
        
        return format.string(from: Date())
        
    }
}
