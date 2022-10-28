# Preparation
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

1. Obtain the CyberArk installation media from either the [CyberArk SFE](#Resources) or [CyberArk MarketPlace](#Resources).
2. Attach the Master CD, Operator CD and License file to the new vault.
3. Install the CyberArk Server software.
4. Install the CyberArk Replicate software.
5. Install the CyberArk Client software.
6. Update the DBParm.ini file 
7. Update the Vault.ini file
7. If the Vault Server did not start with the install of the software, start the Vault manually.
8. Connect to the new Vault using PrivateArk and enable the Operator user under the Users and Groups menu.
9. After enabling the Operator user set the password to be used later.
10. move data if not already
7. 
    ```
    PARestore.exe Vault.ini operator /fullvaultrestore
    ```
8. Stop the vault
9. In this step we will need to know how if initial installation of CyberArk included backup pool
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
- [Restore Utilities](https://docs.cyberark.com/Product-Doc/OnlineHelp/PAS/10.10/en/Content/PASIMP/Restore-Utilities.htm)
- [Restore Process](https://cyberark-customers.force.com/s/question/0D52J00008O7d7USAR/how-to-perform-a-full-restoration-of-the-vault-database-that-is-backed-up-using-pareplicate-utility-clustering-environment)
- [CyberArk SFE](https://support.cyberark.com/SFE/)
- [CyberArk MarketPlace](https://cyberark-customers.force.com/mplace/s/#software)