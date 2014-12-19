# Used to build Astrolet's base image.
# This is an alternative to base.json - ultimately one will remain...
# $ docker build --rm -t astrolet/ab . # = ansible base

# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.9

# Set correct environment variables.
ENV HOME /root

# Only a temporary solution (for faster development)!
# Uncomment this to enable the insecure key.
RUN /usr/sbin/enable_insecure_key

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
# RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Install an SSH key of your choice.
# ADD your_key /tmp/your_key
# RUN cat /tmp/your_key >> /root/.ssh/authorized_keys && rm -f /tmp/your_key

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Ansible:
RUN apt-get update
RUN apt-get install -y sudo python-dev python-apt python-pycurl python-pip python-virtualenv
RUN pip install -U ansible==1.5.3

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
