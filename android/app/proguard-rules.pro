# Flutter engine and embedding
-keep class io.flutter.** { *; }

# Flutter plugins (Pigeon-generated code uses reflection)
-keep class io.flutter.plugins.** { *; }

# Disable obfuscation entirely. R8 still shrinks (removes unused code) and
# optimizes, but class/member/type names are preserved. This is required
# because Pigeon-based plugins (e.g. shared_preferences_android 2.4+)
# look up methods by exact JNI signature at runtime; renaming parameter
# types like kotlin.coroutines.Continuation breaks the lookup with
# NoSuchMethodError.
-dontobfuscate

# Play Core deferred components (not used, referenced by Flutter engine)
-dontwarn com.google.android.play.core.**