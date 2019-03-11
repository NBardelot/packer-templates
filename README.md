# TL;DR

This is a Packer project to build a CentOS 7 VM using Ansible for provisionning.

## Files and directories

This Git repository quickly explained:

    │   .gitignore                                
    │   README.md
    │   anaconda-ks.cfg                              # A Kickstart file to install the CentOS 7 system
    │   CentOS-7-x86_64.json                         # A Packer file to build the VM image
    │   validate.sh                                  # Check Kickstart & Packer files
    │   LINUX_install-packer-and-virtualbox.yml      # A playbook to install Packer And VirtualBox on CentOS/RHEL     
    ├───(output-virtualbox-iso)                      # The directory that Packer will create where the VM image will be published
    │       (*.ova)                                  # You can configure the image type to OVA to make Packer build a single archive for the VM
    ├───(packer_cache)                               # The directory that Packer will create where it will download the base image 
    │       (*.iso)                                  # All ISO files are kept in cache, feel free to make a crontab to remove the old ones...
    └───provisionning-playbooks                      # A directory containing all that Ansible will use to provision the VM
        │   provisionning.yml                           # The main playbook to provision a standard VM
        └───roles                                       # Each role will be kept here
            └───first-user                           # This role creates a first 'admin' user for the VM who has got administrator privilege 

# Prerequisites

## Windows

### (Windows) 1st step: install VirtualBox

Check [VirtualBox's website](https://www.virtualbox.org/wiki/Downloads/).

### (Windows) 2nd step: Install Git & clone this project

Get Git from the [official website](https://git-scm.com/download/).

### (Windows) 3rd step: download Packer

Get Packer from the [official website](https://releases.hashicorp.com/packer/).

Unzip the `packer.exe` file at the root of this project or put it somewhere else and configure your PATH.

## Linux

### (Linux) 1st step: install Ansible & Git

CentOS/RHEL :

    sudo yum install ansible git
    
### (Linux) 2nd step: clone this project Git and the playbook in charge of VirtualBox and Packer installation

    ansible-playbook -K LINUX_install-packer-and-virtualbox.yml
    
You can then add your own user to the `packer` group created by the playbook :

    usermod -a -G packer $(whoami)

# How to build a CentOS 7 VM image?

  1. Run `./validate.sh` to check *Kickstart*'s `anaconda-ks.cfg`
     and *Packer*'s `CentOS-7-x86_64.json`
  2. Run the build with `packer build CentOS-7-x86_64.json`

# See also:

  1. [Installing VirtualBox on Linux using a yum `.repo` file](https://www.virtualbox.org/wiki/Linux_Downloads)
  2. [Builder `virtualbox-iso` for Packer](https://www.packer.io/docs/builders/virtualbox-iso.html)
  3. [Reference for `kickstart` files for CentOS/RHEL 7](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/sect-kickstart-syntax)
  4. [Boot options for `anaconda`](https://anaconda-installer.readthedocs.io/en/latest/boot-options.html)
