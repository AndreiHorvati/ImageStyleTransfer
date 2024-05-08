//
//  LoginView.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 11.04.2023.
//

import SwiftUI

enum LoginType {
    case login, createAccount
}

struct LoginView: View {
    @State private var selectedType: LoginType = .login
    @State private var selectedPaintingType: PaintingType = .vanGogh
    @State private var selectedPaintingIndex = 0 {
        didSet {
            if selectedPaintingIndex == PaintingType.allCases.count - 1 {
                selectedPaintingIndex = 0
            }
        }
    }
    
    @State private var loginUsername: String = ""
    @State private var loginPassword: String = ""
    @State private var loginResponse: String = ""
    @State private var loginValue: Int = 0
    
    @State private var createAccountUsername: String = ""
    @State private var createAccountEmail: String = ""
    @State private var createAccountPassword: String = ""
    @State private var createAccountConfirmPassword: String = ""
    @State private var createAccountResponse: String =  ""
    @State private var createAccountResponseColor: Color = .green
    
    @State private var paintingsMenuIsPresented: Bool = false
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : Fonts.serif(size: 48), .foregroundColor: UIColor.white]
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(spacing: 10) {
                PaintingView(painting: selectedPaintingType, pageType: .login)
                    .padding(.bottom, 35)
                    .onReceive(timer) { _ in
                        selectedPaintingIndex += 1
                        
                        withAnimation(.linear) {
                            selectedPaintingType = PaintingType.allCases.filter{ $0 != .none }[selectedPaintingIndex]
                        }
                    }
                
                headerView
                contentView
                    .frame(minHeight: 0.45 * Dimensions.screenHeight)
            }
        }
        .blueBackground()
        .fullScreenCover(isPresented: $paintingsMenuIsPresented) {
            MainTabMenu()
        }
    }
    
    private var headerView: some View {
        HStack(spacing: 15) {
            headerViewTitle(type: .login)
            headerViewTitle(type: .createAccount)
        }
    }
    
    private func headerViewTitle(type: LoginType) -> some View {
        VStack {
            Text(type == .login ? Strings.loginLabel : Strings.createAccountLabel)
                .foregroundColor(.white)
                .font(Font(Fonts.serif(size: 30)))
                .opacity(type == selectedType ? 1 : 0.3)
                .frame(width: Dimensions.screenWidth / 2, height: 0.10 * Dimensions.screenHeight)
                .multilineTextAlignment(.center)
                .onTapGesture {
                    withAnimation {
                        self.selectedType = type
                    }
                }
            
            Divider()
                .frame(minHeight: 5)
                .background(Color.yellow)
                .opacity(type == selectedType ? 1 : 0)
        }
    }
    
    private var contentView: AnyView {
        selectedType == .login ? AnyView(loginContent) : AnyView(createAccountContent)
    }
    
    private var loginContent: some View {
        VStack(spacing: 50) {
            VStack(spacing: 20) {
                TextField(Strings.usernameLabel, text: $loginUsername)
                    .formTextField(iconSystemName: "person.fill")
                
                SecureField(Strings.passwordLabel, text: $loginPassword)
                    .formTextField(iconSystemName: "lock.fill")
            }
            
            loginButton
 
            Text(loginResponse)
                .font(Font(Fonts.serif(size: 18)))
                .foregroundColor(.red)
        }
        .padding(.horizontal, 40)
    }
    
    private var loginButton: some View {
        Button {
            AppDependencies.shared.authenticationService.loginUser(username: loginUsername, password: loginPassword) { success, token in
                if success {
                    paintingsMenuIsPresented.toggle()
                    AppDependencies.shared.userDefaultsService.setToken(token)
                } else {
                    loginResponse = Strings.failedAuthentication
                }
            }
        } label: {
            Text(Strings.loginLabel)
                .foregroundColor(.white)
                .font(Font(Fonts.serif(size: 24)))
                .padding(.vertical, 15)
                .padding(.horizontal, 30)
                .background(Color(Colors.darkBlue))
                .cornerRadius(16)
        }
    }
    
    private var createAccountContent: some View {
        VStack(spacing: 50) {
            VStack(spacing: 20) {
                HStack(spacing: 10) {
                    TextField(Strings.usernameLabel, text: $createAccountUsername)
                        .formTextField(iconSystemName: "person.fill", fontSize: 13)
                    
                    TextField(Strings.emailLabel, text: $createAccountEmail)
                        .formTextField(iconSystemName: "envelope.fill", fontSize: 13)
                }
                
                HStack(spacing: 10) {
                    SecureField(Strings.passwordLabel, text: $createAccountPassword)
                        .formTextField(iconSystemName: "lock.fill", fontSize: 13)
                    
                    SecureField(Strings.confirmPasswordLabel, text: $createAccountConfirmPassword)
                        .formTextField(iconSystemName: "lock.fill", fontSize: 13)
                }
            }
            
            createAccountButton
            
            Text(createAccountResponse)
                .font(Font(Fonts.serif(size: createAccountResponseColor == .green ? 18 : 14)))
                .foregroundColor(createAccountResponseColor)
        }
        .padding(.horizontal, 10)
    }
    
    private var createAccountButton: some View {
        Button {
            if createAccountPassword == createAccountConfirmPassword {
                AppDependencies.shared.userService.createUser(username: createAccountUsername, email: createAccountEmail, password: createAccountPassword) { success, user in
                    createAccountResponse = success ? Strings.successfullyCreatedAccountLabel : user.errors
                    createAccountResponseColor = success ? .green : .red
                    
                    if success {
                        clearCreateAccountForm()
                    }
                }
            }
        } label: {
            Text(Strings.createAccountLabel)
                .multilineTextAlignment(.center)
                .font(Font(Fonts.serif(size: 20)))
                .foregroundColor(.white)
                .padding(8)
        }
        .buttonStyle(BorderedButtonStyle())
    }
    
    private func clearCreateAccountForm() {
        createAccountUsername = ""
        createAccountEmail = ""
        createAccountPassword = ""
        createAccountConfirmPassword = ""
    }
}
