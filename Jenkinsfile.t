pipeline{
    agent any 
    tools{
        gradle 'Gradle'
        }
    stages {
        
        stage('Building Docker Image'){
            steps{
                sh 'cd /home/testing/tx-web'
                sh 'docker build -t devsecops . '
                sh 'docker tag devsecops:latest pritidevops/devsecops:latest '
            }
        } 
    }
}



        
