terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

variable "image" {
  description = "Docker image to use"
  default     = "nginx:latest"
}

variable "container_memory" {
  description = "Memory to allocate for the container"
  default     = "128"
}

variable "privileged" {
  description = "Whether the container should be privileged or not"
  default     = false
}

variable "num_containers" {
  description = "Number of containers to spawn"
  default     = 2
}

variable "starting_port" {
  description = "Port to use as starting point"
  default     = 3000
}

resource "docker_image" "nginx" {
  name = var.image
}

resource "docker_container" "nginx" {
  count = var.num_containers

  image        = var.image
  name         = "my_nginx_container_${count.index}"
  memory       = var.container_memory
  privileged   = var.privileged
  ports {
    internal = 80
    external = var.starting_port + count.index
  }
}
