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
        stage('Deliver') {
            steps {
                sh 'apt-get update && apt-get install -y binutils'
                sh 'pip install pyinstaller'
                sh 'pyinstaller --onefile sources/add2vals.py'
            }
            post {
                success {
                    archiveArtifacts 'dist/add2vals'
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
                sh 'pip install flask'
                sh '''
                    python3 sources/app.py &
                    APP_PID=$!
                    sleep 3
                    curl -sf http://localhost:5000/ -o /dev/null
                    sleep 57
                    kill $APP_PID
                '''
            }
        }
    }
}