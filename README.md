# elasticsky

The `elasticsky` repository contains a set of Ansible playbooks and scripts for managing the deployment and configuration of virtual machines, primarily for AWX (Ansible Tower) environments. The project supports various tasks such as VM cloning, IP address management, and VM power control.


- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Directory Structure](#directory-structure)
- [Contributing](#contributing)
- [License](#license)

---

## Requirements
Before using this repository, ensure that your environment meets the following requirements:

- Ansible: Version 2.9 or higher
- AWX / Ansible Tower: For managing and scheduling tasks
- Git: To clone and manage repository versions
- Access to ESXi server(s): with administrative privileges
- Python modules:
   - `pyvmomi` (for VMware management via Ansible)
   - `netaddr` (for IP address management)

You can install the required Python modules with:
```bash
pip install pyvmomi netaddr
```

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your_username/elasticsky.git
   cd elasticsky

2. Configure inventory files:
Open and edit `inventory/hosts.ini` to define your target hosts and groups.
Customize `change_ip.ini` and any other inventory files as needed to fit your infrastructure setup.

3. Set up necessary variables:
Adjust variable files in `roles/vm_management/vars` and `playbooks/deployment/` if required for your environment.

## Usage
Example: Cloning a VM
To clone a VM using a predefined template:

```bash
   Copy code
   ansible-playbook -i inventory/hosts.ini playbooks/deployment/copyVm.yml --extra-vars "template_param=<template> destination_param=<new_vm>"
```





## Directory Structure

```plaintext
elasticsky/
├── README.md                 # Project documentation
├── inventory/                # Inventory files for different environments and tasks
│   ├── hosts.ini             # Main inventory for playbooks
│   ├── change_ip.ini         # Inventory for IP change tasks
│   └── dev.ini               # Inventory for the development environment
├── playbooks/                # Main directory for playbooks
│   ├── deployment/           # Deployment playbooks
│   │   ├── copyVm.yml        # VM cloning playbook
│   │   ├── mgmtVmPower.yml   # Playbook for managing VM power
│   │   ├── changeVmName.yml  # Playbook for changing VM hostname
│   │   └── changeTmplIpAddr.yml # Playbook for changing IP address
│   ├── management/           # Management playbooks
│   │   ├── changeVmIpAddr.yml # IP address change playbook
│   └── info/                 # Information playbooks
│       ├── getAllVms.yml     # Playbook to retrieve all VM information
│       └── listDatastoreContent.yml # Playbook to list datastore content
├── roles/                    # Ansible roles (modular functionalities)
│   └── vm_management/        # VM management role
│       ├── tasks/            # Role tasks
│       ├── templates/        # Templates (e.g., Netplan)
│       └── vars/             # Role variables
├── scripts/                  # Supporting scripts for infrastructure management
│   ├── checkVmStateAns.sh    # Script to check VM state
│   └── listAllVmsJSON.sh     # Script to list VMs in JSON format
└── esxi_scripts/             # Scripts to be run directly on ESXi
    └── custom_esxi_tasks.sh  # Example ESXi script

```
