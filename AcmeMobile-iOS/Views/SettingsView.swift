//
//  SettingsView.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 7/4/23.
//

import Firebase
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var vm: MainViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var name = ""
    @State private var email = ""
    @State private var img: UIImage = UIImage(named: "EmptyImage")!
    @State private var showingLogoutAlert = false
    @State private var showingDeleteAlert = false

    private var textFieldBgColor = Color.gray.opacity(0.2)

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                userFields
                bottomButtons
                devSettings
            }.frame(maxWidth: 600)
        }
        .padding(.horizontal)
        .onAppear(perform: {
            populateFields()
        })
    }

    var userFields: some View {
        VStack {
            UploadImageButton(image: $img)
            customTextField(title: "Name", text: $name, backgroundColor: textFieldBgColor)
            customButton(title: "Save Changes", backgroundColor: .accentColor, foregroundColor: .white, action: saveChanges)
                .padding(.top, 10)
        }
    }

    var devSettings: some View {
        VStack {
            if vm.devMode {
                HStack {
                    Text("Developer Settings")
                        .font(.footnote)
                        .fontWeight(.medium)
                    Spacer()
                }.padding(.top)
                Divider()
                customTextField(title: "MQTT ClientID", text: $vm.MQTTClientId, backgroundColor: textFieldBgColor)
                customTextField(title: "MQTT Host", text: $vm.MQTTHost, backgroundColor: textFieldBgColor)
                customTextField(title: "MQTT Port", text: $vm.MQTTPort, backgroundColor: textFieldBgColor, isNumbersOnly: true)
                customTextField(title: "MQTT Topic", text: $vm.MQTTTopic, backgroundColor: textFieldBgColor, isNumbersOnly: true)
                customButton(title: "Connect to MQTT", backgroundColor: .accentColor, foregroundColor: .white){
                    
                    vm.connectMQTT(startedByDev: true)
                }
                    .padding(.top, 10)

                customButton(title: "Generate new trips", backgroundColor: .accentColor, foregroundColor: .white, action: vm.addRandomTripsToFirestore)
                    .padding(.bottom)
            }
        }
    }

    var bottomButtons: some View {
        HStack {
            customButton(title: "Sign Out", backgroundColor: .orange, foregroundColor: .white) {
                showingLogoutAlert = true
            }
            .alert(isPresented: $showingLogoutAlert) {
                Alert(
                    title: Text("Log out?"),
                    message: Text("Are you sure you want to log out?"),
                    primaryButton: .destructive(Text("Log out")) {
                        vm.signOut()
                    },
                    secondaryButton: .cancel()
                )
            }

            customButton(title: "Delete Account", backgroundColor: .red, foregroundColor: .white) {
                showingDeleteAlert = true
            }
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("Delete account?"),
                    message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        vm.deleteUserAccount()
                    },
                    secondaryButton: .cancel()
                )
            }
        }.padding(.top, 20)
    }

    private func populateFields() {
        name = vm.currentUser?.name ?? ""
        email = vm.currentUser?.email ?? ""
        // load profile picture from url
        if let pfpURL = vm.currentUser?.pfpURL {
            Task {
                guard let url = URL(string: pfpURL) else { return }
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    img = UIImage(data: data) ?? UIImage(named: "EmptyImage")!
                } catch {
                    print(error)
                }
            }
        }
    }

    private func saveChanges() {
        vm.isLoading = true
        guard let currentUser = vm.currentUser else { return }
        var updatedUser = currentUser
        if name != currentUser.name && name.count > 0 {
            updatedUser.name = name
        }
        Task {
            // update user data in firestore
            do {
                vm.saveUserData(updatedUser)
                // update profile picture in storage
                if let imgData = img.jpegData(compressionQuality: 0.8) {
                    let storageRef = FirebaseManager.shared.storage.reference().child("ProfilePictures").child(currentUser.UID)
                    _ = try await storageRef.putDataAsync(imgData)
                    let imgURL = try await storageRef.downloadURL()
                    updatedUser.pfpURL = imgURL.absoluteString
                    // update user data in firestore with new profile picture url
                    vm.saveUserData(updatedUser)
                }

                vm.fetchCurrentUser()
                vm.isLoading = false
                self.presentationMode.wrappedValue.dismiss()
            } catch {
                vm.isLoading = false
                vm.setError(error)
            }
        }
    }
}
