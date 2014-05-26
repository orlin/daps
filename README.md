# daps -- docker, ansible, processes & services

This is a devops project for infrastructure as code.
[Culture is Defined by What You Cannot Say](http://thinkrelevance.com/blog/2014/02/17/culture-is-defined-by-what-you-cannot-say).


Points of interest:

* [Packer](http://www.packer.io/) machine image builds + initial provisioning
* [Docker](https://www.docker.io) process containers - a guaranteed must
* [Baseimage](http://phusion.github.io/baseimage-docker/) a good starting point
* [Ansible](http://www.ansible.com/home) provision / link docker containers
* [Serf](http://www.serfdom.io) decentralized membership, events, queries
* [Consul](http://www.consul.io) service discovery, configuration, health
* [Dokku](https://github.com/progrium/dokku) `git push` deploy as if to Heroku

Clouds and services:

* [DigitalOcean](https://digitalocean.com) or any better / more expensive clouds
* [OpenShift](https://www.openshift.com) good for auto-scaling processing power
* [Dynamo](http://aws.amazon.com/dynamodb) easy Datomic storage
