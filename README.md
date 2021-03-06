[![Build Status](https://travis-ci.org/TheNatureOfSoftware/kubernetes-on-nomad.svg?branch=master)](https://travis-ci.org/TheNatureOfSoftware/kubernetes-on-nomad)

# kubernetes-on-nomad

## What

Kubernetes-On-Nomad `kon` is a tool for simplifying running [Kubernetes](https://kubernetes.io/)
on [Nomad](https://www.nomadproject.io/) using [Consul](https://www.consul.io/)
(Vault coming soon) for storing all Kubernetes configuration.

It's not involved during runtime but helps you setup Nomad, Consul and Kubernetes together.

## Why running Kubernetes on Nomad

There are similarities between Nomad and Kubernetes but there are also some key differences [(see Nomad vs. Kubernetes)](https://www.nomadproject.io/intro/vs/kubernetes.html). The main thing is that they are both **tools** in our toolbox. Nomad and Consul are both master-less which is something we can use.

* All etcd and kubernetes configuration and certificates stored in Consul (Vault coming soon)
* Simple handling of Kubernetes infrastructure and control plane
* HA out of the box, there is no single master as long as you have enough nodes. Nomad handles the Kubernetes Control plane.
* Easy to set up a Kubernetes cluster (uses kubeadm under the hood)

## How

Generate a sample `kon.conf` file:
```
$ kon generate init
```

Edit `kon.conf` and add all your machines. Then run `cluster apply` on any machine that can do `ssh` password-less:
```
$ kon --config ./kon.conf cluster apply
```

Then login to any node and run:
```
core-01 ~ # kon etcd config
core-01 ~ # kon etcd start
core-01 ~ # kon kubernetes install
core-01 ~ # kon kubernetes config
core-01 ~ # kon kubernetes start
```

## Examples

* [CoreOS Vagrant example](./examples/coreos)
* [CoreOS Azure example](./examples/azure)
* [Ubuntu Scaleway example](./examples/scaleway)


