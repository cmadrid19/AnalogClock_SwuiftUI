//
//  ContentView.swift
//  Clock_SwuiftUI
//
//  Created by Maxim Macari on 28/09/2020.
//

import SwiftUI

struct ContentView: View {
    
    @State var isDark: Bool = false
    
    var body: some View {
        
        NavigationView{
            Home(isDark: $isDark)
                .navigationBarHidden(true)
                .preferredColorScheme(isDark ? .dark : .light)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Home: View {
    
    @Binding var isDark: Bool
    var width = UIScreen.main.bounds.width
    @State var currentTime = Time(min: 0, sec: 0, hour: 0)
    @State var receiver = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    
    var body: some View {
        
        VStack{
            
            
            HStack{
                
                Text("Analog Clock")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Spacer(minLength: 0)
                
                Button(action: {
                    isDark.toggle()
                }) {
                    Image(systemName: isDark ? "sun.min.fill" : "moon.fill")
                        .font(.system(size: 22))
                        .foregroundColor(isDark ? .black : .white)
                        .padding()
                        .background(Color.primary)
                        .clipShape(Circle())
                }
            }
            .padding()
            
            Spacer(minLength: 0)
            
            
            ZStack{
                
                Circle()
                    .fill(isDark ? Color.white.opacity(0.1) :
                            Color.black.opacity(0.1))
                
                //Seconds and min dots
                ForEach(0..<60, id: \.self){ i in
                    Rectangle()
                        .fill(Color.primary)
                        //60 / 12 = 5
                        .frame(width: 2, height: (i % 5) == 0 ? 15 : 5)
                        .offset(y: (width - 110) / 2)
                        .rotationEffect(.init(degrees: Double(i) * 6))
                    
                }
                
                
                //Sec...
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 2, height: (width - 180) / 2)
                    .offset(y: -(width - 180) / 4)
                    .rotationEffect(.init(degrees: Double(currentTime.sec) * 6))
                
                //Min
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4, height: (width - 210) / 2)
                    .offset(y: -(width - 200) / 4)
                    .rotationEffect(.init(degrees: Double(currentTime.min) * 6))
                
                //Hour
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4.5, height: (width - 260) / 2)
                    .offset(y: -(width - 240) / 4)
                    .rotationEffect(.init(degrees: Double(currentTime.hour + (currentTime.min / 60)) * 30))
                
                //Center Circle
                
                Circle()
                    .fill(Color.primary)
                    .frame(width: 15, height: 15)
                
            }.frame(width: width - 80, height: width - 80)
            
            //Getting locale Region Name
            Text(Locale.current.localizedString(forRegionCode: Locale.current.regionCode!) ?? "")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 35)
            //Locale.current.regionCode -->  if a user travels abroad, their device will still be configured for their home country, so an American visiting France will still say "US".
            
            Text(getTime())
                .font(.system(size: 45))
                .fontWeight(.heavy)
                .padding(.top, 10)
            
            
            Spacer(minLength: 0)
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
    
    func getTime() -> String{
        
        let format = DateFormatter()
        format.dateFormat = "hh:mm a"
        
        return format.string(from: Date())
        
    }
    
}

//Calculating Time
struct Time {
    
    var min : Int
    var sec : Int
    var hour: Int
    
}
