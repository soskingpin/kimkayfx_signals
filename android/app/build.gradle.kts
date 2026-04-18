plugins {
    id("com.android.application")
    kotlin("android")
    id("kotlin-android")
}

android {
    compileSdk = 33

    defaultConfig {
        applicationId = "com.example.firebaseapp"
        minSdk = 21
        targetSdk = 33
        versionCode = 1
        versionName = "1.0"

        // Enable split per ABI
        splits {
            abi {
                isEnable = true
                reset()
                include("armeabi-v7a", "arm64-v8a", "x86", "x86_64")
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            proguardFile("proguard-android-optimize.txt")
            proguardFile("proguard-rules.pro")
        }
    }

    // Enable new Android V2 embedding
    packagingOptions {
        resources {
            excludes += "/META-INF/*.kotlin_module"
        }
    }
}

dependencies {
    implementation("com.google.firebase:firebase-analytics-ktx:20.0.3")
    implementation("com.google.firebase:firebase-auth-ktx:21.0.1")
}