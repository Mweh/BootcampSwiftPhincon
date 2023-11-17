# My Awesome Project

An amazing project that does incredible things.

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
- [ ] Integrate CoreData or UserDefault for data storage.
- [ ] Add filter with viewModel using RxSwift, so my app can filter what genre should the user want by tapping the genre option and will filter the movie based on the selected genre.
- [ ] Make my project full MVVM by adding viewModel in every module folder.
- [ ] Add more pages/VC for movie credits, including actors and other relevant information.
- [ ] Combine 2 endpoint/struct model buat perbandingan.
- [ ] di ComingSoonVC ketika di klik akan pop up alert "apakah akan di tambhkan ke favortie? yes or no", trus akan di cek ke userdefault apakah ada datanya atau tdk.

- ...

## DONE

Tasks that have been completed.

- [x] Implement Login Authentication with the right logic.
- [x] Add more pages dynamically when scrolling to the bottom/vertical.
- [x] Integrate Netfox for API debugging.
- [x] Implement POST method from TMDB API.
- [x] Integrate YouTube API to play trailer videos.
- [x] Implement Face ID feature for secure login.
- [x] Add reset password feature

