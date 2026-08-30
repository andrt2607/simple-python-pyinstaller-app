pipeline {
    agent {
        docker {
            image 'python:3.9-slim-bullseye'
            args '-u root'
        }
    }
    triggers {
        pollSCM('H/2 * * * *')
    }
    stages {
        stage('Build') {
            steps {
                sh 'python3 -m py_compile sources/add2vals.py sources/calc.py'
            }
        }
        stage('Test') {
            steps {
                sh 'pip install pytest'
                sh 'py.test --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
            }
            post {
                always {
                    junit 'test-reports/results.xml'
                }
            }
        }
        stage('Push Image GHCR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'ghcr-credentials', usernameVariable: 'GITHUB_ACTOR', passwordVariable: 'GITHUB_TOKEN')]) {
                    sh 'chmod +x scripts/deploy_ghcr.sh'
                    sh './scripts/deploy_ghcr.sh'
                }
            }
        }
        stage('Manual Approval') {
            steps {
                input message: 'Lanjutkan ke tahap Deploy?'
            }
        }
        stage('Deploy') {
            steps {
                withCredentials([string(credentialsId: 'render-deploy-hook-python', variable: 'RENDER_DEPLOY_HOOK')]) {
                    sh 'chmod +x scripts/deploy_render.sh'
                    sh './scripts/deploy_render.sh'
                }
                sh 'pip install flask'
                sh '''
                    python3 sources/app.py &
                    APP_PID=$!
                    sleep 60
                    kill $APP_PID
                '''
            }
        }
    }
}