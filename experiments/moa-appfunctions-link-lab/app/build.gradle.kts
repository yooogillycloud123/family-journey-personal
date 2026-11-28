plugins {
    id("com.android.application")
    id("com.google.devtools.ksp")
}
android {
    namespace = "com.juhyeon.moa.linklab"
    compileSdk = 37
    defaultConfig {
        applicationId = "com.juhyeon.moa.linklab"
        minSdk = 36
        targetSdk = 37
        versionCode = 1
        versionName = "1.0-lab"
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}
dependencies {
    implementation("androidx.appfunctions:appfunctions:1.0.0-rc01")
    ksp("androidx.appfunctions:appfunctions-compiler:1.0.0-rc01")
    testImplementation("junit:junit:4.13.2")
}
ksp { arg("appfunctions:aggregateAppFunctions", "true") }
