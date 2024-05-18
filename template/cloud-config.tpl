#cloud-config
write_files:
  - path: /home/user/.bashrc
    content: | 
       alias sshbe="ssh user@ip"
    append: true