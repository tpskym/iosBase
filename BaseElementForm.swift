//
//  BaseElementForm.swift
//  finChurche
//
//  Created by Алексей Сухов on 22.08.2020.
//  Copyright © 2020 Алексей Сухов. All rights reserved.
//

import SwiftUI

struct BaseElementForm: View {
    @ObservedObject var keyboard = KeyboardResponder()
    
    var detailView : AnyView
    var body: some View {
        detailView
            
        .padding(.bottom, keyboard.currentHeight + 20)
        .edgesIgnoringSafeArea(.bottom)
        .animation(.easeOut(duration: 0.16))
        
    }
}

struct BaseElementForm_Previews: PreviewProvider {
    static var previews: some View {
        BaseElementForm(detailView: AnyView(Text("ntrndn")) )
    }
}
