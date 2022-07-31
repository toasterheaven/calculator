//
//  ContentView.swift
//  Calculator
//
//  Created by Randy Lucas on 7/30/22.
//

import SwiftUI

enum CalculatorButtons: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four  = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case decimal = "."
    case add = "+"
    case subtract = "-"
    case multiply = "*"
    case divide = "/"
    case equal = "="
    case clear = "AC"
    case plusminus = "+/-"
    case percent = "%"
}


struct ContentView: View {

    @State var storeValue = "0"
    @State var currentValue = "0"
    @State var currentOperator = ""
    @State var negative = false
    
    let cbuttons : [[CalculatorButtons]] = [
        [.clear, .plusminus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal]
    ]
    
    var body: some View {
        ZStack {
            VStack {
                Text(self.storeValue)
                Text(self.currentValue)
                VStack {
                    ForEach(cbuttons, id: \.self) {row in
                        HStack {
                            ForEach(row, id: \.self) {item in
                                Button(action: {
                                    self.buttonpress(press: item)
                                }, label: {
                                    Text(item.rawValue)
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    func buttonpress(press: CalculatorButtons) {
        switch press {
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
            PressNumber(pressValue: press.rawValue)
        case .decimal:
            PressDecimal()
        case .add, .subtract, .multiply, .divide:
            PressOperator(operation: press.rawValue)
        case .equal:
            Equal()
        case .clear:
            storeValue = "0"
            currentValue = "0"
            negative = false
            currentOperator = ""
        case .plusminus:
            PressNegative()
        case .percent:
            PressPercent()
        }
    }
    
    func PressNumber (pressValue : String){
        if currentOperator != "" {
            if self.storeValue == "0" {
                self.storeValue = "\(self.currentValue)\(self.currentOperator)"
            } else {
                self.storeValue = "\(self.storeValue)\(self.currentValue)\(self.currentOperator)"
            }
            self.currentValue = "0"
            self.currentOperator = ""
        }
        
        switch currentValue {
            case "0":
            self.currentValue = "\(pressValue)"
            case "-0":
            self.currentValue = "-\(pressValue)"
            default:
                self.currentValue = "\(self.currentValue)\(pressValue)"
        }
    }
    
    func PressDecimal() {
        if currentValue != "0" && !currentValue.contains(.init(".")){
                self.currentValue = "\(self.currentValue)."
            } else {
                if !currentValue.contains(.init(".")) {
                    self.currentValue = "0."
                }
            }
        //}
    }
    
    func PressNegative() {
        if !self.negative {
            self.negative = true
            self.currentValue = "-\(self.currentValue)"
        } else {
            self.negative = false
            self.currentValue = self.currentValue.replacingOccurrences(of: "-", with: "")
        }
    }
    
    func PressPercent() {
        let cvDecimal = Float(currentValue) ?? 0.0
        let percentMultiplier = Float(0.01)
        let percentValue = cvDecimal * percentMultiplier
        self.currentValue = String(percentValue)
    }
    
    func PressOperator (operation: String) {
        if currentValue != "0" || currentValue != "-0" {
            self.currentOperator = operation
        }
    }
    
    func Equal() {
        if storeValue != "0" {
            let myEquation = NSExpression(format: "\(storeValue)\(self.currentValue)")
            let myValue = myEquation.expressionValue(with: nil, context: nil) as! Double
            self.currentValue = RemoveTail(inputString: String(myValue))
            self.storeValue = "0"
        }
    }
    
    func RemoveTail(inputString: String) -> String {
        var result: String = ""
        let range = NSRange(location: 0, length: inputString.utf16.count)
        let regex = try! NSRegularExpression(pattern: "\\.0$")
        if regex.numberOfMatches(in: inputString, range: range) > 0 {
            result = inputString.trimmingCharacters(in: .init(charactersIn: ".0"))
        } else {result = inputString}
        
        return result
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
