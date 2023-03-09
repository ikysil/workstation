#!/bin/bash

source /lib/lsb/init-functions

check_sudoers() {
    sudo cat /etc/sudoers | grep -i requiretty >/dev/null
    rc=$?
    if [ ${rc} != 1 ]; then
        log_failure_msg "requiretty is specified in sudoers."
        return 1
    else
        log_success_msg "Sudoers does not requiretty."
    fi
}

check_updates() {
    sudo apt-get -y update >/dev/null
    rc=$?
    if [ ${rc} != 0 ]; then
        log_failure_msg "System has package updates available."
        return 1
    fi
    log_success_msg "System has no updates available."
}

check_efi() {
    sudo grub-probe -t device /boot/EFI >/dev/null 2>&1
    rc=$?
    if [ ${rc} != 0 ]; then
        log_failure_msg "EFI bootloader not found."
        return 1
    fi
    log_success_msg "EFI bootloader found."
}

check_kernel() {
    latest_installed=$(for kimg in $(/bin/ls -t /boot/vmlinuz-*); do
        echo $kimg
        return
    done)
    latest_installed="${latest_installed/\/boot\/vmlinuz-/''}"

    running=$(uname -r)

    if [[ ${latest_installed} != ${running} ]]; then
        log_failure_msg "Latest kernel is not running. Reboot and try again."
        return 1
    fi

    log_success_msg "Latest installed kernel is running."
}

check_hostname() {
    if [[ $(hostname) == *"localhost"* ]]; then
        log_failure_msg "Hostname must not be localhost."
        return 1
    fi

    log_success_msg "Hostname is set."
}

check_secureboot() {
    if [[ "$(sudo mokutil --sb-state)" != *"disabled"* ]]; then
        log_failure_msg "SecureBoot is enabled."
        return 1
    fi
    log_success_msg "SecureBoot is disabled."
}

ret=0
check_sudoers
ret=$((ret + $?))
check_updates
ret=$((ret + $?))
check_efi
ret=$((ret + $?))
check_kernel
ret=$((ret + $?))
check_hostname
ret=$((ret + $?))
check_secureboot
ret=$((ret + $?))

exit ${ret}
