pipeline {
    agent any

    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['development', 'staging', 'production'],
            description: 'Selecciona el entorno para el despliegue'
        )
        string(
            name: 'BRANCH',
            defaultValue: 'main',
            description: 'Rama a construir'
        )
        booleanParam(
            name: 'RUN_TESTS',
            defaultValue: true,
            description: 'Ejecutar pruebas unitarias'
        )
        booleanParam(
            name: 'BUILD_APK',
            defaultValue: true,
            description: 'Compilar APK'
        )
    }

    stages {

        stage('Checkout') {
            steps {
                cleanWs()
                checkout scmGit(
                    branches: [[name: "*/${params.BRANCH}"]],
                    userRemoteConfigs: [[
                        url: 'https://github.com/KIERT-COMMUNITY/KIERT-MOVIL.git',
                        credentialsId: 'github-credentials'
                    ]]
                )
                script {
                    currentBuild.description = "Build #${BUILD_NUMBER} - ${params.BRANCH} - ${params.ENVIRONMENT}"
                }
            }
        }

        stage('Setup Flutter') {
            steps {
                bat '''
                    echo "Verificando Flutter..."
                    flutter --version
                    flutter doctor
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                bat '''
                    echo "Instalando dependencias..."
                    flutter pub get
                '''
            }
        }

        stage('Run Tests') {
            when {
                expression { params.RUN_TESTS == true }
            }
            steps {
                bat '''
                    echo "Ejecutando pruebas unitarias..."
                    flutter test
                '''
            }
        }

        stage('Build APK') {
            when {
                expression { params.BUILD_APK == true }
            }
            steps {
                bat """
                    echo "Compilando APK para entorno: ${params.ENVIRONMENT}"
                    flutter build apk --release --android-skip-build-dependency-validation
                """
            }
            post {
                success {
                    archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk', fingerprint: true
                }
            }
        }

        stage('Deploy') {
            when {
                expression { params.ENVIRONMENT == 'production' || params.ENVIRONMENT == 'staging' }
            }
            steps {
                bat """
                    echo "Desplegando a ${params.ENVIRONMENT}..."
                    echo "Build #${BUILD_NUMBER} - ${params.BRANCH}"
                """
            }
        }
    }

    post {
        success {
            bat """
                echo "Pipeline completado exitosamente!"
                echo "Build: #${BUILD_NUMBER}"
                echo "Rama: ${params.BRANCH}"
                echo "Entorno: ${params.ENVIRONMENT}"
                echo "URL: ${BUILD_URL}"
            """
        }
        failure {
            bat """
                echo "Pipeline fallo!"
                echo "Build: #${BUILD_NUMBER}"
                echo "Rama: ${params.BRANCH}"
                echo "Entorno: ${params.ENVIRONMENT}"
                echo "URL: ${BUILD_URL}"
            """
        }
        always {
            cleanWs()
            bat 'echo "Limpiando workspace..."'
        }
    }
}