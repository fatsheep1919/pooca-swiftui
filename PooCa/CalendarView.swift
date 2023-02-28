//
//  CalendarView.swift
//  PooCa
//
//  Created by 许文阳 on 2023/2/27.
//

import SwiftUI

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

struct CalendarView: View {
  @EnvironmentObject var pooStore: PooStore
  @State var showDetailView = false
  @State var detailData: [Poo] = []
  
  private var monthStr: String {
    let formatter = DateFormatter();
    formatter.dateFormat = "YYYY-MM";
    return formatter.string(from: Date());
  }
  
  private var weekDayOfFirstDay: Int {
    let today = Date()
    let firstDayOfMonth = today.startOfMonth()
    return Calendar.current.component(.weekday, from: firstDayOfMonth)
  }
  
  private var lastDay: Int {
    let today = Date()
    let lastDayOfMonth = today.endOfMonth()
    return Calendar.current.dateComponents([.day], from: lastDayOfMonth).day!
  }
  
  private var pooOfMonth: [Poo] {
    pooStore.pooArr.filter { poo in
      poo.date.starts(with: monthStr)
    }
  }
  
  private var formatData: [[Poo]] {
    var data: [[Poo]] = []
    if weekDayOfFirstDay > 1 {
      data = (0..<weekDayOfFirstDay - 1).map { index in
        []
      }
    }
    
    data += (1...lastDay).map { index in
      pooOfMonth.filter { poo in
        poo.date == monthStr + "-" + (index < 10 ? "0\(index)" : "\(index)")
      }
    }
    
    return data;
  }
  
  private var gridItemLayout = [
    GridItem(.flexible(), spacing: 1),
    GridItem(.flexible(), spacing: 1),
    GridItem(.flexible(), spacing: 1),
    GridItem(.flexible(), spacing: 1),
    GridItem(.flexible(), spacing: 1),
    GridItem(.flexible(), spacing: 1),
    GridItem(.flexible(), spacing: 1)
  ]

  var body: some View {
    VStack {
      HStack {
        Text(monthStr).font(.title2)
      }
      .padding(.top, 10)

      LazyVGrid(columns: gridItemLayout, spacing: 2) {
        ForEach(Array(formatData.enumerated()), id: \.offset) { index, item in
          ZStack {
            RoundedRectangle(cornerRadius: 10)
              .frame(width: 49, height: 50)
              .foregroundColor(item.count > 0 ? .yellow.opacity(0.5) : .gray.opacity(0.2))
              .opacity(index - weekDayOfFirstDay + 2 >= 1 ? 1 : 0)
            
            if index - weekDayOfFirstDay + 2 >= 1 {
              VStack(spacing: 1) {
                if item.count > 0 {
                  Image("poo")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.top, 5)
                    .padding(.bottom, 1)
                } else {
                  Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.top, 5)
                    .padding(.bottom, 1)
                    .foregroundColor(.gray)
                }

                Text("\(index - weekDayOfFirstDay + 2)")
                  .foregroundColor(index % 7 == 6 || index % 7 == 0 ? .red : .black)
              }
            }
          }
          .onTapGesture {
            self.detailData = item
            self.showDetailView = item.count > 0
          }
        } // for
      } // grid
      
      VStack(alignment: .leading, spacing: 10) {
        HStack {
          Spacer()
        }

        Text("本月累计: \(pooOfMonth.count)次")
          .font(.title3)
//        Text("连续拉粑粑: 最长\(3)天").font(.title3)
//        Text("连续不拉粑粑: 最长\(3)天").font(.title3)
      }
      .padding(15)
      
      Spacer()
    }
    .padding(.horizontal, 20)
    .overlay(
      showDetailView
      ? DetailView(showDetailView: $showDetailView, detailData: $detailData)
      : nil
    )
  }
}

struct CalendarView_Previews: PreviewProvider {
  static var previews: some View {
    CalendarView()
  }
}
