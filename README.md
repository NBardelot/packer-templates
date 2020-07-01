# TL;DR

This is a Packer project to build a VM images using Ansible for provisionning.

Currently only CentOS 7 is supported, but the project's layout allows for additionnal images to be added.

You might want to take a look at [Boxcutter](https://github.com/boxcutter/) for other images.

## Files and directories

This Git repository quickly explained:

  * `builds` : Packer configurations, with a configuration file to override defaults, and a `build.sh` script to build the image
  * `helpers` : Utility scripts
  * `init` : Playbooks to run locally on the build machine, in order to install Packer and some dependencies easily
  * `installers` : Configurations files and defaults for the VM images dedicated installers (Kickstart for CentOS, Preseed for Ubuntu...)
  * `provisionning-playbooks` : Ansible playbooks and roles that will be executed in the image post-install

# Prerequisites

## Windows

### (Windows) 1st step: install VirtualBox or Hyper-V

  * [VirtualBox's website](https://www.virtualbox.org/wiki/Downloads/)
  * [Microsoft's HyperV documentation](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v).

### (Windows + HyperV) Configuring an internal virtual switch to access the Internet

![Step 1, go the switches management UI][./doc/images/NAT-HyperV/1_manage_switches.png]
![Step 2, create the internal switch named 'nat'][./doc/images/NAT-HyperV/2_create_nat_internal_switch.png]
![Step 3, go to the host's network devices management UI][./doc/images/NAT-HyperV/3_manage_network_device.png]
![Step 4, share one device's Internet connexion with the internal 'nat' switch][./doc/images/NAT-HyperV/4_share_network_via_nat_switch.png]

̀### (Windows) 2nd step: Install Git & clone this project

Get Git from the [official website](https://git-scm.com/download/).

### (Windows) 3rd step: download Packer

Get Packer from the [official website](https://releases.hashicorp.com/packer/).

Unzip the `packer.exe` file at the root of this project or put it somewhere else and configure your PATH accordingly.

## Linux

### (Linux) 1st step: install Ansible & Git

CentOS/RHEL :

    sudo yum install ansible git
    
### (Linux) 2nd step: clone this project Git and the playbook in charge of VirtualBox and Packer installation

    ansible-playbook -K LINUX_install-packer-and-virtualbox.yml
    
You can then add your own user to the `packer` group created by the playbook :

    usermod -a -G packer $(whoami)

# How to build an ISO?

  * to build an ISO image for **HyperV**, go in `builds/HyperV` and run `./build.sh`
  * to build an ISO image for **VirtualBox**, go in `builds/VirtualBox` and run `./build.sh`

Before running a build you might want to take a look at those files:

  * `CentOS-7-x86_64.json` under `builds/<builder>` especially in order to check the networking options
  * `anaconda-ks.cfg.template` under `installers/<OS>` especially in order to add packages to be installed, or to manage the disks and partitionning

The file `anaconda-ks.cfg.template` is templated with `KS_` variables. The default values can be found in the same directory in `default_installation.conf`,
though you can override any of them by using a file named `installation.conf` in the `builds/<builder>` build directory.

# See also:

  1. [Installing VirtualBox on Linux using a yum `.repo` file](https://www.virtualbox.org/wiki/Linux_Downloads)
  2. [Builder `virtualbox-iso` for Packer](https://www.packer.io/docs/builders/virtualbox-iso.html)
  3. [Reference for `kickstart` files for CentOS/RHEL 7](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/sect-kickstart-syntax)
  4. [Boot options for `anaconda`](https://anaconda-installer.readthedocs.io/en/latest/boot-options.html)
