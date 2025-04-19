# Prevent ML Kit text recognition options from being removed
-keep class com.google.mlkit.vision.text.** { *; }

# Needed for ML Kit reflection-based access
-keep class com.google.mlkit.common.model.** { *; }

# Prevent removal of classes for specific language recognizers
-keep class com.google.mlkit.vision.text.chinese.** { *; }
-keep class com.google.mlkit.vision.text.japanese.** { *; }
-keep class com.google.mlkit.vision.text.korean.** { *; }
-keep class com.google.mlkit.vision.text.devanagari.** { *; }