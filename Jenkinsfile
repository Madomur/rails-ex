#!/usr/bin/env groovy

properties([buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '14', numToKeepStr: '5')), pipelineTriggers([])])

pipeline {
  agent any

  environment {
    baseImageTag = "v1.0.0"
    baseImageName = "centos/ruby-22-centos7"
    s2iImageNAme = "huk24/ruby-hello-world"
    project_name = "huk24"
  }

  stages {
    stage('create new App') {
      when {
        expression {
          openshift.withCluster("MiniShift"){
            openshift.withProject("${project_name}"){
              return !openshift.selector('bc', 'ruby-hello-world').exists();
            }
          }
        }
      }
      steps {
        script {
          openshift.withCluster("MiniShift"){
            openshift.withProject("${project_name}"){
              openshift.newApp('https://github.com/Madomur/ruby-hello-world.git')

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
            openshift.withProject("${project_name}"){
              // echo "check ${openshift.selector('bc', 'ruby-hello-world')}"
              return openshift.selector('bc', 'ruby-hello-world').exists();
            }
          }
        }
      }
      steps {
        script {
          openshift.withCluster("MiniShift"){
            def bc = openshift.selector('bc', 'ruby-hello-world')
            //openshift.newApp('https://github.com/Madomur/ruby-hello-world.git').narrow('bc')
            openshift.withProject("${project_name}"){

              echo "update new App ${openshift.project()} in cluster ${openshift.cluster()}"
              bc.startBuild()
            }
          }
        }
      }
    }
  }
}