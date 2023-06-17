pipeline {
    agent any 


    environment {
        AWS_ACCESS_KEY_ID = credentials ('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials ('AWS_SECRET_ACCESS_KEY')
    }
    
    stages {
        stage ("download code and env config") {
            steps {
                sh 'git clone https://github.com/techbleat/codebase.git'
                sh 'git clone https://github.com/techbleat/env.git'
            }
        }
        stage ('plan') {
             steps {
                sh '''
                   cd codebase
                   terraform init -backend-config=../env/dev/backend.tfvars
                   terraform plan -var-file ../env/dev/backend.tfvars  -var-file ../env/dev/ec2.tfvars 
                '''
                script  {
                    env.NEXT_STEP = input message: 'Implement plan?', ok: 'Implement',
                    parameters: [choice (name: 'Implement', choices: 'apply\ndestroy\ndo nothing', description: 'implementation stage')]
                }
            }   

        }
        stage ('implement apply') {
            when {
                expression {
                    env.NEXT_STEP == 'apply'
                }
            }
            steps {
                sh '''
                   cd codebase
                   terraform init -backend-config=../env/dev/backend.tfvars
                   terraform apply -var-file ../env/dev/backend.tfvars  -var-file ../env/dev/ec2.tfvars -auto-approve
                '''
            }
        }
        stage ('implement destroy') {
            when {
                expression {
                    env.NEXT_STEP == 'destroy'
                }
            }
            steps {
                sh '''
                   cd codebase
                   terraform init -backend-config=../env/dev/backend.tfvars
                   terraform destroy -var-file ../env/dev/backend.tfvars  -var-file ../env/dev/ec2.tfvars -auto-approve
                '''
            }
        }
    }
    
    post {
        always {
            deleteDir()
        }
    }
}