# daps -- docker, ansible, processes & services

This is a devops project for infrastructure as code.
[Culture is Defined by What You Cannot Say](http://thinkrelevance.com/blog/2014/02/17/culture-is-defined-by-what-you-cannot-say).

* [DigitalOcean](https://digitalocean.com) or any better / more expensive clouds
* [Packer](http://www.packer.io/) machine image builds + initial provisioning
* [Docker](https://www.docker.io) process containers - a guaranteed must
* [Baseimage](http://phusion.github.io/baseimage-docker/) a good starting point
* [Ansible](http://www.ansible.com/home) provision / link docker containers
* [Serf](http://www.serfdom.io) decentralized membership, events, queries
* [Consul](http://www.consul.io) service discovery, configuration, health
* [Dokku](https://github.com/progrium/dokku) `git push` deploy as if to Heroku
* [Amazonica](https://github.com/mcohen01/amazonica) services:
  - [CloudWatch](http://aws.amazon.com/cloudwatch)
  - [CloudFront](http://aws.amazon.com/cloudfront)
  - [S3](http://aws.amazon.com/s3)
  - [Dynamo](http://aws.amazon.com/dynamodb)
