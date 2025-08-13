plugins {
    id("com.android.application")
    id("com.google.gms.google-services")version "4.4.3" apply false
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.spotify_clone"
    compileSdk = 34
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.spotify_clone"
        minSdk = 23
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
     // Firebase BoM (Kotlin DSL)
     implementation(platform("com.google.firebase:firebase-bom:33.1.2"))

     // Các SDK Firebase
     implementation("com.google.firebase:firebase-analytics-ktx")
     implementation("com.google.firebase:firebase-auth-ktx")
     implementation("com.google.firebase:firebase-firestore-ktx")
}
    // Thêm các Firebase SDK khác nếu bạn cần

apply(plugin = "com.google.gms.google-services") // ✅ bắt buộc
