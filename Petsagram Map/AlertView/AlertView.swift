//
//  AlertView.swift
//  Petsagram Map
//
//  Created by Vahe Toroyan on 12/2/20.
//

import SwiftUI

struct AlertView: View {
    
    @Binding var presented: Bool
    @Environment(\.openURL) var openURL
    
    var body: some View {
        ZStack {
        Rectangle()
            .fill(Color.black.opacity(0.5))
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .topLeading)
            .onTapGesture {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    withAnimation {
                        self.presented = false
                    }
                }
            }
        Rectangle()
            .fill(Color.white)
            .frame(width: UIScreen.main.bounds.width - 40,
                   height: 250,
                   alignment: .center)
            .cornerRadius(30)
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 80,
                       height: 80)
                .cornerRadius(40,
                              antialiased: true)
            Text("Welcome to Petsagram Map")
                .bold()
//                .font(.title)
                .foregroundColor(.gray)

            Text("It seems your Petsagram GPS is not assigned,\nlook at website to find instructions.")
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .font(.footnote)
                .foregroundColor(Color(UIColor.lightGray))

            Button(action: {
                openURL(URL(string: "https://petsagram.io")!)
            }, label: {
                Text("Forward to Website")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: 240,
                           height: 40,
                           alignment: .center)
                    .background(Color.red)
                    .cornerRadius(15)
                    .shadow(radius: 4)
            }).padding(.top, 20)
        }
        }.opacity(self.presented ? 1 : 0)
         .animation(.easeInOut(duration: 0.5))
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(presented: .constant(false))
    }
}
