import Foundation

class StockMaximize {

    func countProfit(prices: [Int]) -> Int {
        var copyOfPrices = prices
        var maxProfit = 0

        while !copyOfPrices.isEmpty {
            let saveCopy = copyOfPrices
            guard let maxPrice = copyOfPrices.max() else { return 0}
            var moneySpent = 0
            let indexOfMax = Int(copyOfPrices.firstIndex(of: maxPrice) ?? 0)
            if indexOfMax != 0 {
                for _ in 0...indexOfMax - 1 {
                    moneySpent += copyOfPrices[0]
                    copyOfPrices.remove(at: 0)
                }
                maxProfit = maxProfit + indexOfMax * saveCopy[indexOfMax] - moneySpent
            } else {
                copyOfPrices.remove(at: 0)
            }
        }
        return maxProfit
    }
}
