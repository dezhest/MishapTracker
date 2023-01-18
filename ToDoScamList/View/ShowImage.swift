//
//  MoreDetailed.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 17.01.2023.
//

import SwiftUI

struct ShowImage: View {
    @Binding var image: Image
    var body: some View {
       image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .pinchToZoom()
    }
}

struct ShowImage_Previews: PreviewProvider {
    static var previews: some View {
        ShowImage(image: .constant(Image("Scam")))
    }
}
