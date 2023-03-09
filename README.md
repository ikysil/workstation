# workstation

Ansible scripts to configure desktop workstations.

Features

--------
Browse through the [Roles](roles/) to see what features are implemented.

Usage

--------

1) Boot a TUXEDO OS on the target system.
2) Install the OS with relatively sane defaults. Reboot into local OS.
3) Run the [setup script](https://github.com/ikysil/workstation/blob/main/scripts/setup-tuxedo.sh) to do some pre-flight tests and load the repository.
4) Run a playbook!

```bash
ansible-playbook -K --ask-vault-pass playbooks/home.yml
```

5) Reboot
