//
//  PooStore.swift
//  PooCa
//
//  Created by 许文阳 on 2023/2/27.
//

import Foundation

class PooStore: ObservableObject {
  @Published var pooArr: [Poo] = []
  @Published var loaded: Bool = false
  
  var pooOfToday: [Poo] {
    let formatter = DateFormatter();
    formatter.dateFormat = "YYYY-MM-dd";
    let dayStr = formatter.string(from: Date());
    
    return pooArr.filter { poo in
      dayStr == poo.date
    }
  }
  
  func load(completion: @escaping (Result<[Poo], Error>) -> Void) {
    DispatchQueue.global(qos: .background).async {
      do {
        let dataFile = try PooStore.fileURL()
        guard let file = try? FileHandle(forReadingFrom: dataFile) else {
          DispatchQueue.main.async {
            completion(.success([]))
          }
          return;
        }
        
        let data = try JSONDecoder().decode([Poo].self, from: file.availableData)
        DispatchQueue.main.async {
          completion(.success(data))
        }
        
      } catch {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
      }
    }
  }
  
  func save(completion: @escaping (Result<Int, Error>) -> Void) {
    DispatchQueue.global(qos: .background).async {
      do {
        let data = try JSONEncoder().encode(self.pooArr)
        let dataFile = try PooStore.fileURL()
        try data.write(to: dataFile)
        DispatchQueue.main.async {
          completion(.success(self.pooArr.count))
        }
        
      } catch {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
      }
    }
  }
  
  private static func fileURL() throws -> URL {
    try FileManager.default.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: false
    )
    .appendingPathComponent("pooca.data")
  }
}
