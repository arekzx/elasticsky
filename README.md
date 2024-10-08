# elasticsky

The `elasticsky` repository contains a set of Ansible playbooks and scripts for managing the deployment and configuration of virtual machines, primarily for AWX (Ansible Tower) environments. The project supports various tasks such as VM cloning, IP address management, and VM power control.

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


- [Installation](#installation)
- [Usage](#usage)
- [Directory Structure](#directory-structure)
- [Contributing](#contributing)
- [License](#license)

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your_username/elasticsky.git
   cd elasticsky
