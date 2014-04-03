# daps -- docker ansible packer serf / status

This is a devops project for infrastructure as code.
[Culture is Defined by What You Cannot Say](http://thinkrelevance.com/blog/2014/02/17/culture-is-defined-by-what-you-cannot-say).

* [DigitalOcean](https://digitalocean.com) cloud IaaS
* [Packer](http://www.packer.io/) machine image, provisioning
* [Docker](https://www.docker.io) process containers
* [Ansible](http://www.ansible.com/home) provision docker containers
* [Vagrant](http://www.vagrantup.com) develop [Docker on Ubuntu](https://github.com/angstwad/docker.ubuntu) Ansible playbook (otherwise optional)
* [Serf](http://www.serfdom.io) decentralized orchestration / discovery
* [Dokku](https://github.com/progrium/dokku) `git push` deploy as if to Heroku
* [Amazonica](https://github.com/mcohen01/amazonica) services:
  - [CloudWatch](http://aws.amazon.com/cloudwatch)
  - [CloudFront](http://aws.amazon.com/cloudfront)
  - [S3](http://aws.amazon.com/s3)
  - [Dynamo](http://aws.amazon.com/dynamodb)
