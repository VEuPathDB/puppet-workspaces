# workspaces

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with workspaces](#setup)
    * [Beginning with workspaces](#beginning-with-workspaces)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Manages setup and configuration of the ebrc workspaces system.  It includes
components outside of irods, but is mainly jenkins setup.

## Setup

### Beginning with workspaces

This system is split up into two pieces: workspaces, and workspaces::jenkins.
The workspaces class belongs on the irods provider, and the jenkins class
belongs wherever jenkins is running.  

If ldap is enabled, all ldap parameters need to be specified in hiera.

The workspaces class also looks up workspaces::jenkins values from hiera, see
the params.pp for details

## Usage

The classes here should just be included, and configured via hiera

## Reference


## Limitations

Very specific for an internal application, surely this is a limitation.

## Development

No thanks.


