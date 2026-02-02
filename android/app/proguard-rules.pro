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
