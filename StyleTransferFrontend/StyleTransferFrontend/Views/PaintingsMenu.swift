//
//  PaintingsMenu.swift
//  StyleTransferFrontend
//
//  Created by Andrei Horvati on 19.03.2023.
//

import SwiftUI
import UserNotifications

enum PageType {
    case login, menu
}

struct PaintingsMenu: View {
    @State private var image: UIImage?
    @State private var selectedPainting: PaintingType? = nil
    @State private var showingCameraConfirmationDialog = false
    @State private var showingCameraView = false
    @State private var cameraSourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        VStack {
            cameraButton
            pantingsGridView
        }
        .padding(.top)
        .blueBackground()
        .foregroundColor(.white)
        .sheet(isPresented: $showingCameraView) {
            CameraView(image: self.$image, sourceType: self.cameraSourceType)
        }
        .onChange(of: self.image?.jpegData(compressionQuality: 0.8)) { newImageData in
            sendImageToServer(imageData: newImageData)
        }
    }
    
    var cameraButton: some View {
        Button(action: {
            self.showingCameraConfirmationDialog.toggle()
        }, label: {
            HStack {
                Image(systemName: "camera")
                
                Text(Strings.takeAPictureLabel)
            }
            .font(.title2)
            .frame(width: Dimensions.screenWidth * 0.8, height: 30)
        })
        .disabled(selectedPainting == nil)
        .buttonStyle(BorderedButtonStyle())
        .confirmationDialog("", isPresented: $showingCameraConfirmationDialog) {
            Button {
                self.cameraSourceType = .camera
                self.showingCameraView.toggle()
            } label: {
                Text(Strings.cameraLabel)
            }
            
            Button {
                self.cameraSourceType = .photoLibrary
                self.showingCameraView.toggle()
            } label: {
                Text(Strings.photoLibraryLabel)
            }
        }
    }
    
    var pantingsGridView: some View {
        let columns = [
            GridItem(.fixed(Dimensions.screenWidth / 2.2)),
            GridItem(.fixed(Dimensions.screenWidth / 2.2))
        ]
        
        return ScrollView {
            LazyVGrid(columns: columns, spacing: 40) {
                ForEach(PaintingType.allCases.filter { $0 != .none } , id: \.self) { painting in
                    PaintingView(painting: painting)
                        .shadow(color: painting == selectedPainting ? .white : .black, radius: 5)
                        .onTapGesture {
                            if self.selectedPainting?.id == painting.id {
                                self.selectedPainting = nil
                            } else {
                                self.selectedPainting = painting
                            }
                        }
                }
            }
            .padding()
        }
    }
}

extension PaintingsMenu {
    private func sendImageToServer(imageData: Data?) {
        if let selectedPainting, let imageData {
            let paintingRequest = PaintingRequest(imageData: imageData, paintingType: selectedPainting)
            
            AppDependencies.shared.paintingService.createPainting(paintingRequest: paintingRequest) {
                showPaintingIsFinishedNotification()
            }
        }
    }
    
    private func showPaintingIsFinishedNotification() {
        let content = UNMutableNotificationContent()
        
        content.title = "Painting Creation"
        content.subtitle = "Your painting is finished. Open gallery to view it!"
        content.body = "Your painting is finished. Open gallery to view it!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error {
                print("asdasd")
                print("Error displaying notification: \(error.localizedDescription)")
            }
        }
    }
}

struct PaintingsMenu_Previews: PreviewProvider {
    static var previews: some View {
        PaintingsMenu()
            .preferredColorScheme(.dark)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        print("GO IN HERE")
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        
    }
}
