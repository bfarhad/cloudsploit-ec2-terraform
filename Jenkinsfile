#!/usr/bin/env groovy
pipeline {
    agent any

    environment{
        AWS_DEFAULT_REGION = "eu-west-1" 
        credentialsId = 'jenkinsCiCd' // aws credentials in Jenkins (ID)
    }

    stages{
        stage('Terraform Init') {
            input {
                message "Enter ?"
                ok "Continue"
                parameters {
                    string(name: 'TF_VAR_vpc_id', description: 'Provide VPC')
                    string(name: 'TF_VAR_subnet_pub_C', description: 'Provide Subnet')
                    string(name: 'TF_VAR_recipient_email', description: 'Provide Email to send reports to') 
                }
            }
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: (credentialsId) ]]) { 
                        env.TF_VAR_vpc_id = TF_VAR_vpc_id
                        env.TF_VAR_subnet_pub_C = TF_VAR_subnet_pub_C
                        env.TF_VAR_recipient_email = TF_VAR_recipient_email
                        env.TF_VAR_AWS_ACCESS_KEY_ID = env.AWS_ACCESS_KEY_ID
                        env.TF_VAR_AWS_SECRET_ACCESS_KEY = env.AWS_SECRET_ACCESS_KEY
                        sh"""
                            terraform init -input=false
                        """
                    }
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: (credentialsId) ]]) { 
                        sh"""
                            terraform plan
                        """
                    }
                }
            }
        }
        stage('Terraform Apply') {
            options {
                timeout(time: 15, unit: 'MINUTES') 
            }
            input {
                message "Apply or destroy?"
                ok "Proceed"
                parameters {
                    choice(name: 'terraformChoice', choices: 'apply\ndestroy', description: 'Choose one')
                }
            }
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: (credentialsId) ]]) { 
                        sh"""
                            terraform ${terraformChoice} -input=false -auto-approve
                        """
                    }
                }
            }
        }
    }
    post {
        always {
            script {
                if (fileExists(file: "${WORKSPACE}@tmp")) {
                    ws("${WORKSPACE}@tmp") {
                          deleteDir() 
                    } 
                }
                deleteDir()
            }
        }
    }
}
