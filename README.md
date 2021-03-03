# Portefaix Mixin

The portefaix-mixin is a collection of reusable and configurable
[Prometheus](https://prometheus.io/) alerts, and [Grafana](https://grafana.com)
dashboards.

## Config Tweaks

There are some configurable options you may want to override in your usage of
this mixin. They can be found in [config.libsonnet](config.libsonnet).

## Using the mixin as raw files

You will need to generate the raw yaml files for inclusion in your Prometheus
installation.

Install the `jsonnet` dependencies (we use versions v0.16+):

```shell
go get github.com/google/go-jsonnet/cmd/jsonnet
go get github.com/google/go-jsonnet/cmd/jsonnetfmt
```

Install dependencies :

```
$ make deps
```

Generate yaml:

```shell
$ make all
```

To use the dashboards, it can be imported or provisioned for Grafana by grabbig
the dashboards JSON files.

## Manifests

Pre rendered manifests can also be found at `/manifests`.
These use the default configuration as mentioned in [Config Tweaks](#config-tweaks),
