//
//  ContentView.swift
//  ClockSwiftUI
//
//  Created by Shreyas Vilaschandra Bhike on 26/01/25.
//

//  MARK: Instagram
//  TheAppWizard
//  MARK: theappwizard2408




import SwiftUI


struct ContentView: View {
    var body: some View {
        ClockView()
    }
}



#Preview {
    ContentView()
}
















struct ClockView: View {
    @State private var currentDate = Date()
    @State private var selectedLanguage = "English"
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let languages = ["English", "Hindi", "Marathi", "Gujarati", "Tamil", "Telugu"]
    
    let numberTranslations: [String: [String]] = [
        "English": ["1","2","3","4","5","6","7","8","9","10","11","12"],
        "Hindi": ["१","२","३","४","५","६","७","८","९","१०","११","१२"],
        "Marathi": ["१","२","३","४","५","६","७","८","९","१०","११","१२"],
        "Gujarati": ["૧","૨","૩","૪","૫","૬","૭","૮","૯","૧૦","૧૧","૧૨"],
        "Tamil": ["௧","௨","௩","௪","௫","௬","௭","௮","௯","௧௦","௧௧","௧௨"],
        "Telugu": ["౧","౨","౩","౪","౫","౬","౭","౮","౯","౧౦","౧౧","౧౨"]
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 20) {
                Menu {
                    ForEach(languages, id: \.self) { language in
                        Button(action: {
                            selectedLanguage = language
                        }) {
                            Text(language)
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedLanguage)
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)
                }
                
                Spacer().frame(height: 35)

                ZStack {
                    Circle()
                        .stroke()
                        .frame(width: 300, height: 300)
                        .foregroundStyle(.black)
                        .opacity(0)
                    
                    // Small minute dots
                    ForEach(0..<60) { index in
                        Circle()
                            .frame(width: 3, height: 3)
                            .foregroundStyle(.white)
                            .offset(y: -150)
                            .rotationEffect(.degrees(Double(index) * 6))
                            .opacity(0.4)
                    }
                    
                    // Multilingual hour markers
                    ForEach(1..<13) { index in
                        Text(numberTranslations[selectedLanguage]?[index-1] ?? "\(index)")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.white)
                            .offset(y: -150)
                            .rotationEffect(.degrees(Double(index) * 30))
                    }
                    
                    // Hour Hand
                    VStack{
                        Rectangle()
                            .frame(width: 6, height: 80)
                            .cornerRadius(12)
                            .foregroundStyle(.red)
                            
                        Spacer().frame(height: 89)
                    }.rotationEffect(hourHandRotation)
                    
                    // Minute Hand
                    VStack{
                        Rectangle()
                            .frame(width: 6, height: 120)
                            .foregroundStyle(.red)
                            .cornerRadius(12)
                        Spacer().frame(height: 105)
                    }.rotationEffect(minuteHandRotation)
                    
                    // Seconds Hand
                    ZStack {
                        Rectangle()
                            .frame(width: 200, height: 1)
                            .foregroundStyle(.red)
                            .offset(x: 41)
                        
                        Circle()
                            .stroke(Color.red, lineWidth: 5)
                            .frame(width: 45, height: 45)
                            .offset(x: 150)
                        
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundStyle(Color(#colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)))
                            .offset(x: -57)
                    }
                    .rotationEffect(secondHandRotation)
                    
                    // Center Point
                    Circle()
                        .frame(width: 12, height: 12)
                        .foregroundStyle(.white)
                        .overlay(
                            Circle()
                                .frame(width: 8, height: 8)
                                .foregroundStyle(Color(#colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)))
                        )
                        .overlay(
                            Circle()
                                .frame(width: 4, height: 4)
                                .foregroundStyle(.white)
                        )
                }
            }
        }
        .onReceive(timer) { input in
            currentDate = input
        }
    }
    
    var secondHandRotation: Angle {
        Angle(degrees: Double(Calendar.current.component(.second, from: currentDate)) * 6)
    }
    
    var minuteHandRotation: Angle {
        let minutes = Double(Calendar.current.component(.minute, from: currentDate))
        let seconds = Double(Calendar.current.component(.second, from: currentDate))
        return Angle(degrees: (minutes + (seconds / 60)) * 6)
    }
    
    var hourHandRotation: Angle {
        let hours = Double(Calendar.current.component(.hour, from: currentDate) % 12)
        let minutes = Double(Calendar.current.component(.minute, from: currentDate))
        return Angle(degrees: (hours + (minutes / 60)) * 30)
    }
}


