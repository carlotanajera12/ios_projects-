//
//  TriviaQuestionService.swift
//  Trivia
//

import Foundation

class TriviaQuestionService {

    func fetchQuestions(completion: @escaping ([TriviaQuestion]) -> Void) {
        let urlString = "https://opentdb.com/api.php?amount=5&type=multiple"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error:", error)
                return
            }

            guard let data = data else {
                print("No data returned")
                return
            }

            do {
                let decoded = try JSONDecoder().decode(TriviaResponse.self, from: data)
                completion(decoded.results)
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }
}
