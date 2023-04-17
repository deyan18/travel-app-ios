# iOS Travel App

![App screenshots](https://i.imgur.com/S8i430c.png)

## Introduction

This project is an iOS app that expands on the original [Kotlin travel app](https://github.com/deyan18/TravelApp-Kotlin). It was developed as part of the "Master's Degree in Software Engineering: Cloud, Data, and Information Technology Management" program. The app is built using Swift and SwiftUI, and is designed to provide users with an easy and convenient way to search for trips.

## Learning Swift and SwiftUI

This was not my first time building an iOS app with SwiftUI, but I learned a lot of new things during the development of this app. Some of the things I learned include:

- How to use MapKit to display maps and add location-related functionalities to the app.
- Implementing MQTT with CocoaMQTT to enable real-time messaging and notifications in the app.
- Implementing sign-in with Google using Firebase authentication for seamless user authentication.
- How to use local notifications to provide alerts to users.
- How to use Codable for easy data serialization and deserialization.
- Using LazyGrid to create compact grid views for displaying trips.
- Adapting to the new updates in Swift for iOS 16 to ensure the app is up-to-date with the latest best practices.

## App Features

The iOS travel app comes with a wide range of features to enhance the user experience. Some of the key features include:

- Authentication with email and password using Firebase Authentication for secure and personalized user access.
- Authentication with Google using Firebase for seamless sign-in with Google accounts.
- Password recovery with Firebase Authentication.
- Storing users' profile images in Firebase Storage for easy retrieval and management.
- Getting trips from Firestore, a NoSQL cloud database, for efficient data retrieval and synchronization.
- Searching for trips based on origin and destination, allowing users to easily find trips that match their preferences.
- Filtering trips based on start and end date, enabling users to narrow down their search based on their travel dates.
- Filtering trips based on price range, allowing users to find trips that fit within their budget.
- Compact grid view of trips for a visually appealing and organized display of trip options.
- Accessing a detailed view of a trip to see more information, including a description, temperature of the destination, and a map displaying the origin, destination, and user's current location.
- Bookmarking trips for easy access to saved trips in the bookmarks view.
- Purchasing trips, with purchased trips displayed in the user profile for easy reference.
- Editing user profile to update personal information.
- Deleting user account, including all associated information, for user convenience.
- Trips becoming non-available when the start date passes the current date, with non-available trips hidden from the explore view but still accessible if bookmarked. Non-available trips cannot be purchased.
- App supports notifications using an MQTT connection, enabling real-time notifications for users.
- App supports iPadOS, adapting to the larger screen size for a seamless experience on iPad.
- App supports dark mode, providing a visually appealing and comfortable experience for users who prefer a darker interface.

## Future Development

In the future, I plan to continue the development of the app by adding more features and integrating Firebase analytics, notifications and more. I also plan to further enhance the app's user interface and user experience based on user feedback and suggestions.

## Conclusion

Overall, this project has been a valuable learning experience for me in Swift and SwiftUI, and I am excited about the future development of the app.
