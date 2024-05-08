//
//  AccountView.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 22.04.2023.
//

import SwiftUI


struct AccountView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var numberOfIterations: CGFloat = 10
    @State private var modelSelection: NeuralNetworkModel = .vgg19
    
    var body: some View {
        VStack {
            List {
                Section(header: Text(Strings.numberOfIterationsLabel(number: Int(numberOfIterations)))) {
                    Slider(value: $numberOfIterations, in: Dimensions.minimumNumberOfIterations...Dimensions.maximumNumberOfIterations, step: 1)
                        .tint(Color(Colors.darkBlue))
                        .onChange(of: numberOfIterations) { newNumber in
                            AppDependencies.shared.userDefaultsService.setNumberOfIterations(Int(newNumber))
                        }
                }
                
                Section(header: Text(Strings.modelLabel)) {
                    Picker("Please select your favorite model", selection: $modelSelection) {
                        ForEach(NeuralNetworkModel.allCases, id: \.self) { model in
                            Text(model.title)
                        }
                    }
                    .pickerStyle(InlinePickerStyle())
                    .onChange(of: modelSelection) { newModel in
                        AppDependencies.shared.userDefaultsService.setModel(newModel.rawValue)
                    }
                }
            }
            
            Button {
                AppDependencies.shared.userDefaultsService.removeAll()
                dismiss()
            } label: {
                Text(Strings.logoutButtonLabel)
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 30)
                    .background(Color(Colors.darkBlue))
                    .cornerRadius(16)
            }
        }
        .padding(.bottom)
    }
}
