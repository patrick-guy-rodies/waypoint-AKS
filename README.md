# Testing Waypoint product from Hashicorp

This repo contains a Hugo deployment to play with. If you need more information about Hugo -> [quick-start guide](https://gohugo.io/getting-started/quick-start/#step-2-create-a-new-site)

The tutorial is based on Kubernetes implementation from Hashicorp -> [Waypoint on Kubernetes](https://learn.hashicorp.com/collections/waypoint/get-started-kubernetes)


## Pre-requisites

1. A Kubernetes 1.10+ cluster with role-based access control (RBAC) enabled

1. The kubectl command-line tool installed on your local machine and configured to connect to your cluster. You can read more about installing kubectl in the official documentation.

1. Some knowledge around Hugo, command line and Kubernetes

### Clone Repository

``` bash

$ git clone https://patrickguyrodies@bitbucket.org/patrickguyrodies/waypoint-AKS.git

```

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

### Install the Waypoint server

Now that you have created a Kubernetes environment, install the Waypoint server on it with the install command. The -accept-tos flag confirms that you accept the terms of service for our application URL service. You will need to create a namespace called waypoint for this example.

``` bash

$ k create namespace waypoint
namespace/waypoint created

$ waypoint install --platform=kubernetes -accept-tos -namespace=waypoint

service/waypoint created
statefulset.apps/waypoint-server created
+ Kubernetes StatefulSet reporting ready
 + Waiting for Kubernetes service to become ready..
 + Configuring server...
Waypoint server successfully installed and configured!

The CLI has been configured to connect to the server automatically. This
connection information is saved in the CLI context named "install-1607521268".
Use the "waypoint context" CLI to manage CLI contexts.

The server has been configured to advertise the following address for
entrypoint communications. This must be a reachable address for all your
deployments. If this is incorrect, manually set it using the CLI command
"waypoint server config-set".

Advertise Address: 52.166.140.157:9701
Web UI Address: https://52.166.140.157:9702

```

You can verify that the cluster was successfully created by running kubectl get all. You should see the waypoint-server-0 pod. The exact output will vary based on your Kubernetes platform.

``` bash

$ kubectl -n waypoint get all                                                                         
NAME                    READY   STATUS    RESTARTS   AGE
pod/waypoint-server-0   1/1     Running   0          14m

NAME               TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)                         AGE
service/waypoint   LoadBalancer   10.0.154.178   52.166.140.157   9701:31613/TCP,9702:32764/TCP   14m

NAME                               READY   AGE
statefulset.apps/waypoint-server   1/1     14m

```
You can also use the external IP from the service to access the Web UI

### Initialize Waypoint

Before you can build and deploy your application, you must initialize it with the init command.

When you initialize Waypoint for your application, Waypoint first looks for a Waypoint configuration file (waypoint.hcl) for the app in the directory.

The waypoint.hcl configuration file gives Waypoint instructions for how to build, deploy, and release your application.

If Waypoint cannot find the app's configuration file when you run waypoint init, Waypoint will create a starter waypoint.hcl file that you can customize for your application.

The remainder of this walkthrough uses the example of a setup from a Hugo project. Please check Reference at the start of this README


``` bash

$ cat waypoint.hcl

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

```

The build clause defines how Waypoint will build the application.

The hook command tell how to build the package and when

The deploy clause defines where Waypoint will deploy the application. The kubernetes option tells Waypoint to deploy the application to Kubernetes.

The release stanza defines how our application will be released to our environment. For example, in the case of external Kubernetes clusters this would be where you would configure a load_balanacer on a specific port.

With these configurations in place, execute the following command in order to initialize Waypoint with this configuration.

``` bash

$ waypoint init

```