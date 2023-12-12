# My NetlixUIKit Clone Project

A movie watch project that does incredible things.

## Table of Contents
- [Features](#features)
- [Installation](#installation)
  - [Set up Info.plist and GoogleService-Info.plist](#set-up-infoplist-and-googleservice-infoplist)
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
- [ ] Add audio to text searchBar
- [ ] Add localized for language
- get interneet speed and save it in coredata
- ...

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

## BUG

- [ ] Combine 2 endpoint/struct model buat perbandingan.
- [ ] di ComingSoonVC ketika di klik akan pop up alert "apakah akan di tambhkan ke favortie? yes or no", trus akan di cek ke userdefault apakah ada datanya atau tdk.
