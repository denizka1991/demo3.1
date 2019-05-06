##########################
### K8S PODs - Jypiter ###
##########################
resource "kubernetes_persistent_volume_claim" "custom-files" {
  metadata {
    name = "custom-files"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests {
        storage = "2Gi"
      }
    }

    storage_class_name = "standard"
  }
}

resource "kubernetes_deployment" "jupyter-notebook" {
  metadata {
    name = "jupyter-notebook"

    labels {
      app  = "jupyter-notebook"
      role = "master"
      tier = "backend"
    }
  }

  spec {
    replicas = 1

    selector = {
      match_labels {
        app  = "jupyter-notebook"
        role = "master"
        tier = "backend"
      }
    }

    template {
      metadata {
        labels {
          app  = "jupyter-notebook"
          role = "master"
          tier = "backend"
        }
      }

      spec {
        security_context {
          fs_group = 100
        }
        volume {
          name      = "myfiles"
        }
        container {
          image = "jupyter/all-spark-notebook"
          name  = "minimal-notebook"
          command = [ "start-notebook.sh" ]
            args = [
              "--NotebookApp.base_url='/jupyterx'", 
              "--NotebookApp.token='${var.j_token}'"
            ]
        

          volume_mount {
            mount_path = "/home/jovyan/work"
            name       = "myfiles"
            read_only = false
          }

          port {
            container_port = 8888
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