# Google ML Kit
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

# Keep Chinese text recognition
-keep class com.google.mlkit.vision.text.chinese.** { *; }

# Keep Devanagari text recognition  
-keep class com.google.mlkit.vision.text.devanagari.** { *; }

# Keep Japanese text recognition
-keep class com.google.mlkit.vision.text.japanese.** { *; }

# Keep Korean text recognition
-keep class com.google.mlkit.vision.text.korean.** { *; }

# Flutter and Dart
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Flutter TTS
-keep class com.tundralabs.fluttertts.** { *; }

# STTS
-keep class com.llfbandit.stts.** { *; }
