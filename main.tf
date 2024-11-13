provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

resource "kubernetes_namespace" "tf-k8s-ns" {
  metadata {
    name = "eak-ns"
  }
}

resource "kubernetes_deployment" "tf-k8s-deployment" {
  metadata {
    name = "eak-deployment"
    labels = {
      app = "otus-app"
    }
    namespace = kubernetes_namespace.tf-k8s-ns.id
  }
  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "otus-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "otus-app"
        }
      }

      spec {
        container {
          image = "c0r2jh/otus-sre-lesson-8:latest"
          name  = "otus-app"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }

          }
        }
      }
    }
  }
}

resource "kubernetes_service" "tf-k8s-service-otus-app" {
  metadata {
    name      = "eak-service-otus-app"
    namespace = kubernetes_namespace.tf-k8s-ns.id
  }
  spec {
    selector = {
      App = kubernetes_deployment.tf-k8s-deployment.spec.0.template.0.metadata[0].labels.app
    }
    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}
