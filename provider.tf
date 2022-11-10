terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.8.0"
    }

    grafana = {
      source  = "grafana/grafana"
      version = "~> 1.30.0"
    }
  }
}

provider "github" {
  owner = local.owner
}

provider "grafana" {
  url  = "http://localhost:3000"
  auth = "admin:admin"
}
