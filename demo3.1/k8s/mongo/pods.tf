#######################
### K8S POD - Mongo ###
#######################
resource "kubernetes_deployment" "mongo_master" {
  metadata {
    name = "mongo-master"
    namespace = "${kubernetes_namespace.mongo_space.metadata.0.name}"

    labels {
      app  = "mongo"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    replicas = 1

    selector = {
      match_labels {
        app  = "mongo"
        role = "master"
        tier = "backend"
      }
    }

    template {
      metadata {
        labels {
          app  = "mongo"
          role = "master"
          tier = "backend"
        }
      }

      spec {
        container {
          image = "bitnami/mongodb:latest"
          name  = "master"

          port {
            container_port = 27017
          }

          env {
            name  = "MONGODB_DATABASE"
            value = "${var.MONGODB_DATABASE}"
          }

          env {
            name  = "MONGODB_USERNAME"
            value = "${var.MONGODB_USERNAME}"
          }

          env {
            name  = "MONGODB_PASSWORD"
            value = "${var.MONGODB_PASSWORD}"
          }

          env {
            name  = "MONGODB_ROOT_PASSWORD"
            value = "${var.MONGODB_ROOT_PASSWORD}"
          }

          resources {
            requests {
              cpu    = "100m"
              memory = "100Mi"
            }
          }
        }
      }
    }
  }
}