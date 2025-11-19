# Meme Generator Flutter App

A Flutter app that allows you to create memes by uploading images and adding custom text overlays.

## Features

- 📷 Upload images from gallery or camera
- ✍️ Add top and bottom text to images
- 🎨 Customize text size and color
- 🖼️ Toggle text borders for better visibility
- 💾 Save memes to your device

## Setup Instructions

### 1. Install Flutter
Make sure you have Flutter installed. If not, follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).

### 2. Create a New Flutter Project
```bash
flutter create meme_generator
cd meme_generator
```


### 4. Platform-Specific Configuration

#### Android Configuration

Add the following permissions to `android/app/src/main/AndroidManifest.xml` inside the `<manifest>` tag:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="32" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
```

Update `android/app/build.gradle`:
```gradle
android {
    compileSdkVersion 34  // Update to at least 33
    
    defaultConfig {
        minSdkVersion 21  // Update to at least 21
        targetSdkVersion 34
    }
}
```

#### iOS Configuration

Add the following to `ios/Runner/Info.plist`:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to your photo library to select images for memes.</string>
<key>NSCameraUsageDescription</key>
<string>This app needs access to your camera to take photos for memes.</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>This app needs permission to save memes to your photo library.</string>
```

### 5. Install Dependencies
```bash
flutter pub get
```

### 6. Run the App
```bash
# For Android
flutter run

# For iOS (Mac only)
flutter run -d ios

# For web
flutter run -d chrome
```

## How to Use

1. **Select an Image**: Tap the "Select Image" button to choose an image from your gallery or take a new photo with your camera.

2. **Add Text**:
    - Enter text in the "Top Text" field for text at the top of the image
    - Enter text in the "Bottom Text" field for text at the bottom of the image

3. **Customize Text** (tap the settings icon):
    - Adjust text size with sliders
    - Change text color
    - Toggle text borders on/off

4. **Save Meme**: Once satisfied with your meme, tap the save icon to save it to your device.

## Dependencies

- `image_picker`: ^1.0.4 - For selecting images from gallery or camera
- `path_provider`: ^2.1.1 - For accessing device directories to save images
- `permission_handler`: ^11.0.1 - For requesting storage and camera permissions

## Troubleshooting

### Image Picker Not Working
- Make sure you've added the required permissions to your AndroidManifest.xml (Android) or Info.plist (iOS)
- Run `flutter clean` and `flutter pub get`

### Save Function Not Working
- Ensure storage permissions are granted
- Check that the app has write access to external storage

### Build Errors
- Make sure your compileSdkVersion is at least 33 for Android
- Run `flutter doctor` to check for any issues with your Flutter installation

## License

This project is open source and available for personal and educational use.
