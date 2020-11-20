//
//  model.swift
//  beckendService
//
//  Created by Vinicius Alencar on 19/11/20.
//

import Foundation

protocol CoinManagerDelegate {
    
    func didUpdatePrice(price: String, currency: String)
    
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate : CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "196CB4B7-3B1D-49CD-B1B2-BE1D263E9D51"
    
    let currencyArray = ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice (for currency: String){
        
        //Usando concatenação de strings
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        // Desembrulhando URL criado a partir de "urlString"
        if let url = URL(string: urlString) {
            // Criando a sessão com configuração "default"
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let bitCoinPrice = self.parseJSON(safeData){
                        let priceString = String(format: "%.2f", bitCoinPrice)
                        
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
                
            }
            task.resume()
        }
        
    }
    
    func parseJSON(_ data: Data) -> Double? {
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            
            return lastPrice
            
        } catch{
            print(error)
            return nil
        }
        
        
    }
    
    

}
