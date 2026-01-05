# Active Directory Tools

A collection of tools for interacting with Active Directory:
- A Python GUI application for browsing users and viewing group memberships
- A PowerShell script for exporting AD user data to CSV

Parts of these scripts were developed with AI assistance. All code was reviewed, 
tested, and fully understood by me.

---

## Python Application

### Requirements
- Python 3.8+
- PyQt5
- ldap3

### Install
pip install PyQt5 ldap3

### Configuration
Create a config.json file:

{
  "ad_server": "your.domain.controller",
  "username": "DOMAIN\\user",
  "password": "password",
  "base_dn": "dc=example,dc=com"
}

### Run
python3 main.py

---

## PowerShell Script

### Requirements
- Windows PowerShell 5.1 OR PowerShell 7+
- ActiveDirectory module
- (Optional)Microsoft.PowerShell.GraphicalTools

Install:
Install-Module Microsoft.PowerShell.GraphicalTools -Scope CurrentUser

### Run
.\export-users.ps1

---

## Portfolio Status
This project is part of my ongoing portfolio. More features and improvements are planned.

## License
MIT
