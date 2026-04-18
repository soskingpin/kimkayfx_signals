plugins {
    id("com.android.application")
    id("com.google.gms.google-services") version "4.3.10"
}

android {
    compileSdk = 33

    defaultConfig {
        applicationId = "com.example.yourapp"
        minSdk = 21
        targetSdk = 33
        versionCode = 1
        versionName = "1.0"

        // Define other configurations here
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

dependencies {
    implementation("com.google.firebase:firebase-analytics-ktx:21.0.0")
    // Add other dependencies as needed
}