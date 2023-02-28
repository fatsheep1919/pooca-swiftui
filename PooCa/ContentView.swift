//
//  ContentView.swift
//  PooCa
//
//  Created by 许文阳 on 2023/2/27.
//

import SwiftUI

struct BottomTabView: View {
  @Binding var index: Int
  
  var body: some View {
    HStack(spacing: 0) {
      Button(action: {
        if self.index != 1 {
          self.index = 0 // 取消失去焦点时的动画
          withAnimation(.interpolatingSpring(stiffness: 170, damping: 8)) {
            // 获得焦点时展示动画
            self.index = 1
          }
        }
      }) {
        VStack {
          Image("poo")
            .resizable()
            .frame(width: 40, height: 40)
            .padding(.top, 10)
            .scaleEffect(self.index == 1 ? 1.2 : 1, anchor: .bottom)

          Text("打卡")
            .font(.footnote)
            .padding(.vertical, 2)
            .foregroundColor(.black)
        }
      }
      .padding(.leading, 55)
      .padding(.trailing, 40)
      .padding(.vertical, 5)
      .background(self.index == 1 ? .brown.opacity(0.5) : .brown.opacity(0))
      
      Spacer()
        
      Button(action: {
        if self.index != 2 {
          self.index = 0;
          withAnimation(.interpolatingSpring(stiffness: 170, damping: 8)) {
            self.index = 2
          }
        }
      }) {
        VStack {
          Image("poo")
            .resizable()
            .frame(width: 40, height: 40)
            .padding(.top, 10)
            .scaleEffect(self.index == 2 ? 1.2 : 1, anchor: .bottom)

          Text("今天")
            .font(.footnote)
            .padding(.vertical, 2)
            .foregroundColor(.black)
        }
      }
      .padding(.horizontal, 40)
      .padding(.vertical, 5)
      .background(self.index == 2 ? .brown.opacity(0.5) : .brown.opacity(0))
      
      Spacer()
        
      Button(action: {
        if self.index != 3 {
          self.index = 0
          withAnimation(.interpolatingSpring(stiffness: 170, damping: 8)) {
            self.index = 3
          }
        }
      }) {
        VStack {
          Image("poo")
            .resizable()
            .frame(width: 40, height: 40)
            .padding(.top, 10)
            .scaleEffect(self.index == 3 ? 1.2 : 1, anchor: .bottom)

          Text("日历")
            .font(.footnote)
            .padding(.vertical, 2)
            .foregroundColor(.black)
        }
      }
      .padding(.leading, 40)
      .padding(.trailing, 55)
      .padding(.vertical, 5)
      .background(self.index == 3 ? .brown.opacity(0.5) : .brown.opacity(0))
    }
    .background(.brown.opacity(0.5))
  }
}

struct ContentView: View {
  @State var index = 1;

  var body: some View {
      ZStack(alignment: .bottom) {
        Color("primary")
          .edgesIgnoringSafeArea(.top)
        
        VStack(spacing: 0) {
          if self.index == 1 {
            PunchView()
          } else if self.index == 2 {
            TodayView()
          } else if self.index == 3 {
            CalendarView()
          }
          
          BottomTabView(index: $index)
        }
      }
      .ignoresSafeArea(.keyboard)
  }
}
