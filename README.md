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


### Install the Waypoint server TO BE CONFIRMED ON ACTUAL SANDBOX, REMOVE ACTUAL IMPLEMENTATION ANDNTRY AGAIN

Using your Kubernetes environment, install the Waypoint server on it with the install command. The -accept-tos flag confirms that you accept the terms of service for our application URL service.

``` bash
$ waypoint install --platform=kubernetes -accept-tos -namespace waypoint

service/waypoint created
statefulset.apps/waypoint-server created

```


You can verify that the cluster was successfully created by running kubectl get all. You should see the waypoint-server-0 pod. The exact output will vary based on your Kubernetes platform.

``` bash

$ kubectl get all

NAME                    READY   STATUS    RESTARTS   AGE
pod/waypoint-server-0   1/1     Running   0          2m34s
Copy
You can also visit the GKE console and find the waypoint-server StatefulSet.

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