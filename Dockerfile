# Used to build Astrolet's base image.
# This is an alternative to base.json - ultimately one will remain...
# $ docker build --rm -t astrolet/phusion-ansible .

# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.9

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
# RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Ansible:
RUN apt-get update
RUN apt-get install -y sudo python-dev python-apt python-pycurl python-pip python-virtualenv
pip install -U ansible==1.5.3

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
