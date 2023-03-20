pipeline{
    agent any 
    tools{
        gradle 'Gradle'
        }
    stages {
        stage('Gradle build'){
            steps{
               	sh 'gradle clean build artifactoryPublish --no-daemon'
      	    }
        }

        stage('Unit Testing'){     
            steps{
                junit(testResults: 'build/test-results/test/*.xml', allowEmptyResults : true, skipPublishingChecks: true)
           	}
            post {
                success {
                    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'build/reports/tests/test/', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
         		}
       		}
        }
        
        stage('Building Docker Image'){
            steps{
                sh 'cd /home/testing/tx-web'
                sh 'docker build -t devsecops . '
                sh 'docker tag devsecops:latest pritidevops/devsecops:latest '
            }
        } 
    }
}



        
