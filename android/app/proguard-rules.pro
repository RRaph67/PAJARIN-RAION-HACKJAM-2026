# =============================================================================
# ProGuard rules for Pajarin release build
# =============================================================================

# ── Supabase ────────────────────────────────────────────────────────────────
-keep class io.github.jan-tennert.supabase.** { *; }
-keep class com.github.jan.supabase.** { *; }

# ── GoTrue (Supabase Auth) ──────────────────────────────────────────────────
-keep class io.github.jan.supabase.gotrue.** { *; }

# ── Dio (HTTP Client) ──────────────────────────────────────────────────────
-keep class io.github.jan.supabase.postgrest.** { *; }
-keep class io.github.jan.supabase.realtime.** { *; }

# ── Kotlin Serialization ────────────────────────────────────────────────────
-keepattributes *Annotation*, InnerClasses
-dontnote kotlinx.serialization.AnnotationsKt

-keepclassmembers @kotlinx.serialization.Serializable class ** {
    *** Companion;
}
-keepclasseswithmembers class **$$serializer {
    *** INSTANCE;
}

# ── Keep Riverpod providers ─────────────────────────────────────────────────
-keep class * extends androidx.lifecycle.ViewModel
-keep class * extends androidx.lifecycle.AndroidViewModel

# ── Keep model classes (needed for JSON serialization) ──────────────────────
-keep class com.raion.raion_hackjam15.** { *; }

# ── Flutter specific ────────────────────────────────────────────────────────
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
