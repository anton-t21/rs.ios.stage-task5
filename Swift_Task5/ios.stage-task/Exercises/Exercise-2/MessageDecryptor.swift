import UIKit

class MessageDecryptor: NSObject {
    
    func decodingInDepth(message: String) -> String {
        var array = Array(message)
        var flag = true
        
        while flag {
            if let closeIndex = array.firstIndex(where: { $0 == "]" }) {
                var startIndex = closeIndex
                var stopPoint = ""
                while stopPoint != "[" {
                    startIndex -= 1
                    stopPoint = String(array[startIndex])
                }
                var insertStr = ""
                var newStartIndex = startIndex + 1
                
                while newStartIndex != closeIndex {
                    insertStr += String(array[newStartIndex])
                    newStartIndex += 1
                }

                let thirdNumber  = String(array[startIndex - 1])
                var secondNumber = ""
                var firstNumber = ""
                if startIndex - 1 != 0 && array[startIndex - 2].isNumber {
                    secondNumber = String(array[startIndex - 2])
                    if startIndex - 2 != 0 && array[startIndex - 3].isNumber {
                        firstNumber = String(array[startIndex - 3])
                    }
                }
                guard let count = Int(firstNumber + secondNumber + thirdNumber) else { return insertStr }

                var newInsertStr = insertStr
                if count > 1 && count < 10 {
                    for _ in 1...count - 1 {
                        newInsertStr += insertStr
                    }
                    array.replaceSubrange(startIndex - 1...closeIndex, with: newInsertStr)
                }
                else if count >= 10 && count < 100{
                    for _ in 1...count - 1 {
                        newInsertStr += insertStr
                    }
                    array.replaceSubrange(startIndex - 2...closeIndex, with: newInsertStr)
                }
                else if count >= 100 {
                    for _ in 1...count - 1 {
                        newInsertStr += insertStr
                    }
                    array.replaceSubrange(startIndex - 3...closeIndex, with: newInsertStr)
                }
                else if count == 1 {
                    array.replaceSubrange(startIndex - 1...closeIndex, with: newInsertStr)
                }
                else {
                    array.removeSubrange(startIndex - 1...closeIndex)
                }
                flag = !flag
                if array.contains("]") {
                    flag = !flag
                }
            } else {
                flag = !flag
            }
        }
        var finalStr = ""
        for i in array {
            finalStr += String(i)
        }
        return finalStr
    }
    
    func decryptMessage(_ message: String) -> String {
        var array = Array(message)
        var flag = true
        
        while flag {
            if let lastIndex = array.firstIndex(where: { $0 == "]" }) {
                var openSymbolCount = 0
                guard let newStartIndex2 = array.firstIndex(where: { $0 == "[" }) else { return "" }

                var startIndex = newStartIndex2

                for i in 0...lastIndex - 1 {
                    if array[i] == "[" {
                        openSymbolCount += 1
                    }
                }

                let arrayLength = array.count
                var closeIndex = 0

                for i in lastIndex...arrayLength - 1 {
                    if array[i] == "]" {
                        openSymbolCount -= 1
                        if openSymbolCount == 0 {
                            closeIndex = i
                            break
                        }
                    }
                }
                if startIndex > 0 {
                    var prevSymb = array[startIndex - 1]
                    if prevSymb.isNumber {
                        startIndex -= 1
                        if startIndex > 0 {
                            prevSymb = array[startIndex - 1]
                            if prevSymb.isNumber {
                                startIndex -= 1
                                if startIndex > 0 {
                                    prevSymb = array[startIndex - 1]
                                    if prevSymb.isNumber {
                                        startIndex -= 1
                                    }
                                }
                            }
                        }
                    } else {
                        array.insert("1", at: startIndex - 1)
                        startIndex -= 1
                    }
                } else {
                    array.insert("1", at: 0)
                }
                var insertStr = ""
                var newStartIndex = startIndex
                
                while newStartIndex <= closeIndex {
                    insertStr += String(array[newStartIndex])
                    newStartIndex += 1
                }
                insertStr = decodingInDepth(message: insertStr)
                array.replaceSubrange(startIndex...closeIndex, with: insertStr)
                flag = !flag
                if array.contains("]") {
                    flag = !flag
                }
            }
            else {
                return message
            }
        }
        var finalStr = ""
        for i in array {
            finalStr += String(i)
        }
        return finalStr
    }
}
