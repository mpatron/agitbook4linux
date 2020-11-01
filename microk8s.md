# microk8s

il faut 3 nodes pas moins sinon ca ne fonctionne pas.

~~~bash
root@node1:~# sudo snap install microk8s --classic
microk8s (1.19/stable) v1.19.2 from Canonical✓ installed
root@node1:~# microk8s inspect
Inspecting Certificates
Inspecting services
  Service snap.microk8s.daemon-cluster-agent is running
  Service snap.microk8s.daemon-containerd is running
  Service snap.microk8s.daemon-apiserver is running
  Service snap.microk8s.daemon-apiserver-kicker is running
  Service snap.microk8s.daemon-proxy is running
  Service snap.microk8s.daemon-kubelet is running
  Service snap.microk8s.daemon-scheduler is running
  Service snap.microk8s.daemon-controller-manager is running
  Copy service arguments to the final report tarball
Inspecting AppArmor configuration
Gathering system information
  Copy processes list to the final report tarball
  Copy snap list to the final report tarball
  Copy VM name (or none) to the final report tarball
  Copy disk usage information to the final report tarball
  Copy memory usage information to the final report tarball
  Copy server uptime to the final report tarball
  Copy current linux distribution to the final report tarball
  Copy openSSL information to the final report tarball
  Copy network configuration to the final report tarball
Inspecting kubernetes cluster
  Inspect kubernetes cluster

Building the report tarball
  Report tarball is at /var/snap/microk8s/1769/inspection-report-20201026_193625.tar.gz
root@node1:~# microk8s status
microk8s is running
high-availability: no
  datastore master nodes: 127.0.0.1:19001
  datastore standby nodes: none
addons:
  enabled:
    ha-cluster           # Configure high availability on the current node
  disabled:
    ambassador           # Ambassador API Gateway and Ingress
    cilium               # SDN, fast with full network policy
    dashboard            # The Kubernetes dashboard
    dns                  # CoreDNS
    fluentd              # Elasticsearch-Fluentd-Kibana logging and monitoring
    gpu                  # Automatic enablement of Nvidia CUDA
    helm                 # Helm 2 - the package manager for Kubernetes
    helm3                # Helm 3 - Kubernetes package manager
    host-access          # Allow Pods connecting to Host services smoothly
    ingress              # Ingress controller for external access
    istio                # Core Istio service mesh services
    jaeger               # Kubernetes Jaeger operator with its simple config
    knative              # The Knative framework on Kubernetes.
    kubeflow             # Kubeflow for easy ML deployments
    linkerd              # Linkerd is a service mesh for Kubernetes and other frameworks
    metallb              # Loadbalancer for your Kubernetes cluster
    metrics-server       # K8s Metrics Server for API access to service metrics
    multus               # Multus CNI enables attaching multiple network interfaces to pods
    prometheus           # Prometheus operator for monitoring and logging
    rbac                 # Role-Based Access Control for authorisation
    registry             # Private image registry exposed on localhost:32000
    storage              # Storage class; allocates storage from host directory
root@node1:~# microk8s config
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURBVENDQWVtZ0F3SUJBZ0lKQUpIcTJrWHFzVmFWTUEwR0NTcUdTSWIzRFFFQkN3VUFNQmN4RlRBVEJnTlYKQkFNTURERXdMakUxTWk0eE9ETXVNVEFlRncweU1ERXdNall4T0RNMU1EaGFGdzB6TURFd01qUXhPRE0xTURoYQpNQmN4RlRBVEJnTlZCQU1NRERFd0xqRTFNaTR4T0RNdU1UQ0NBU0l3RFFZSktvWklodmNOQVFFQkJRQURnZ0VQCkFEQ0NBUW9DZ2dFQkFMVHJmamNIaDByS0ppZ0dXSm9VeU1heHdVMnZGU3h3Zm1aK0NuOFNXVnZjVVplZkY2TkwKbFhuNWJrVWVJdGpuMHN5ZEdzSGcya2FNUkxzRGZyWnZCalc0K2I4QXgvMERWT245S2RCamxkUXdTRjlwVDA4SQpsRDdYeVorMDlKRW1mRzJyblV3YkFlMWE2L1gwNkFNNGhDd25jL1E2WTBBL29PczlhQWVYUzU2RTRNSkg1MkZaCmxMRTlKekovWnBCZVNpbDdzSmVOMDVubnZjU0RrQi9PUHcvQlJjU01idG1BMmVUT2hVbzA4R1R4ZzJtbU15RHgKUHV5bDhSc1p5NFo2TUZrZjJuenJaQUw4L2RlUnhFczRvSjdEdUd3VjgzN2VraFVqWFRpUVQvY1lBd3JLMDNkLwp5S1U4NGdiYXpVL0pEOW8wQTltUDc1a0NNdjZjbWpsbzlZOENBd0VBQWFOUU1FNHdIUVlEVlIwT0JCWUVGRjdOClk0Kzl3WVhJZkR1bTFESi9rck4yNUZoUU1COEdBMVVkSXdRWU1CYUFGRjdOWTQrOXdZWElmRHVtMURKL2tyTjIKNUZoUU1Bd0dBMVVkRXdRRk1BTUJBZjh3RFFZSktvWklodmNOQVFFTEJRQURnZ0VCQUdrMEt0a3BFWUVsb1BwYwpDdTBRdzFONXpXR2M5SWZTNmlsdW9aaHZoaGV4c212VFhnc3JtbldZeWpTNVVqNkZMS0NtSUVVWURFa2pZeWhoCjU0QXkwMjA2T2Nsc1VCTGRuTUQxRHNRU0VxTlRGZk5HdlpOQ3NTTk91bHRyeVhmMnF3MURuTXcvekRMd2U1V1oKT01McmF5TnptWGkrNXdMVlBjK3VxU25PRU9ZUk9RL3RwY1RLUGw0V0ttdWNtOFo0OWFQSkVNTyttZ0k3OHFLYwpxeDVzb2VEL2RSK0EveE1FaHpWcU1RYkVaMllWa1VyczJ2Y1Q4Zkd4OVVydkQ4bVVqaFd3OWFka3dCZTZNOUpHCk1ZQjcxT2gydXIrM2dtb0UxY1dWVVl6K3Uyb3hBckRSVmx2NHNKTDlQUWVxOFpmdGc2VUVhL0lGcHc1WjVheEoKR2crTWlMND0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    server: https://10.0.2.15:16443
  name: microk8s-cluster
contexts:
- context:
    cluster: microk8s-cluster
    user: admin
  name: microk8s
current-context: microk8s
kind: Config
preferences: {}
users:
- name: admin
  user:
    token: MVZtMSticmRWY3FjNS9ZVGtMRkN5WVVHK2g0QjhOcXV2enJ3Tnc2OUhvbz0K
mickael@node1:~$ sudo microk8s add-node
[sudo] password for mickael:
From the node you wish to join to this cluster, run the following:
microk8s join 10.0.2.15:25000/2cc8a2a3ad0108e1295e2aae67c524fd

If the node you are adding is not reachable through the default interface you can use one of the following:
 microk8s join 10.0.2.15:25000/2cc8a2a3ad0108e1295e2aae67c524fd
 microk8s join 192.168.56.101:25000/2cc8a2a3ad0108e1295e2aae67c524fd
 microk8s join 10.1.166.128:25000/2cc8a2a3ad0108e1295e2aae67c524fd



mickael@node2:~$ snap install microk8s --classic
error: access denied (try with sudo)
mickael@node2:~$ sudo snap install microk8s --classic
microk8s (1.19/stable) v1.19.2 from Canonical✓ installed
mickael@node2:~$ sudo microk8s join 192.168.56.101:25000/2cc8a2a3ad0108e1295e2aae67c524fd
Contacting cluster at 192.168.56.101
Waiting for this node to finish joining the cluster. .
mickael@node2:~$ sudo microk8s kubectl get nodes
NAME    STATUS     ROLES    AGE   VERSION
node1   Ready      <none>   16m   v1.19.2-34+1b3fa60b402c1c
node2   NotReady   <none>   56s   v1.19.2-34+1b3fa60b402c1c
#Waiting ....
mickael@node2:~$ sudo microk8s kubectl get nodes
NAME    STATUS   ROLES    AGE   VERSION
node1   Ready    <none>   16m   v1.19.2-34+1b3fa60b402c1c
node2   Ready    <none>   89s   v1.19.2-34+1b3fa60b402c1c


mickael@node1:~$ sudo microk8s enable dashboard dns
Enabling Kubernetes Dashboard
Enabling Metrics-Server
clusterrole.rbac.authorization.k8s.io/system:aggregated-metrics-reader created
clusterrolebinding.rbac.authorization.k8s.io/metrics-server:system:auth-delegator created
rolebinding.rbac.authorization.k8s.io/metrics-server-auth-reader created
Warning: apiregistration.k8s.io/v1beta1 APIService is deprecated in v1.19+, unavailable in v1.22+; use apiregistration.k8s.io/v1 APIService
apiservice.apiregistration.k8s.io/v1beta1.metrics.k8s.io created
serviceaccount/metrics-server created
deployment.apps/metrics-server created
service/metrics-server created
clusterrole.rbac.authorization.k8s.io/system:metrics-server created
clusterrolebinding.rbac.authorization.k8s.io/system:metrics-server created
clusterrolebinding.rbac.authorization.k8s.io/microk8s-admin created
Adding argument --authentication-token-webhook to nodes.
Configuring node 192.168.56.102
Configuring node 192.168.56.101
Metrics-Server is enabled
Applying manifest
serviceaccount/kubernetes-dashboard created
service/kubernetes-dashboard created
secret/kubernetes-dashboard-certs created
secret/kubernetes-dashboard-csrf created
secret/kubernetes-dashboard-key-holder created
configmap/kubernetes-dashboard-settings created
role.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrole.rbac.authorization.k8s.io/kubernetes-dashboard created
rolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
deployment.apps/kubernetes-dashboard created
service/dashboard-metrics-scraper created
deployment.apps/dashboard-metrics-scraper created

If RBAC is not enabled access the dashboard using the default token retrieved with:

token=$(microk8s kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
microk8s kubectl -n kube-system describe secret $token

In an RBAC enabled setup (microk8s enable RBAC) you need to create a user with restricted
permissions as shown in:
https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md

Enabling DNS
Applying manifest
serviceaccount/coredns created
configmap/coredns created
deployment.apps/coredns created
service/kube-dns created
clusterrole.rbac.authorization.k8s.io/coredns created
clusterrolebinding.rbac.authorization.k8s.io/coredns created
Restarting kubelet
Adding argument --cluster-domain to nodes.
Configuring node 192.168.56.102
Configuring node 192.168.56.101
Adding argument --cluster-dns to nodes.
Configuring node 192.168.56.102
Configuring node 192.168.56.101
Restarting nodes.
Configuring node 192.168.56.102
Configuring node 192.168.56.101
DNS is enabled

mickael@node1:~$ sudo microk8s kubectl -n kube-system describe secret $(sudo microk8s kubectl -n kube-system get secret | grep default-token | awk '{print $1}')
Name:         default-token-x52pd
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: default
              kubernetes.io/service-account.uid: 53c28b16-024d-4270-b64d-b00b4b0202d6

Type:  kubernetes.io/service-account-token

Data
====
namespace:  11 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6InNYZ3BiUTI2VUFhM0RNTTlZb18zX3lBMS1RZk9FQTNfajFZeDB1c3pqdTAifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJkZWZhdWx0LXRva2VuLXg1MnBkIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImRlZmF1bHQiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI1M2MyOGIxNi0wMjRkLTQyNzAtYjY0ZC1iMDBiNGIwMjAyZDYiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZS1zeXN0ZW06ZGVmYXVsdCJ9.mFlDodUg1lV9oNR7D1ko8WKsFFH2PI5N1cGsFzhs2zXOXsRAtTRRuTEGR7qj4TscUCZZO2ZFZ1rp4x9xrDVKkh9WTB8AqNZQurIKBjjGZ4MkkTnkjqIhogsQGsO2-NAFZE9Xygt_2LUTpp6ViD7FvDbVcR-S4_JxSyPvom5AXIrD668R0ZCRWUTDc8fFwi34hJM_i8kzro6Y1tiq4Vmi4ZsM5NwqTA238ge2gjbLDP8zFynObzUDvXoq3aIUljpaun3js8tijXd_MBeJbnL3jwJBeXN1uOFI8Dra82U5kT-gUCqTM9NES2EyjHYMnWvrf9Y3ew3GEcec8nm3VklLaw
ca.crt:     1103 bytes


sudo microk8s kubectl -n kube-system describe secret $(sudo microk8s kubectl -n kube-system get secret | grep default-token | awk '{print $1}')
microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard --address 0.0.0.0 10443:443

#https://node1.jobjects.org:10443

...
sudo snap remove microk8s
~~~
