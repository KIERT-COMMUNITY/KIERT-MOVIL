pipeline {
    agent any

    environment {
        FLUTTER_ROOT = 'C:\\flutter'
        PATH = "${env.FLUTTER_ROOT}\\bin;${env.PATH}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Setup Flutter') {
            steps {
                bat '''
                    echo "Verificando Flutter..."
                    flutter --version
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                bat 'flutter pub get'
            }
        }

        stage('Build APK') {
            steps {
                bat 'flutter build apk --release --android-skip-build-dependency-validation'
            }
            post {
                success {
                    archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk'
                }
            }
        }
    }
}