---
title: "TCP Port Forwarding with Nginx Ingress on a Bare Metal Kubernetes Cluster"
date: 2021-02-18T15:19:18+05:30
draft: true
toc: true
images:
tags:
  - Configuration
---

---
Ingress is meant for 80 and 443 traffic redirects to services running within the cluster. Exposing a service to outside world other than the HTTP traffic is normally done by NodePort service or `kubectl port-forward` procedure. The former runs on port numbers above 30000 and the later is commonly used for testing.

If we need to get our services running on specific port number for external access, then additional configurations are required on the ingress deployment,service and configmap. This article covers them each and is applicable for k8s cluster running on cloud/on-premise.
---

## Install Nginx Ingress Controller

Remove existing nginx controller configuration through helm or `kubectl delete ns ingress-nginx`

### Install nginx ingress

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.44.0/deploy/static/provider/baremetal/deploy.yaml
```

## Configuration Updates

### Update nginx service configuration

```shell
kubectl edit service/ingress-nginx-controller -n ingress-nginx
```

- The Ingress service type is set to NodePort. This has to be modified and set to LoadBalancer type `type: LoadBalancer`

- For bare metal clusters, add the attribute  `externalIPs:` and add either an externally configured load balancer IP or a local network interface IP (typically eth0)

- Add the required custom TCP ports which are to be opened up through ingress

To expose rabbitmq application ports, these are the typical changes

```yaml
spec:
  clusterIP: 10.43.198.64
  externalIPs:
  - 10.128.0.13
  externalTrafficPolicy: Cluster
  ports:
  - name: http
    nodePort: 31954
    port: 80
    protocol: TCP
    targetPort: http
  - name: https
    nodePort: 31997
    port: 443
    protocol: TCP
    targetPort: https
  - name: rabbitmq-tcp-15672
    nodePort: 31555
    port: 15672
    protocol: TCP
    targetPort: 15672
  - name: rabbitmq-tcp-5672
    nodePort: 31556
    port: 5672
    protocol: TCP
    targetPort: 5672
  selector:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  sessionAffinity: None
  type: LoadBalancer
```

### Update nginx Deployment configuration

```sh
kubectl edit deployment.apps/ingress-nginx-controller -n ingress-nginx
```

- Update the controller args to support tcp and udp services.

  The 2 arguments must be added to the controller

  **--tcp-services-configmap=$(POD_NAMESPACE)/tcp-services**

  **--udp-services-configmap=$(POD_NAMESPACE)/udp-services**

```yaml
    spec:
      containers:
      - args:
        - /nginx-ingress-controller
        - --election-id=ingress-controller-leader
        - --ingress-class=nginx
        - --configmap=$(POD_NAMESPACE)/ingress-nginx-controller
        - --tcp-services-configmap=$(POD_NAMESPACE)/tcp-services
        - --udp-services-configmap=$(POD_NAMESPACE)/udp-services
        - --validating-webhook=:8443
        - --validating-webhook-certificate=/usr/local/certificates/cert
        - --validating-webhook-key=/usr/local/certificates/key
```

- Add the ports to open up on controller pod(s)

```yaml
        ports:
        - containerPort: 80
          name: http
          protocol: TCP
        - containerPort: 443
          name: https
          protocol: TCP
        - containerPort: 8443
          name: webhook
          protocol: TCP
        - containerPort: 15672
          name: rabbitmqadm
          protocol: TCP
        - containerPort: 5672
          name: rabbitmqamqp
          protocol: TCP
```

### ConfigMap Changes

Create a configmap data for the custom ports - configmap-port-expose.yaml

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: tcp-services
  namespace: ingress-nginx
data:
  15672: "rabbitmq/rabbittestha-rabbitmq:15672"
  5672: "rabbitmq/rabbittestha-rabbitmq:5672"
```

Refers - `rabbitmq` namespace and `rabbittestha-rabbitmq` service within that namespace

## Testing

Connect to the TCP port using telnet and node IP

```sh
$ telnet 10.128.0.13 15672
Trying 10.128.0.13...
Connected to 10.128.0.13.
Escape character is '^]'.
^]
telnet>
```

With an external/Floating/LoadBalancer IP attached to this server, the service will be accessible from outside world
