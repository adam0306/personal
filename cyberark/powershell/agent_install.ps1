pull creds from CCP
create cred file
run Install


Get current path



Set-Location # download files here.
Copy-Item # copy files to target machine.
Invoke-WebRequest # CCP call for credentials to create cred file
Set-Location # change directory to build cred file
CreateCredFile AppProviderUser.cred Password /Username <username> /Password <userPassword> /Hostname /EntropyFile
Install
'.\setup.exe /s /f1"C:\~\silent.iss" "C:\~\cred file"'

copy files to machine
pull creds from ccp
create cred file
install




---
- name: Production Windows Server AAM Agent Install
  hosts: all
  gather_facts: no
  tasks:

    - name: Copy Installation Media
      win_copy:
        src: /media
        dest: C:\~
        remote_dst: yes
  
    - win_shell: '.\setup.exe /s /f1"C:\~\silent.iss" "C:\~\cred file"'
      args:
        chdir: C:\