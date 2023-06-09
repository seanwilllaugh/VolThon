//
//  StepperStyle.swift
//  DMMerch
//
//  Created by Sean Laughlin on 2/21/23.
//

import Foundation
import SwiftUI

protocol MyStepperStyle {
    associatedtype Body: View
    func makeBody(_ configuration: MyStepperStyleConfiguration) -> Body
}

struct MyStepperStyleConfiguration {
    var value: Binding<Int>
    var label: Label
    var range: ClosedRange<Int>
    
    struct Label: View {
        var underlyingLabel: AnyView
        
        var body: some View {
            underlyingLabel
        }
    }
}

struct DefaultStepperStyle: MyStepperStyle {
    func makeBody(_ configuration: MyStepperStyleConfiguration) -> some View {
        Stepper(value: configuration.value, in: configuration.range) {
            configuration.label
        }
    }
}

struct CapsuleStepperStyle: MyStepperStyle {
    func makeBody(_ configuration: MyStepperStyleConfiguration) -> some View {
        CapsuleStepper(configuration: configuration)
    }
}

struct CapsuleStepper: View {
    var configuration: MyStepperStyleConfiguration
    
    @Environment(\.controlSize)
    var controlSize
    
    var padding: Double {
        switch controlSize {
        case .mini: return 4
        case .small: return 6
        default: return 8
        }
    }
    
    var body: some View {
        HStack {
            configuration.label
            Spacer()
            HStack {
                Button("-") { configuration.value.wrappedValue -= 1 }
                Text(configuration.value.wrappedValue.formatted())
                Button("+") { configuration.value.wrappedValue += 1 }
            }
            .transformEnvironment(\.font, transform: { font in
                if font != nil { return }
                switch controlSize {
                case .mini: font = .footnote
                case .small: font = .callout
                default: font = .body
                }

            })
            .padding(.vertical, padding)
            .padding(.horizontal, padding * 2)
            .foregroundColor(.black)
            .background {
                Rectangle()
                    .border(.orange)
            }
        }
        .buttonStyle(.plain)
    }
}

struct MyStepper<Label: View, Style: MyStepperStyle>: View {
    @Binding var value: Int
    var `in`: ClosedRange<Int> // todo
    @ViewBuilder var label: Label
    var style: Style
    
    var body: some View {
        style.makeBody(.init(value: $value, label: .init(underlyingLabel: AnyView(label)), range: `in`))
    }
}

extension MyStepperStyle where Self == DefaultStepperStyle {
    static var `default`: DefaultStepperStyle { return .init() }
}
