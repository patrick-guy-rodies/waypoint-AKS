# The name of your project. A project typically maps 1:1 to a VCS repository.
# This name must be unique for your Waypoint server. If you're running in
# local mode, this must be unique to your machine.
project = "hugo-project"



# An application to deploy.
app "web" {
    # Build specifies how an application should be deployed. In this case,
    # we'll build using a Dockerfile and keeping it in a local registry.
    build {
        hook {
            when = "before"
            command = ["hugo"]
            on_failure = "fail"
        }
        use "docker" {}
            registry {
            use "docker" {
                image = "pgr095.azurecr.io/example-hugo"
                tag   = "latest"
            }
        }
  }

  deploy {
    use "kubernetes" {
      probe_path = "/"
      service_port = "80"
    }
  }

  release {
    use "kubernetes" {
      load_balancer = true
      port          = 80
    }
  }
}
