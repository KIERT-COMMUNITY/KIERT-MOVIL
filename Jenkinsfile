pipeline {
    agent any

    environment {
        PATH = "C:\\Windows\\System32;C:\\Windows;C:\\Windows\\System32\\Wbem;C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\;C:\\flutter\\bin"
        FLUTTER_ROOT = "C:\\flutter"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup Flutter') {
            steps {
                powershell '''
                    Write-Host "Verificando Flutter..."
                    flutter --version
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                powershell 'flutter pub get'
            }
        }

        stage('Build APK') {
            steps {
                powershell 'flutter build apk --release --android-skip-build-dependency-validation'
            }
            post {
                success {
                    archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk'
                }
            }
        }
    }
}