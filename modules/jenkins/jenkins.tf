resource "helm_release" "jenkins" {
  name             = "jenkins"
  namespace        = var.namespace
  create_namespace = true

  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = var.chart_version

  # Підтягуємо наш кастомний values.yaml з вимкненою persistence
  values = [
    file("${path.module}/values.yaml")
  ]

  # Головний трюк:
  # НЕ чекаємо, поки поди стануть Running — для ДЗ це зайве.
  wait    = false
  timeout = 600

  # На випадок дрібних змін у чарті
  cleanup_on_fail = true
}
