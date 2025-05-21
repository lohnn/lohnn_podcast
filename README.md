# OssPlayer

An open-source podcast player. It's the open-source version of the app available at https://podcast.lohnn.se/ and will soon be available on the App Store and Play Store.

## Features

*   Play podcasts
*   Search for podcasts from a public index
*   User login
*   Cross-platform support (Android, iOS, macOS, web)

## Getting Started

### Prerequisites

*   Flutter and Dart SDK. Specific versions might be needed. Please refer to `apps/podcast/pubspec.yaml` or `pubspec.yaml` (look for `melos: command: bootstrap: environment: flutter`) for the correct Flutter version.

### Clone Repository

```bash
git clone https://github.com/your-username/oss-player.git # Replace with the actual repository URL
cd oss-player
```

### Setup Project

Run the following command from the root of the repository to set up the project:

```bash
dart bin/setup_project.dart
```

This script will guide you through setting up your API credentials interactively:
1.  When you run the script, it will first print instructions on how to obtain your API Key and Secret from Podcast Index, including a link to their developer signup page (https://podcastindex.org/developers/signup).
2.  The script will then prompt you to enter your Podcast Index API Key directly into the terminal.
3.  Next, it will prompt you to enter your Podcast Index API Secret directly into the terminal.
4.  Once you provide the keys, the script will automatically create the `apps/podcast/lib/secrets.dart` file and populate it with the credentials you entered.

You no longer need to manually edit this file with your keys; the script handles it for you.

### Running the App

To run the application, navigate to the `apps/podcast` directory and use the `flutter run` command:

```bash
cd apps/podcast
flutter run
```
Select your desired device or platform when prompted by Flutter.

## Project Structure

This project is a monorepo managed with [Melos](https://melos.invertase.dev/).

*   `apps/podcast`: Contains the main Flutter application.
*   `packages/podcast_common`: Houses common utilities, widgets, and themes shared across the project.
*   `packages/podcast_core`: Includes core functionalities, business logic, and services like API interaction and state management.

## Contributing

Contributions are welcome! We appreciate your help in making OssPlayer better.

*   **Conventional Commits**: Please follow the [Conventional Commits](https://www.conventionalcommits.org/) specification for your commit messages. Our `CHANGELOG.md` is generated based on these commits.
*   **Code Generation**: If you make changes to files that require code generation (e.g., files using `freezed`, `json_serializable`, etc.), please run the following command from the root of the repository:
    ```bash
    melos run generate
    ```
*   **Pull Requests**:
    *   Ensure all tests pass before submitting a pull request.
    *   Follow the existing coding style.
    *   Provide a clear description of the changes in your pull request.

## License

This project is licensed under the Apache License, Version 2.0 - see the `LICENSE` file for details.

## Contact/Links

*   **Web Version:** [https://podcast.lohnn.se/](https://podcast.lohnn.se/)
*   **Issue Tracker:** [https://github.com/your-username/oss-player/issues](https://github.com/your-username/oss-player/issues) # Please replace with the actual link to the GitHub issues page