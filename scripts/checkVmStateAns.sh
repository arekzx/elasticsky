#!/bin/bash

# Check if the VM name parameter is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <vm_name>"
    exit 1
fi

# Assign the VM name from the argument
vm_name="$1"

# Setting Working directory
working_directory=$PWD

echo "Working directory: $working_directory"

echo "--------------------------------------------------------------"

# Run the Ansible playbook to get the VM information and save to output.json
ansible-playbook -i "$working_directory/hosts.ini" "$working_directory/vmware.yml" --extra-vars "ansible_python_interpreter=/usr/bin/python3.10" | \
    sed -n '/"vm_info.virtual_machines"/,$p' > output.json

# Check if output.json was created and is not empty
if [ ! -s output.json ]; then
    echo "Failed to create a valid output.json or it is empty."
    exit 1
fi

# Remove the last few lines from output.json (adjust this if needed)
for i in {1..4}; do
    sed -i '$d' output.json  # Remove the last line multiple times
done

# Check if the output ends with a closing brace and remove the extra one if it does
if tail -n 1 output.json | grep -q '}'; then
    sed -i '$d' output.json  # Remove the last line (extra closing brace)
fi

# Add the necessary opening and closing braces to make it valid JSON
{
    echo '{'
    cat output.json
    echo '}'
} > temp.json && mv temp.json output.json

# Validate the JSON structure with jq
if ! jq . output.json > /dev/null 2>&1; then
    echo "Invalid JSON format in output.json. Please check the output."
    cat output.json  # Show the content for debugging
    exit 1
fi

# Replace the key in output.json
sed -i 's/"vm_info.virtual_machines"/"vm_info_virtual_machines"/g' output.json

# Now access the power state, MAC addresses, and IP addresses using jq
power_state=$(jq --arg vm_name "$vm_name" '.["vm_info_virtual_machines"][] | select(.guest_name == $vm_name) | .power_state' output.json)

# Check if power state was found
if [ -z "$power_state" ]; then
    echo "Virtual machine '$vm_name' not found."
else
    # Set color codes
    RED='\033[0;31m'  # Red color for powered off
    GREEN='\033[0;32m'  # Green color for powered on
    BOLD='\033[1m'  # Bold
    NC='\033[0m'  # No Color

    # Format the power state
    if [[ $power_state == *"poweredOff"* ]]; then
        power_state_formatted="${BOLD}${RED}${power_state}${NC}"
    elif [[ $power_state == *"poweredOn"* ]]; then
        power_state_formatted="${BOLD}${GREEN}${power_state}${NC}"
    else
        power_state_formatted="${BOLD}${power_state}${NC}"  # Default formatting
    fi

    # Extract MAC addresses
    mac_addresses=$(jq --arg vm_name "$vm_name" '.["vm_info_virtual_machines"][] | select(.guest_name == $vm_name) | .mac_address[]' output.json | tr '\n' ', ' | sed 's/, $//')

    # Extract IP addresses
    ip_addresses=$(jq --arg vm_name "$vm_name" '.["vm_info_virtual_machines"][] | select(.guest_name == $vm_name) | .vm_network | to_entries | .[] | .value.ipv4[]?' output.json | tr '\n' ', ' | sed 's/, $//') # Remove trailing comma

    # Count the number of interfaces based on MAC addresses
    interface_count=$(jq --arg vm_name "$vm_name" '.["vm_info_virtual_machines"][] | select(.guest_name == $vm_name) | .mac_address | length' output.json)

    # Output formatted power state
    echo -e "The power state of virtual machine '$vm_name' is: ${power_state_formatted}"

echo "--------------------------------------------------------------"

    echo "Number of interfaces: $interface_count"
    
    # Display MAC and IP addresses
    echo "MAC Addresses: $mac_addresses"
    echo "IP Addresses: $ip_addresses"
fi

