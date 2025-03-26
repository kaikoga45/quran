# Quran App  

## General Summary  

The Quran App is a cross-platform mobile application developed using Flutter, designed to deliver a seamless and engaging Quran reading experience on both iOS and Android devices. The app offers the following features:  

- **Surah List & Search:** Users can browse through a complete list of Surahs and utilize a quick search feature to locate specific Surahs instantly.  
- **Detailed Surah View:** Upon selection, each Surah is presented with a detailed view containing a list of verses, complete with the original Arabic text and corresponding translations.  
- **Audio Playback:** An integrated audio player allows users to listen to recitations. The audio player includes essential playback controls such as play, pause, resume, looping, and progress tracking via a dynamic progress bar. A slider enables precise seeking through the audio, and dedicated forward/backward buttons facilitate quick navigation between Surahs.  

### Visual Demonstration  
Below are screenshots showcasing the app’s interface:  

<p align="center">
  <img src="https://i.imghippo.com/files/yVyc7407lkY.png" width="24%" />
  <img src="https://i.imghippo.com/files/IyuD1405kg.png" width="24%" />
  <img src="https://i.imghippo.com/files/UJrD1162s.png" width="24%" />
  <img src="https://i.imghippo.com/files/QYRl7992qYg.png" width="24%" />
  <img src="https://i.imghippo.com/files/MnwN2195SnI.png" width="24%" />
</p>

For a live demonstration, watch the YouTube video: [Quran App Demo](https://www.youtube.com/shorts/8pUmHDOYc7s)  

## Technical Summary  

The Quran App is built with a focus on maintainability, performance, and a modular design using modern Flutter best practices:  

### 1. Installation & Setup  
- **Prerequisites:** Requires a minimum Flutter SDK version of 3.22.2.  
- **Getting Started:**  
  - Clone the repository:  
    ```bash
    git clone https://github.com/kaikoga45/quran.git
    ```
  - Open the project in Visual Studio Code.  
  - Ensure an emulator (or physical device) is running.  
  - Launch the application directly from VS Code.  

### 2. Architecture & Dependency Injection  
- **Clean Architecture:** Follows a structured architecture divided into Presentation, Domain, and Data layers.  
- **Dependency Injection:** Utilizes the `Get_it` package to manage dependencies effectively, ensuring a decoupled and testable codebase.  

### 3. Audio Player Implementation  
- **Custom Native Code:** Instead of relying on third-party packages, the audio player is implemented using custom native code.  
  - **iOS:** Uses Swift with AVPlayer.  
  - **Android:** Uses Kotlin with MediaPlayer.  
- **Method Channel Integration:** Communicates between Flutter and native code using method channels, providing seamless integration and efficient performance.  

### 4. State Management  
- Implements the BLOC (Business Logic Component) pattern to manage state, promoting a clear separation between business logic and UI.  

### 5. Testing  
- Implements selected **unit and widget tests** using the AAA pattern for structured testing practices, showcasing an understanding of test implementation in Flutter. 
- The naming convention for tests follows the Microsoft approach, consisting of three parts: the name of the method being tested, the scenario under which the method is being tested, and the expected behavior when the scenario is invoked.

### 6. Code Quality & Design Principles  
- Adheres to the Separation of Concerns (SoC) and DRY (Don't Repeat Yourself) principles, ensuring the code is maintainable, scalable, and easy to understand.  

### 7. Customization  
- **Custom App Icon:** A uniquely designed custom app icon is implemented for both iOS and Android platforms, contributing to the overall branding of the application.  
