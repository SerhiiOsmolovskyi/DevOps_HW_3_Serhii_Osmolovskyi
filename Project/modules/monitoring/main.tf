resource "helm_release" "monitoring" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version

  namespace        = var.namespace
  create_namespace = true

  # Мінімальна конфігурація Grafana + Prometheus + Alertmanager
  values = [
    yamlencode({
      grafana = {
        adminUser     = var.grafana_admin_user
        adminPassword = var.grafana_admin_password

        service = {
          type = "ClusterIP"
        }

        persistence = {
          enabled = false
        }
      }

      prometheus = {
        service = {
          type = "ClusterIP"
        }
      }

      alertmanager = {
        service = {
          type = "ClusterIP"
        }
      }
    })
  ]
}
