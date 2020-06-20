//
//  ContentView.swift
//  speedometer
//
//  Created by Kfir Breger on 19/06/2020.
//  Copyright © 2020 Conopa. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var locationManager = LocationManager()
    
    var body: some View {
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(.all)
            Text("\(locationManager.speedString)")
                .font(.system(size: 72))
                .fontWeight(.thin)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.white)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
