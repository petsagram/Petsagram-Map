//
//  FireSmokStatusViewCell.swift
//  MapView
//
//  Created by Vahe Toroyan on 11/27/20.
//

import SwiftUI

struct FireSmokStatusViewCell: View {

    // MARK: - Properties

    @State var status: String
    @State var imageString: String
    @State var circleColor: Color
    @State var progressValue: Float = 0.0
    @State var pulseAnimation = false

    var body: some View {
        VStack(alignment: .center) {
            Button(action: {
                self.pulseAnimation.toggle()
                self.incrementProgress()
            }, label: {
                ZStack {
                    ZStack{
                        Circle()
                            .stroke(circleColor, lineWidth: 9)
                            .frame(width: 90,
                                   height: 90,
                                   alignment: .center)
                    }
                    Circle()
                        .trim(from: 0.0,
                              to: CGFloat(min(self.progressValue, 1.0)))
                        .stroke(style: StrokeStyle(lineWidth: 9.0,
                                                   lineCap: .round,
                                                   lineJoin: .round))
                        .foregroundColor(.animateCircleColor)
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.linear)
                        .frame(width: 90,
                               height: 90,
                               alignment: .center)

                    Image(self.imageString)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50,
                               height: 50)
                        .scaleEffect(pulseAnimation ? 1.1 : 1)
                        .opacity(pulseAnimation ? 0.8 : 1)
                        .animation(Animation.easeOut(duration: 0.4)
                                    .repeat(while: self.pulseAnimation)
                                    .speed(0.5))
                }
            })

            Text(self.status)
                .foregroundColor(Color(UIColor.white))
                .font(.system(size: 30))
                .bold()
                .shadow(radius: 5)
                .onTapGesture {
                    animate()
                }
        }
    }

    func incrementProgress() {
        self.progressValue = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                let randomValue = Float([0, 0.9, 0.72, 0.634, 0.716, 0.881, 0.3].randomElement()!)
                self.progressValue += randomValue
            }
          }
    }

    func animate() {
            self.progressValue = 0
            self.pulseAnimation = false
    }
}

struct FireSmokStatusViewCell_Previews: PreviewProvider {
    static var previews: some View {
        FireSmokStatusViewCell(status: "", imageString: "", circleColor: .clear)
    }
}


extension Animation {
    func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
        if expression {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}
