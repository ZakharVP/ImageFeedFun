//
//  JSONDecoder.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 17.03.2025.
//
import Foundation

extension JSONDecoder {
    static let iso8601Custom: JSONDecoder = {
        let decoder = JSONDecoder()
        
        // Настраиваем кастомное декодирование даты
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            let iso8601DateFormatter = ISO8601DateFormatter()
            if let date = iso8601DateFormatter.date(from: dateString) {
                return date
            } else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Неверный формат даты: \(dateString)"
                )
            }
        }
        
        return decoder
    }()
}
