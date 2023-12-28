# MWTech's NetflixUIKit Clone Project

Our NetflixUIKit Clone Project is a feature-rich movie-watching application designed to deliver an exceptional user experience.

## Table of Contents
- [Features](#features)
- [Installation](#installation)
  - [Set up Info.plist and GoogleService-Info.plist](#set-up-infoplist-and-googleservice-infoplist)
  - [CocoaPods](#cocoapods)
- [Folder Structure](#folder-structure)
- [MVVM Design Pattern](#mvvm-design-pattern)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [TODOs](#todos)
- [DONE](#done)
- [BUG](#bug)

## Features

Explore the key features of our project:

- Feature A
- Feature B
- ...

## Installation

Follow these steps to install and set up the project.

### Set up Info.plist and GoogleService-Info.plist

Before running the project, ensure proper setup of the `Info.plist` and `GoogleService-Info.plist` files.

1. **Info.plist:**
   - Duplicate the `Info.plist` file in the `netflixUIKit` folder.
   - Rename the duplicated file to `Info-dev.plist` for development.
   - Update necessary configurations like API keys and endpoints in the `Info-dev.plist` file.

   ```bash
   cp netflixUIKit/Info.plist netflixUIKit/Info-dev.plist
   ```

2. **GoogleService-Info.plist:**
   - If the project uses Firebase or Google services, create a `GoogleService-Info.plist` file and add it to the `netflixUIKit` folder.
   - Update configurations in the `GoogleService-Info.plist` file.

   ```bash
   cp path/to/your/GoogleService-Info.plist netflixUIKit/GoogleService-Info.plist
   ```

3. **Note:**
   - Ensure that both `Info-dev.plist` and `GoogleService-Info.plist` are added to your `.gitignore` file to prevent them from being accidentally committed to version control.

### CocoaPods

Our project relies on various third-party libraries for enhanced functionality. Ensure you have CocoaPods installed, then run the following command:

```bash
pod install
```

This will install the required dependencies specified in the `Podfile`.

## Folder Structure

Our project's folder structure is designed for modularity and separation of concerns, enhancing maintainability and organization.

- **AppDelegate**: Manages the application's lifecycle events.
  
- **SceneDelegate**: Handles the setup of the app's user interface upon launching.

### Resource

- **CustomFonts**: Contains custom font files used in the application.

- **LottieFiles**: Houses Lottie animation files utilized in the app.

- **Localizable**: Holds localization files for supporting multiple languages.

- **Assets**: Stores general assets used in the application.

### Common

- **Constants**: Includes files for storing constants used throughout the app.

- **Helper**: Contains utility classes and functions that provide common functionalities.

- **Components**: Houses reusable UI components used across multiple modules.

- **Extensions**: Contains Swift extensions for extending functionality of built-in classes.

### Model

- **TMDB...etc Model**: Houses data models related to specific modules, such as TMDB models.

- **CoreData**: Contains files related to Core Data implementation.

### Network

- **APIManager**: Manages API requests and responses, providing a centralized location for networking logic.

### Module

- **SplashScreen**: Contains files specific to the splash screen module.

- **Login+Register**: Holds files for the login and registration module.

- **MainTabBar**: Includes files related to the main tab bar module.

- **AdditionalVC**: Contains additional view controllers used in various parts of the app.

### Info.plist

- Stores configuration settings and metadata for the app.

---

Our project's folder structure is designed to be modular and follows a clear separation of concerns. Each folder has a specific purpose, contributing to the overall maintainability and organization of the codebase. As the project evolves, consider updating the structure to accommodate new features and maintain a clean and scalable architecture.

## MVVM Design Pattern

Our project follows the MVVM (Model-View-ViewModel) design pattern, a software architectural pattern that enhances separation of concerns, making the codebase more modular and maintainable.

### Model

The Model represents the data and business logic of the application. It includes data structures, data access, and business rules.

### View

The View represents the user interface and is responsible for displaying data to the user and capturing user inputs. In our project, Views are implemented using UIViewController and UIView subclasses.

### ViewModel

The ViewModel acts as an intermediary between the Model and the View. It transforms the data from the Model into a format that is easily consumable by the View and manages user interactions, often exposing data through bindings.

![MVVM Diagram](https://user-images.githubusercontent.com/1812129/68319232-446cf900-00be-11ea-92cf-cad817b2af2c.png)

## Usage

Instructions on how to use our project.

## Contributing

Guidelines for contributing to our project.

## License

Information about the project's license.

## TODOs

Keep track of tasks, improvements, and future plans for our project.

- [ ] Implement Onboarding View.
- [ ] Add a suggest when searching a movie 
- [ ] New page when actor pressed
- [ ] Download YouTube video(?) *not legal
- [ ] Edit theme in AppSettingsVC using Color well
- [ ] Implement circle progressBar (in %) for voteAverage
- [ ] Add Age Rating Icon
- [ ] Add an option to upgrade to the pro version
- [ ] Add buy me a coffee
- [ ] Add our app's widget
- [ ] Implement deep links
- [ ] Add ErrorView
- [ ] Add expanded table view
- [ ] Fix if more profile photos want to be added
- [ ] Negative case
   -> [x] TrailerVC when there is no Data
- [ ] cellForRowAt inside DiscoverViewController add void closure var insinde its cell for passing
 
## DONE

Tasks that have been completed.

- [x] Implemented Login Authentication with the appropriate logic.
- [x] Added dynamic page loading when scrolling to the bottom/vertical.
- [x] Integrated Netfox for API debugging.
- [x] Implemented the POST method from TMDB API.
- [x] Integrated YouTube API to play trailer videos.
- [x] Implemented Face ID feature for secure login.
- [x] Added a reset password feature.
- [x] Added a number (ranking 1-10) beside the imageView of the best-rated movie.
- [x] Added sliding tabs in detailView using Parchment.
- [x] Added creditsVC inside sliding tabs.
- [x] Added download functionality with long press.
- [x] Added CV, images to Text in searchTextField.
- [x] Added a share button.
- [x] Added a feature that displays the entire list of items.
- [x] Removed duplicate unnecessary Model.
- [x] Added recommendationVC inside sliding tabs.
- [x] Added reviewsVC inside.
- [x] Implemented a feature to push to another detailView when clicking the moviePoster inside detailView itself.
- [x] Integrated CoreData or UserDefaults for data storage.
- [x] Added Recently viewed feature.
- [x] Added a floating icon backToTop in ComingSoonVC.
- [x] Added an iconNotificationBadge for HistoryVC.
- [x] Implemented AdMob.
- [x] Added Custom Font.
- [x] Added login as an anonymous feature.
- [x] Added changelog in MoreVC.
- [x] Add chatAI using Google Gemini 
   -> [x] Set userChar's chat bubble on the right side
   -> [x] Fix time label "12.12 am...." Constraint
   -> [x] User default for 
   -> [x] Add images to Gemini
   -> [x] Add is typing for Gemini
   -> [x] Add Gemini to speak
- [x] Get Internet speed and save it in UserDefault place it in label.text
- [x] Add localized for language
- [x] Added custom voice using pod InstantSearchVoiceOverlay
- [x] Paste control for GeminiChat
- [x] Change label to I'm feeling lucky button and its feature in homeVC
- [x] Change button play to play random and its feature video
- [x] MoreViewController Scrollable
- [x] Complete languageVC task w/ 'LanguageManager-iOS', limited to UILabel, can't change programatically.

## BUG

- [ ] Combine 2 endpoints/struct models for comparison.
- [ ] In ComingSoonVC, when clicked, it will pop up an alert "Should it be added to favorites? Yes or no," then it will be checked in UserDefaults whether there is data or not.
- [ ] Crash when FaceID doesn't match
