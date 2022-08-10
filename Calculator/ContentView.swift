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
    @State var myTemp = ""
    var lastoperator = ""
    var lastvalue = "0"
    
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
                Text(self.myTemp)
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
        if self.buttonpress == false and press.equal {
            Equal(repeat = true)
        } else {
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
                currentOperator = ""
            case .plusminus:
                PressNegative()
            case .percent:
                PressPercent()
            }
            self.buttonpress = true
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
    
    //Currently when you put in 20, press +/- (-20) and hit operator (*) then hit decimal (say, to mutiply times a decimal number (0.10), it appends the decimal to the first number (-20.) and when you type the next number it crashes.
    
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
    
    // Updated function to just check for he sign.

    func PressNegative() {
        if !self.currentValue(.init("-")) {
            self.currentValue = "-\(self.currentValue)"
        } else {
            self.currentValue = self.currentValue.replacingOccurrences(of: "-", with: "")
        }
    }
    
    //Using float, 100 * 20 % = .19999999. Changed to double, now it's working correctly.
    
    func PressPercent() {
        let cvDecimal = Double(currentValue) ?? 0.0
        let percentMultiplier = Double(0.01)
        let percentValue = cvDecimal * percentMultiplier
        self.currentValue = String(percentValue)
    }
    
    func PressOperator (operation: String) {
        if currentValue != "0" || currentValue != "-0" {
            self.currentOperator = operation
        }
    }
    
    //To fix the division errors, I decided to check for a "." in the equation string (before we store it as the equation string). If there's a decimal in the store or current value, no problem because the result will be a double. If not, I append .0 to the current value as we store the equation. It took me a while because it DOES NOT LIKE me putting the other two lines past the if/else... I think the NSExpression is picky or something. But by duplicating it in the if and the else it works like a champ...
    
    func Equal(repeat: bool = false) {
        if repeat == false {
            if storeValue != "0" {
                if ("\(storeValue)\(currentValue)").contains(.init(".")) {
                    let myEquation = NSExpression(format: "\(storeValue)\(self.currentValue)")
                    let myValue = myEquation.expressionValue(with: nil, context: nil) as! Double
                } else {
                    let myEquation = NSExpression(format: "\(storeValue)\(self.currentValue).0")
                    let myValue = myEquation.expressionValue(with: nil, context: nil) as! Double
                }
                self.lastValue = self.currentValue
                self.lastoperator = self.currentOperator

                self.currentValue = RemoveTail(inputString: String(myValue))
                self.storeValue = "0"
            }
        } else {
            //use NSExpression to use currentValue | lastoperator | lastvalue
        }
        self.buttonpress = false
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
