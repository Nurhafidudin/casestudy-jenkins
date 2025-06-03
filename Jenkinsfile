pipeline {
  agent any

  environment {
    IMAGE = "hapizaa/my-app"
    TAG = "latest"
    DOCKER_CRED = "docker-hub"
    KUBECONFIG_CRED = "kubeconfig-dev"
    NAMESPACE = "default"
    HELM_RELEASE = "casestudy-jenkins"
  }

  stages {
    stage('Checkout Source Code') {
      steps {
        git url: 'https://github.com/Nurhafidudin/casestudy-jenkins.git', branch: 'main'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          echo "🛠️ Building image ${IMAGE}:${TAG}..."
          def builtImage = docker.build("${IMAGE}:${TAG}")
        }
      }
    }

    stage('Push Docker Image') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: "docker-hub",
          usernameVariable: 'USER',
          passwordVariable: 'PASS'
        )]) {
          script {
           withCredentials([string(credentialsId: 'docker-pass', variable: 'PASS')]) {
  sh 'echo "$PASS" | docker login -u hapizaa --password-stdin'
}
        }
      }
    }
    }
    stage('Deploy to Kubernetes (Helm)') {
      steps {
        withCredentials([file(credentialsId: "${KUBECONFIG_CRED}", variable: 'KUBE_FILE')]) {
          script {
            echo "🚀 Deploying to Kubernetes via Helm..."
            sh '''
              export KUBECONFIG=$KUBE_FILE
              helm upgrade --install $HELM_RELEASE ./helm \
                --set image.repository=$IMAGE \
                --set image.tag=$TAG \
                --namespace $NAMESPACE --create-namespace
            '''
          }
        }
      }
    }
  }

  post {
    success {
      echo "✅ Pipeline Sukses: Aplikasi berhasil dideploy ke Kubernetes"
    }
    failure {
      echo "❌ Pipeline Gagal: Cek log untuk mengetahui error"
    }
  }
}
