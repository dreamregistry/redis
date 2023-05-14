terraform {
  backend "s3" {}

  required_providers {
    docker = {
      source  = "registry.terraform.io/kreuzwerker/docker"
      version = "~>3.0"
    }

    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = "~>3.5"
    }
  }
}

provider "random" {}
provider "docker" {}

resource "random_pet" "container_name" {}

resource "docker_image" "redis" {
  name         = "redis:latest"
  keep_locally = true
}

resource "docker_container" "redis" {
  name  = "redis-${random_pet.container_name.id}"
  image = docker_image.redis.image_id
  ports {
    internal = 6379
    external = 6379
  }
}

output "REDIS_HOST" {
  value = "127.0.0.1"
}

output "REDIS_PORT" {
  value = 6379
}
