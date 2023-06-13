// Project: Management Standards
//
//  
//

import SwiftUI

struct APPButtonText: View {
    
    var caption: String
    var buttonWidth: CGFloat?
    var buttonHeight: CGFloat = 50
    var backgroundColor: Color = Color(UIColor.systemBlue)
    var foregroundColor: Color = Color(UIColor.black)
    
    var body: some View {
        Text(caption)
            .font(.headline)
            .fontWeight(.semibold)
            .padding()
            .frame(width: buttonWidth, height: buttonHeight)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(14)
    }
}

struct ApButtonText_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            APPButtonText(caption: "Hello Steve", buttonWidth: 280)
                .previewLayout(.sizeThatFits)
            APPButtonText(caption: "Hello Steve")
                .previewLayout(.sizeThatFits)
            APPButtonText(caption: "Hello Steve", buttonHeight: 35)
                .previewLayout(.sizeThatFits)
            APPButtonText(caption: "Hello Steve",
                          backgroundColor: Color(.systemRed),
                          foregroundColor: Color.white)
                .previewLayout(.sizeThatFits)
        }
    }
}
