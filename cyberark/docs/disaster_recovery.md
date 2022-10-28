# Prerequisites

- Master CD
- Operator CD
- Master Password
- Administrator Password
- CyberArk Installation Media
    - Server
    - Replicate
    - Client
- License File
- Double data disk of existing vault

# Steps

1. Install CyberArk server software
2. Install CyberArk Replicate software
3. Install CyberArk client software
4. Start the vault if not already started
5. Enable operator user
6. Set the operator user password
7. 
    ```
    PARestore.exe Vault.ini operator /fullvaultrestore
    ```
8. Stop the vault
9.  if initial installation of CyberArk included backup pool
    ```
    CAVaultManager RecoverBackupFiles /BackupPoolName <BackupPoolName>
    ```
10. 
    ```
    CAVaultManager RestoreDB
    ```
11. Start vault server
12. login
13. Verify credentials

# Resources

- [PARestore Video](https://cyberark-customers.force.com/s/article/)
- PARestore Video - https://cyberark-customers.force.com/s/article/Video-How-to-Perform-a-Full-Vault-Restore-Using-PARestore
- Restore Utilities - https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/10.10/en/Content/PASIMP/Restore-Utilities.htm
- Restore Process - https://cyberark-customers.force.com/s/question/0D52J00008O7d7USAR/how-to-perform-a-full-restoration-of-the-vault-database-that-is-backed-up-using-pareplicate-utility-clustering-environment