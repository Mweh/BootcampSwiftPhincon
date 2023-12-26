# My NetlixUIKit Clone Project

A movie watch project that does incredible things.

## Table of Contents
- [Features](#features)
- [Installation](#installation)
  - [Set up Info.plist and GoogleService-Info.plist](#set-up-infoplist-and-googleservice-infoplist)
- [Folder Structure](#folder structure)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [TODOs](#todos)
- [DONE](#done)

## Features

List of key features in your project.

- Feature A
- Feature B
- ...

## Installation

Steps to install and set up your project.

### Set up Info.plist and GoogleService-Info.plist

Before running the project, make sure to set up the `Info.plist` and `GoogleService-Info.plist` files.

1. **Info.plist:**
   - Duplicate the `Info.plist` file in the `netflixUIKit` folder.
   - Rename the duplicated file to `Info-dev.plist` for development.
   - Update the necessary configurations such as API keys, endpoints, etc. in the `Info-dev.plist` file.

   ```bash
   cp netflixUIKit/Info.plist netflixUIKit/Info-dev.plist
   ```

2. **GoogleService-Info.plist:**
   - If your project uses Firebase or Google services, make sure to create a `GoogleService-Info.plist` file and add it to the `netflixUIKit` folder.
   - Update the configurations in the `GoogleService-Info.plist` file.

   ```bash
   cp path/to/your/GoogleService-Info.plist netflixUIKit/GoogleService-Info.plist
   ```

3. **Note:**
   - Ensure that both `Info-dev.plist` and `GoogleService-Info.plist` are added to your `.gitignore` file to prevent them from being accidentally committed to version control.

### Continue with the rest of the installation steps...

## Folder Structure

- **AppDelegate**: Manages the application's lifecycle events.
  
- **SceneDelegate**: Handles the setup of the app's user interface upon launching.

## Resource

- **CustomFonts**: Contains custom font files used in the application.

- **LottieFiles**: Houses Lottie animation files utilized in the app.

- **Localizable**: Holds localization files for supporting multiple languages.

- **Assets**: Stores general assets used in the application.

## Common

- **Constants**: Includes files for storing constants used throughout the app.

- **Helper**: Contains utility classes and functions that provide common functionalities.

- **Components**: Houses reusable UI components that are used across multiple modules.

- **Extensions**: Contains Swift extensions for extending functionality of built-in classes.

## Model

- **TMDB...etc Model**: Houses data models related to specific modules, such as TMDB models.

- **CoreData**: Contains files related to Core Data implementation.

## Network

- **APIManager**: Manages API requests and responses, providing a centralized location for networking logic.

## Module

- **SplashScreen**: Contains files specific to the splash screen module.

- **Login+Register**: Holds files for the login and registration module.

- **MainTabBar**: Includes files related to the main tab bar module.

- **AdditionalVC**: Contains additional view controllers used in various parts of the app.

## Info.plist

- Stores configuration settings and metadata for the app.

---

Your project's folder structure is designed to be modular and follows a clear separation of concerns. Each folder has a specific purpose, contributing to the overall maintainability and organization of the codebase. As the project evolves, consider updating the structure to accommodate new features and maintain a clean and scalable architecture.


## Usage

Instructions on how to use your project.

## Contributing

Guidelines for contributing to your project.

## License

Information about the project's license.

## TODOs

Keep track of tasks, improvements, and future plans for your project.

- [ ] Implement Onboarding View.
- [ ] Add a suggest when searching a movie 
- [ ] New page when actor pressed
- [ ] Download youtube video(?) *notlegal
- [ ] Edit theme in AppSettingsVC using Color well
- [ ] Implement circle progressBar (in %) for voteAverage
- [ ] Add Age Rating Icon
- [ ] Add an optional to upgrade pro Version
- [ ] Add buy me a coffee
- [ ] Add my app's widget
- [ ] Implement deep links
- [ ] Add ErrorView
- [ ] Add expanded tableview
- [ ] Fix if more profile photo want to be added
 
## DONE

Tasks that have been completed.

- [x] Implemented Login Authentication with the appropriate logic.
- [x] Added dynamic page loading when scrolling to the bottom/vertical.
- [x] Integrated Netfox for API debugging.
- [x] Implemented the POST method from TMDB API.
- [x] Integrated YouTube API to play trailer videos.
- [x] Implemented Face ID feature for secure login.
- [x] Added a reset password feature.
- [x] Added a number (ranking 1-10) beside the imageView of the best-rated movie.
- [x] Added sliding tabs in detailView using Parchment.
- [x] Added creditsVC inside sliding tabs.
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
- [x] Added login as anonymous feature.
- [x] Added changelog in MoreVC.
- [x] Add chatAI using Google Gemini 
 -> [x] Set userChar's chat bubble in right side
 -> [x] Fix time label "12.12 am...." Constraint
 -> [x] Userdefault for 
 -> [x] Add images to gemini
 -> [x] Add is typing for gemini
 -> [x] Add gemini to speak
- [x] Get Internet speed and save it in UserDefault place it in label.text
- [x] Add localized for language
- [x] Added custom voice using pod InstantSearchVoiceOverlay
- [x] Pastecontrol for GeminiChat
- [x] Change label to I'm feeling lucky button and its feature in homeVC
- [x] Change button play to play random and its feature video
- [x] MoreViewController Scrollable

## BUG

- [ ] Combine 2 endpoint/struct model buat perbandingan.
- [ ] di ComingSoonVC ketika di klik akan pop up alert "apakah akan di tambhkan ke favortie? yes or no", trus akan di cek ke userdefault apakah ada datanya atau tdk.
- [ ] Crash when FaceID didnt match
