allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()

rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
// Third-party plugins disagree on JVM target, which trips Gradle's
// "Inconsistent JVM-target compatibility" check (Java vs Kotlin must match):
//   - receive_sharing_intent sets neither compileOptions nor kotlinOptions, so
//     Java defaults low (~11) while Kotlin defaults to the Gradle JDK (~21).
//   - home_widget hardcodes both Java and Kotlin to 1.8 in its own android block.
// Pin both compilers to 17 in every module so each has a single, consistent
// target. Kotlin goes through a lazy task override. Java must go through AGP's
// compileOptions (AGP ignores it on the raw JavaCompile task), set in
// afterEvaluate so it runs after a plugin's own compileOptions block, which would
// otherwise overwrite our value (this is how home_widget reverts Java to 1.8).
//
// Registered before the evaluationDependsOn(":app") block below: that block
// forces :app — and through Flutter's plugin loader, every plugin subproject — to
// evaluate, so the afterEvaluate hooks must be registered first or they throw
// "Cannot run afterEvaluate when the project is already evaluated".
subprojects {
    afterEvaluate {
        extensions.findByType<com.android.build.api.dsl.LibraryExtension>()?.apply {
            compileOptions {
                sourceCompatibility = JavaVersion.VERSION_17
                targetCompatibility = JavaVersion.VERSION_17
            }
        }
    }
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
