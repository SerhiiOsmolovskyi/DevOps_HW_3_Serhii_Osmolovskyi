from django.urls import path
from django.http import HttpResponse

def index(request):
    return HttpResponse("<h1 style='text-align:center;padding-top:40px;'>🚀 CI/CD Deployed Django App</h1><p style='text-align:center;'>Terraform + Jenkins + ECR + Helm + ArgoCD</p>")

urlpatterns = [
    path('', index),
]
