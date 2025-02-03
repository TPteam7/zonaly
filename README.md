# Zonaly

## Overview
Zonaly is a Geospatial Screen-Time Mobile App designed to help users manage their digital habits by enforcing location-based restrictions on app usage. By integrating Apple's Screen Time API and Core Location Framework, the app enables users to limit access to specific apps based on their physical location, promoting productivity and mindful technology use.

## Features
- **Geospatial Tracking**: Uses Core Location Framework to determine user location.
- **Screen-Time Management**: Blocks or limits app usage based on predefined locations.
- **Interactive Dashboard**: Provides analytics and insights into digital habits.
- **Privacy Controls**: Ensures data security and user control over tracking.
- **Notifications**: Alerts users when they enter restricted zones.
- **Customizable Settings**: Allows users to tailor restrictions and preferences.

## Tech Stack
- **Frontend**: SwiftUI
- **Backend**: Core Data, iCloud, CloudKit (Possibly Firebase or MongoDB)
- **APIs**: Apple’s Screen Time API, Core Location Framework, MapKit Framework, Swift Charts Framework
- **Development Tools**: Xcode, Xcode Simulator, TestFlight, Figma

## Development Phases
1. **Core Functionality**: Implement geospatial tracking and Screen-Time API integration.
2. **Visual Enhancements**: Improve UI/UX with SwiftUI components.
3. **Notifications & Settings**: Add alerts and customization options.
4. **Testing & Integration**: Ensure stability and prepare for deployment.

## Challenges & Learning Curve
- **APIs**: Gaining proficiency in Apple’s Screen Time API and Core Location Framework.
- **SwiftUI**: Learning and implementing SwiftUI effectively.
- **Backend Integration**: Deciding between CloudKit, Firebase, or MongoDB for data storage.

## File Structure
- **Models**: This folder contains all the data models. For instance, User.swift for user-related data or ContentModel.swift for the content data structure.
- **Views**: Contains all the SwiftUI views, including each page of your app, like HomePage.swift and ProfilePage.swift. The View is responsible for displaying the UI elements to the user and responding to user interactions (like taps, swipes, or typing).
- **ViewModels**: This folder contains all the view models which separate business logic from the views. Each page/view might have its own view model, such as ProfileViewModel.swift or ContentViewModel.swift. The ViewModel is responsible for transforming data from the Model (or any source) into a format that the View can display. It also handles user actions passed from the View and contains the logic for updating the data.


## License
This project is licensed under the MIT License.

## Contact
Developed by Trevor G. Pope. For inquiries, reach out via [LinkedIn](https://www.linkedin.com/in/trevor-pope/) or email.

---
This README provides a structured introduction to the project, outlining its purpose, features, technical stack, installation steps, and future plans. Let me know if you'd like any modifications!


