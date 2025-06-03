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
          withCredentials([usernamePassword(
  credentialsId: "docker-hub",
  usernameVariable: 'USER',
  passwordVariable: 'PASS'
)]) {
  sh 'echo "$PASS" | docker login -u "$USER" --password-stdin'
}
        }
      }
    }
    }
    stage('Deploy to Kubernetes (Helm)') {
      steps {
       withCredentials([file(credentialsId: 'kubeconfig-dev', variable: 'KUBECONFIG')]) {
    sh '''
      echo "Deploying to Kubernetes via Helm..."
      helm upgrade --install casestudy-jenkins ./helm \
        --set image.repository=hapizaa/my-app \
        --set image.tag=latest \
        --namespace default --create-namespace
    '''
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
