//
//  FireSmokeStatusView.swift
//  MapView
//
//  Created by Vahe Toroyan on 11/27/20.
//

import SwiftUI

struct FireSmokeStatusView: View {

    // MARK: - Properties

    let gradient = LinearGradient(gradient: Gradient(colors: [.gradientYellow, .gradientRed]),                                  startPoint: .bottomLeading,
                                  endPoint: .topTrailing)
    @State var hideRectangle: Bool = false
    @State var stopAnimation: Bool = false
    
    var body: some View {

        ZStack(alignment: hideRectangle ? .bottom : .center) {
            ZStack(alignment: .top) {
                
                Rectangle()
                    .fill(gradient)
                    .frame(width: UIScreen.main.bounds.width,
                           height: 225,
                           alignment: .bottom)
                    .cornerRadius(20)
                    .shadow(color: Color(UIColor.systemGray),
                            radius: 4,
                            x: 0,
                            y: -3)

                Button(action: {
                    self.hideRectangle.toggle()
                    self.stopAnimation = false
                }, label: {
                    Image(systemName: "chevron.compact.down")
                        .foregroundColor(.lostCircleColor)
                        .font(Font.system(size: 35))
                        .rotationEffect(.init(degrees: hideRectangle ? 180 : 0))
                })
            }

            HStack {
                FireSmokStatusViewCell(status: "Fire",
                                       imageString: "fire",
                                       circleColor: .fireCircleColor,
                                       pulseAnimation: self.$stopAnimation)
                FireSmokStatusViewCell(status: "Smoke",
                                       imageString: "heat-haze (1)",
                                       circleColor: .smokeCircleColor,
                                       pulseAnimation: self.$stopAnimation)
                            .padding()
                FireSmokStatusViewCell(status: "Lost",
                                       imageString: "eye",
                                       circleColor: .lostCircleColor,
                                       pulseAnimation: self.$stopAnimation)
            }.opacity(hideRectangle ? 0 : 1)
        }
        .padding(.bottom, hideRectangle ? -180 : 0 )
        .animation(.spring())
        
    }
}

struct FireSmokeStatusView_Previews: PreviewProvider {
    static var previews: some View {
        FireSmokeStatusView()
    }
}
