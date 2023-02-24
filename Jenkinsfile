pipeline{
    agent any 
    tools{
        gradle 'Gradle'
        }
    stages {

	    stage('Software Composition Anaylsis->Dependency-checker'){
			steps{
 				script{	
 					dependencyCheck additionalArguments: '--format XML', odcInstallation: 'SCA'
 					dependencyCheckPublisher pattern: ''
                }
			}
	} 
    
    /* stage('mystage')
       {
            steps {
                script {
                withVault([VaultUrl: '<http://192.168.6.190:8200/>', Vault_Token: 'sERwC7wXyKwPsNddNnT2IzjfX']) {
                    //Your pipeline code that uses Vault secrets goes here
                    sh 'Vault read secret/my-secret'
                    }
                }
            }
        } */    
        
        stage('SonarQube analysis') {
           environment {
             SCANNER_HOME = tool 'SonarQubeScanner'
                       }
           steps {
               withSonarQubeEnv(credentialsId: 'SonarQube-Token', installationName: 'SonarQubeScanner') {
               sh './gradlew sonarqube \
              -Dsonar.projectKey=DevSecOps \
              -Dsonar.host.url=http://192.168.6.190:9000 \
              -Dsonar.login=7b9d5bf5a39a9af85d2d9599a99651a67efd5afb'
            }
          }
        }

        stage('Gradle build'){
            steps{
                sh 'gradle clean build --no-daemon'
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
        
        stage ('Docker File Scan'){
			steps{
				//sh 'pip3 install checkov' 
               // sh 'docker pull bridgecrew/checkov'
				  sh 'sudo checkov -f Dockerfile --skip-check CKV_DOCKER_3 '   //skip USER in Dockerfile with CKV_DOCKER_3
			}
		}
        
        stage('Building Docker Image'){
            steps{
                sh 'cd /home/testing/tx-web'
                sh 'docker build -t devsecops . '
                sh 'docker tag devsecops:latest pritidevops/devsecops:latest '
            }
        } 
        
        stage('Image Scanning')
	    {
		    steps{
			      sh 'trivy image pritidevops/devsecops:latest '
		    }
	    }
        
        stage('Publish docker images to Docker Registry'){
            steps{
                withDockerRegistry([ credentialsId: "Dockerhub", url: "" ]) 
                {
                    sh  'docker push pritidevops/devsecops'
                }
            }
        }

        stage('Deployment of k8 cluster'){
            steps{
                script{
                    kubernetesDeploy(
                        configs: 'deployment-service.yml',
                        kubeconfigId: 'k8-config',
                        enableConfigSubstitution: true 
                    )
                }
            }
        }
    }
}



        
