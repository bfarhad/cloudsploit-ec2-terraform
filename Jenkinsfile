#!/usr/bin/env groovy
pipeline {
    agent any

    environment{
        AWS_DEFAULT_REGION = "eu-west-1" 
        credentialsId = 'jenkinsCiCd'
        TF_VAR_vpc_id = 'vpc-09cf4efbd803372b6'
        TF_VAR_subnet_pub_C = 'subnet-09fd71f109d04d274'
        TF_VAR_key_name = 'ec2-key'
    }

    stages{
        stage('Terraform Init') {
            steps {
                script {
                    sh"""
                        terraform init -input=false
                    """
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
                message "What will be installed on ec2?"
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