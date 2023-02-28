//
//  PooCaApp.swift
//  PooCa
//
//  Created by 许文阳 on 2023/2/27.
//

import SwiftUI

@main
struct PooCaApp: App {
  @StateObject var pooStore: PooStore = PooStore()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(pooStore)
        .onAppear {
          pooStore.load { result in
            switch result {
            case .success(let data):
              pooStore.pooArr = data
            case.failure(let error):
              fatalError(error.localizedDescription)
            }
            
            pooStore.loaded = true
          }
        }
    }
  }
}
