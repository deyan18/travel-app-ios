//
//  MainViewModel.swift
//  AcmeMobile-iOS
//
//  Created by Deyan on 6/4/23.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import Firebase
import FirebaseFirestore
import MapKit

class MainViewModel: ObservableObject {
    @Published var signedIn = false
    @Published var currentUser: User?
    @Published var isLoading: Bool = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var trips: [Trip] = []

    private var usersListener: ListenerRegistration?

    /*func fetchCurrentUser() async {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }

        do{
            let user = try await FirebaseManager.shared.firestore.collection("Users").document(uid).getDocument(as: User.self)

            await MainActor.run(body: {
                self.currentUser = user
            })
        }catch{
            
        }
    }*/

    func fetchCurrentUser() {
        guard let userUID = FirebaseManager.shared.auth.currentUser?.uid else { return }

        usersListener?.remove()

        usersListener = FirebaseManager.shared.firestore
            .collection("Users")
            .document(userUID)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print("Error:", error)
                    return
                }

                guard let document = documentSnapshot, document.exists else {
                    print("Document does not exist")
                    return
                }

                do {
                    self.currentUser = try document.data(as: User.self)
                    // Do something with the updated user data here
                } catch let error {
                    print("Error decoding user data: \(error.localizedDescription)")
                }
            }
    }


    func alertUser(_ message: String){
        alertMessage = message
        self.isLoading = false
        showAlert.toggle()
    }

    func setError(_ error: Error) {
        alertUser(error.localizedDescription)
    }

    func signOut() {
        self.signedIn = false
        try? FirebaseManager.shared.auth.signOut()
    }

    func googleLogin(){

        self.isLoading = true

        guard let clientID = FirebaseApp.app()?.options.clientID else { return }



        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.configuration = config



        GIDSignIn.sharedInstance.signIn(withPresenting: UIApplication.shared.getRootViewController()) { user, error in
            if let error = error {
                self.setError(error)
                return
            }

            guard let idToken = user?.user.idToken else {
                self.isLoading = false
                return
            }

            guard let accessToken = user?.user.accessToken else {
                self.isLoading = false
                return
            }



            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)

            let config = GIDConfiguration(clientID: clientID)

            GIDSignIn.sharedInstance.configuration = config

            // Firebase Authentication
            Auth.auth().signIn(with: credential) {result, err in
                self.isLoading = false
                if let err = err {
                    print(err.localizedDescription)
                    return
                }

                guard let userData = result?.user else {
                    return
                }

                FirebaseManager.shared.firestore.collection("Users").document(userData.uid).getDocument { snapshot, error in
                    if !snapshot!.exists{
                        let user = User(UID: userData.uid, email: userData.email ?? "", name: userData.displayName ?? "", pfpURL: userData.photoURL?.absoluteString ?? "")
                        self.saveUserData(user)
                        self.fetchCurrentUser()

                    }
                }

                self.signedIn = true

                self.fetchCurrentUser()
                

            }

        }


    }

    func saveUserData(_ user: User){

        do{
            try FirebaseManager.shared.firestore.collection("Users").document(user.UID).setData(from: user, merge: true)
        }catch{
            self.setError(error)
        }
    }
    

    func deleteUserAccount() {
        self.isLoading = true
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }


        FirebaseManager.shared.auth.currentUser?.delete(completion: { err in
            if let err = err {
                self.isLoading = false
                self.setError(err)
                return
            }
            let refImg = FirebaseManager.shared.storage.reference(withPath: "ProfilePictures/\(uid)")

            refImg.delete { err in
                if let err = err {
                    print("Error: \(err)")
                }
            }

            FirebaseManager.shared.firestore.collection("Users")
                .document(uid).delete { err in
                    if let err = err {
                        print("Error: \(err)")
                    }
                    self.signedIn = false
                }


            self.isLoading = false
        })
    }

    func isGoogleUser() -> Bool{
        let providerId = Auth.auth().currentUser?.providerData.first?.providerID

        return providerId == "google.com"
    }

    func createTrip(trip: Trip) {
        do{

            try FirebaseManager.shared.firestore.collection("Trips").document(trip.UID).setData(from: trip, merge: true)
            print("Setted trip to firebase")
        }catch{
            print("Error Setting trip to firebase", error)
            self.setError(error)
        }
    }

    func fetchTrips() {
        FirebaseManager.shared.firestore
            .collection("Trips")
            .order(by: "startDate")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error:", error)
                    return
                }
                self.trips.removeAll()
                querySnapshot?.documents.forEach({ queryDoc in
                    do{
                        try self.trips.append(queryDoc.data(as: Trip.self))
                    }catch{
                        //print("Error fetching trip:", error)
                    }

                })
            }
    }


    func addRandomTripsToFirestore() {
        let cities = ["San Franc.", "New York", "Almeria", "Seoul", "Sofia", "Budapest", "Tokyo", "Paris"]
        let cityImages = [        "San Franc.": "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/elle-los-angeles02-1559906859.jpg",        "New York": "https://media.timeout.com/images/105124812/image.jpg",        "Almeria": "https://media.traveler.es/photos/61375dc1bae07f0d8a49206d/master/w_1600%2Cc_limit/209774.jpg",        "Seoul": "https://media.cntraveler.com/photos/6123f6bb7dfe5dff926c7675/3:2/w_2529,h_1686,c_limit/South%20Korea_GettyImages-1200320719.jpg",        "Sofia": "https://www.adonde-y-cuando.es/site/images/illustration/oualler/bulgarie-sofia_702.jpg",        "Budapest": "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/budapest-danubio-parlamento-1552491234.jpg",        "Tokyo": "https://planetofhotels.com/guide/sites/default/files/styles/node__blog_post__bp_banner/public/live_banner/Tokyo.jpg",        "Paris": "https://elpachinko.com/wp-content/uploads/2019/03/10-lugares-imprescindibles-que-visitar-en-Par%C3%ADs.jpg"]
        let cityCoordinates = [        "San Franc.": CLLocationCoordinate2D(latitude: 37.773972, longitude: -122.431297),        "New York": CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242),        "Almeria": CLLocationCoordinate2D(latitude:  36.838139, longitude: -2.459740),        "Seoul": CLLocationCoordinate2D(latitude: 127.024612, longitude: 37.532600),        "Sofia": CLLocationCoordinate2D(latitude: 42.698334, longitude: 23.319941),        "Budapest": CLLocationCoordinate2D(latitude: 47.497913, longitude: 19.0402362),        "Tokyo": CLLocationCoordinate2D(latitude: 139.839478, longitude: 35.652832),        "Paris": CLLocationCoordinate2D(latitude: 2.349014, longitude: 48.864716)] as [String : CLLocationCoordinate2D]
        let today = Date()
        for _ in 0..<10 {
            var fromCity = ""
            var toCity = ""
            while fromCity == toCity {
                fromCity = cities.randomElement()!
                toCity = cities.randomElement()!
            }
            let departureDate = Calendar.current.date(byAdding: .day, value: Int.random(in: 1...365), to: today)!
            let returnDate = Calendar.current.date(byAdding: .day, value: Int.random(in: 1...7), to: departureDate)!
            let trip = Trip(
                UID: UUID().uuidString,
                origin: fromCity,
                destination: toCity,
                price: Double(Int.random(in: 50...1000)),
                startDate: departureDate,
                endDate: returnDate,
                description: "A trip to \(toCity). Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc scelerisque neque in risus aliquet laoreet. Nulla quis dapibus velit. Proin eu dolor ipsum. Morbi et orci a tortor luctus feugiat at quis dolor. Nullam vel mi leo. Fusce justo eros, accumsan id aliquam ac, pellentesque nec neque.",
                imageURL: cityImages[toCity] ?? "",
                originCoordinate: cityCoordinates[fromCity] ?? CLLocationCoordinate2D(),
                destinationCoordinate: cityCoordinates[toCity] ?? CLLocationCoordinate2D()
            )
                print("SUBIENDO TRIP:", trip)
                createTrip(trip: trip)


        }

    }

    func bookmarkTrip(tripID: String) {
        guard let user = currentUser else { return }


        if user.bookmarkedTrips.contains(tripID){
            FirebaseManager.shared.firestore.collection("Users").document(user.UID).updateData([
                "bookmarkedTrips": FieldValue.arrayRemove([tripID])
            ]) { error in
                if let error = error {
                    print("Error removing trip from bookmarked trips: \(error.localizedDescription)")
                }
            }
        } else {
            FirebaseManager.shared.firestore.collection("Users").document(user.UID).updateData([
                "bookmarkedTrips": FieldValue.arrayUnion([tripID])
            ]) { error in
                if let error = error {
                    print("Error adding trip to bookmarked trips: \(error.localizedDescription)")
                }
            }
        }

    }

    func purchaseTrip(tripID: String) {
        guard let user = currentUser else { return }
        if !user.purchasedTrips.contains(tripID){
            FirebaseManager.shared.firestore.collection("Users").document(user.UID).updateData([
                "purchasedTrips": FieldValue.arrayUnion([tripID])
            ]) { error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }

    }


   
}
