#!/bin/bash

# System Health Checker

# Define thresholds for CPU, Memory, Disk, and Network
CPU_THRESHOLD=90
MEMORY_THRESHOLD=90
DISK_THRESHOLD=90
PING_THRESHOLD=1

# Function to check CPU usage
check_cpu() {
    CPU_USAGE=$(top -b -n 1 | grep "%Cpu(s)" | awk '{print $2}' | cut -d. -f1)
    if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
        echo "Alert: High CPU Usage - Current: $CPU_USAGE%"
    else
        echo "CPU Usage is within normal range - Current: $CPU_USAGE%"
    fi
}

# Function to check Memory usage
check_memory() {
    MEMORY_USAGE=$(free | awk '/Mem/ {print ($3/$2 * 100.0)}')
    if [ "$(printf '%.0f' "$MEMORY_USAGE")" -gt "$MEMORY_THRESHOLD" ]; then
        echo "Alert: High Memory Usage - Current: $MEMORY_USAGE%"
    else
        echo "Memory Usage is within normal range - Current: $MEMORY_USAGE%"
    fi
}

# Function to check Disk space
check_disk() {
    DISK_USAGE=$(df -h | awk '$NF=="/" {print $5}' | cut -d'%' -f1)
    if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
        echo "Alert: High Disk Usage - Current: $DISK_USAGE%"
    else
        echo "Disk Usage is within normal range - Current: $DISK_USAGE%"
    fi
}

# Function to check Network connectivity
check_network() {
    ping -c 1 google.com > /dev/null
    if [ $? -ne 0 ]; then
        echo "Alert: Network Unreachable"
    else
        echo "Network is reachable"
    fi
}

# Main function
main() {
    echo "Running System Health Check..."

    check_cpu
    check_memory
    check_disk
    check_network

    echo "System Health Check completed."
}

# Run the main function
main
