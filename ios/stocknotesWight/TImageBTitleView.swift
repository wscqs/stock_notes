//
//  TImageBTitleView.swift
//  ttttttttt
//
//  Created by 1 on 2023/3/20.
//

import SwiftUI

struct TImageBTitleView: View {
    var imageString:String=""
    var topTitle:String=""
    var title:String=""
    var blackColor: Color = .white
    var backgroundColor: Color = .red
    var body: some View {
        VStack(spacing:2) {
            Text(String(self.title.prefix(2))).font(.system(size: 12)).foregroundColor(blackColor)
            Text(String(self.title.suffix(2))).font(.system(size: 12)).foregroundColor(blackColor)
        }
        .padding(.all,16)
        .background(
            backgroundColor
        )
        .clipShape(.circle)

        
    }
}

struct TImageBTitleView_Previews: PreviewProvider {
    static var previews: some View {
        TImageBTitleView()
    }
}
