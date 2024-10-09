#!/bin/bash

# Setting Working directory
working_directory=$PWD

echo $working_directory

# Run the Ansible playbook and capture the output
ansible-playbook -i $working_directory/hosts.ini $working_directory/vmware.yml --extra-vars "ansible_python_interpreter=/usr/bin/python3.10" | sed -n '/"vm_info.virtual_machines"/,$p' > output.json

# Remove the last 3 lines from output.json
sed -i '$d' output.json    # Remove last line
sed -i '$d' output.json    # Remove second-to-last line
sed -i '$d' output.json    # Remove third-to-last line
sed -i '$d' output.json    # Remove fourth-to-last line if necessary

# Add the missing opening curly brace at the start of the JSON file
sed -i '1i {' output.json

# jq . $working_directory/output.json
jq . output.json





