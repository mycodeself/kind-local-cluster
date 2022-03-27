# kind-local-cluster

A base configuration of a kubernetes cluster with kind to be used locally.

It includes help scripts to manage applications using helm or kubectl in a simple way.

See https://kind.sigs.k8s.io/ to learn more about kind

## Requirements

- `kind`
- `bash`
- `yq`

## Structure

- `apps/` directory containing all applications, each directory containing one or more applications that are deployed in the same namespace
- `bootstrap/` directory containing the base configuration of the kind cluster
- `scripts/` directory containing all the utility scripts for cluster management
- `config.yaml` application configuration file used by the scripts

## Usage

### bootstrap

Creates the cluster and bootstrap the configuration

```sh
make bootstrap
```

### destroy

Destroys the entire cluster

```sh
make destroy
```

### install/upgrade/delete

Install, upgrade or delete an application from the cluster, full list of apps in `config.yaml` file

```sh
make [install|upgrade|delete] app=<app-name>
```

### install/upgrade/delete-all

Install, upgrade or delete all apps from the cluster. Ignore apps using the `config.yaml` file

```sh
make [install|upgrade|delete]-all
```
