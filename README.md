# WinGet Pro Sync Manager

**WinGet Pro Sync Manager** is a custom-built GUI (Graphical User Interface) wrapper for the Windows Package Manager (WinGet). It transforms a complex command-line tool into a user-friendly, visual dashboard designed to streamline software synchronization and management.

By leveraging the Windows Forms library, this script provides a structured environment to audit your software library, import configurations from JSON files, and batch-process installations or uninstalls—all without typing a single line of code in the terminal.

---

## Key Features

* **Visual Status Tracking:** Uses "traffic light" logic for the status column, displaying a vibrant **GREEN YES** for installed apps and a **RED NO** for missing ones, making system states readable at a glance.
* **Smart Sorting & Filtering:** Features "Hard Sort" logic that automatically pushes ignored items to the bottom while keeping active tasks at the top, ensuring focus remains on relevant packages.
* **Automated Backup & Import:** Every initial sync automatically exports a timestamped JSON backup of your setup. You can also import existing JSON configurations to rapidly provision new machines.
* **Bulk Action Controls:** Manage hundreds of packages instantly with "All Keep" and "All Ignore" buttons. The "UPDATE & Make Changes" button handles the heavy lifting of executing WinGet commands in the background.
* **High-Visibility Design:** Optimized for readability with large 14pt bold fonts and a spacious layout to reduce eye strain during maintenance sessions.

---

## How to Run

### Quick Start
To run the script directly from a PowerShell terminal, navigate to the script directory and execute:

```
powershell    
.\advanced-winget.ps1

Execution Policy Bypass    
If your system restricts script execution, use the following command to run the Manager:

PowerShell
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File .\advanced-winget.ps1

Create a Windows Shortcut

To launch the Manager with a double-click from your desktop, create a new Windows shortcut and paste the following into the Target field (ensure you update the path to match your actual folder location):
Plaintext

C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "C:\Path\To\Your\Script\advanced-winget.ps1"



Run:    
.\advanced-winget.ps

C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File .\advanced-winget.ps1

Create a Window's shortcut with this as the target # Add the foler location to .\advanced-winget.ps1    
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "C:\code\winget\advanced-winget.ps1"

