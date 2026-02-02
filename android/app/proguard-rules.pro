# Add project specific ProGuard rules here.
# Flutter already handles most obfuscation.

# Keep model classes if using JSON serialization with reflection
-keep class com.deflection.deflection_calculator.** { *; }

# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Google Play Core (deferred components) - ignore missing classes
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# Keep Play Core classes if present
-keep class com.google.android.play.core.** { *; }
