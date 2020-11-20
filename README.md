# Testing Waypoint product from Hashicorp

This repo contains a Hugo deployment to play with. If you need more information about Hugo -> [quick-start guide](https://gohugo.io/getting-started/quick-start/#step-2-create-a-new-site)

The tutorial is based on Kubernetes implementation from Hashicorp -> [Waypoint on Kubernetes](https://learn.hashicorp.com/collections/waypoint/get-started-kubernetes)


## Pre-requisites

1. A Kubernetes 1.10+ cluster with role-based access control (RBAC) enabled

1. The kubectl command-line tool installed on your local machine and configured to connect to your cluster. You can read more about installing kubectl in the official documentation.

1. Some knowledge around Hugo, command line and Kubernetes

### Clone Repository

                $ git clone https://patrickguyrodies@bitbucket.org/patrickguyrodies/waypoint-AKS.git

### Install Waypoint on your machine

#### Register the HashiCorp tap as a source and install it

``` bash

$ brew tap hashicorp/tap

```

``` bash

$ brew install hashicorp/tap/waypoint

```

To update to the latest, run

``` bash

$ brew upgrade hashicorp/tap/waypoint

```

One of the functions of the install task is that it creates a context that points to the newly created server with the appropriate authentication. This is how Waypoint knows the address of the server when you run other Waypoint commands.

#### Validate the installation

Validate the installation by running the waypoint command.

``` bash

$ waypoint
Usage: waypoint [-version] [-help] [-autocomplete-(un)install] <command> [args]

Common commands:
    release      Release a deployment.
    up           Perform the build, deploy, and release steps for the app.
    build        Build a new versioned artifact from source.
...

```


### 