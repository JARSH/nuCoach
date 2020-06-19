# nuCoach: A Real-Time Exercise Form Monitoring System

nuCoach is a mobile application integrated with a pressure-sensitive mat that allows users to monitor their squatting form. Using computer vision, nuCoach can visually analyze your shoulder-hip-knee and hip-knee-ankle angles and your center of balance. The pressure-sensitive mat captures your weight distribution across your feet as a heatmap so you can see if you’re leaning too far forward or backward. Your reps are analyzed in real-time and are available for review through the mobile application.

To see nuCoach in action, see the video below.

[![nuCoach: A Real-Time, Smart, Exercise Form Monitoring System](https:\/\/i.vimeocdn.com\/video\/885227294_640.webp)](https://vimeo.com/412734268 "nuCoach: A Real-Time Exercise Form Monitoring System - Click to Watch!")
<p><a href="https://vimeo.com/412734268">nuCoach: A Real-Time Exercise Form Monitoring System</a> from <a href="https://vimeo.com/utece">UT ECE</a> on <a href="https://vimeo.com">Vimeo</a>.</p>

To learn more about nuCoach's implementation, see our [presentation](https://docs.google.com/presentation/d/1ECtIt3qydr45NIeK_fzGUUQA_OOz4YHEB23BXS4QV_0/edit?usp=sharing).

## Installation
These instructions will help you get the project running on your own machine.

nuCoach is composed of three subsystems:
1. Computer vision
2. Foot pressure
3. Mobile application

The computer vision subsystem resides within the mobile application code. The foot pressure subsystem is composed of a hardware component and Arduino code.

**Computer Vision and Mobile Application**
* Install [Flutter](https://flutter.dev/docs/get-started/install) for your operating system

**Foot Pressure**
* Install the [Arduino IDE](https://www.arduino.cc/en/main/software) or use their web editor
* Obtain an [Arduino Uno Rev3](https://store.arduino.cc/usa/arduino-uno-rev3)

## Understanding the Code

### File Structure
The main folder you will be working in is the `lib` directory. That is where all of the Flutter code resides. The `android` and `ios` directories are generated by Flutter and contains native Android and iOS code. The `assets` directory contains the model used by the computer vision subsystem. The `test` folder contains a sample test for the default Flutter app. `pubspec.yaml` contains the packages and dependencies used in the project.

```
nuCoach
├── android
├── assets
├── ios
├── lib
├── test
├── README.md
└── pubspec.yaml
```
The `lib` directory contains all of the Flutter code for the computer vision subsystem, mobile application, and the visualization of the foot pressure subysystem.


```
lib
├── bluetooth
├── components
├── database
├── enums
├── models
└── screens
    ├── breakdown
    |   ├── components
    |   └── breakdown_widget.dart
    ├── camera
    |   └── camera_widget.dart
    ├── home
    |   ├── components
    |   └── home_widget.dart
    ├── summary
    |   ├── components
    |   └── summary_widget.dart
    └── main.dart
``` 

### Computer Vision


A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## About
2019-2020 Senior Design Project
Electrical and Computer Engineering Department
The University of Texas at Austin 

Faculty Mentor: Seth Bank
Technical TA: Alyas Mohammed