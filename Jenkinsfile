#!/usr/bin/env groovy

properties([buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '14', numToKeepStr: '5')), pipelineTriggers([])])

pipeline {
  agent any

  environment {
    baseImageTag = "v1.0.0"
    baseImageName = "centos/ruby-22-centos7"
    s2iImageNAme = "huk24/rails-ex"
    project_name = "huk24"
    app_name = "rails-ex"
  }

  stages {
    stage('create new App') {
      when {
        expression {
          openshift.withCluster("MiniShift"){
            openshift.withProject(){
              return !openshift.selector('bc', "${app_name}").exists();
            }
          }
        }
      }
      steps {
        script {
          openshift.withCluster("MiniShift"){
            openshift.withProject(){
              openshift.newApp('https://github.com/Madomur/rails-ex.git')
              echo "create new App ${openshift.project()} in cluster ${openshift.cluster()}"
            }
          }
        }
      }
    }

    stage('update App') {
      when {
        expression {
          openshift.withCluster("MiniShift"){
            openshift.withProject(){
              // echo "check ${openshift.selector('bc', "${app_name}")}"
              return openshift.selector('bc', "${app_name}").exists();
            }
          }
        }
      }
      steps {
        script {
          openshift.withCluster("MiniShift"){
            //openshift.newApp('https://github.com/Madomur/rails-ex.git').narrow('bc')
            openshift.withProject(){
              def bc = openshift.selector('bc', "${app_name}")

              echo "update new App ${openshift.project()} in cluster ${openshift.cluster()}"
            }
          }
        }
      }
    }
    stage ('deploy APP') {
      steps {
        script {
          openshift.withCluster("MiniShift"){
            openshift.withProject(){
              def dc = openshift.selector('dc', "rails-foo")
              echo "rollout App ${openshift.project()} in cluster ${openshift.cluster()}"
              dc.rollout()
            }
          }
        }
      }
    }
  }
}