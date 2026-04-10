# WinGet-Pro-Sync-Manager

This script is a custom-built GUI (Graphical User Interface) wrapper for the Windows Package Manager (WinGet), designed to turn a complex command-line tool into a user-friendly, visual dashboard. Its primary purpose is to help you synchronize and manage software across your system by scanning for installed applications and presenting them in a high-visibility, interactive list. By utilizing the Windows Forms library, the script creates a structured environment where you can audit your software library, import configurations from JSON files, and batch-process installations or uninstalls without typing a single line of code in the terminal.
Key Features

    Visual Status Tracking: The script uses a "traffic light" logic for the status column, displaying a 
    massive "YES" in green for installed apps and a red "no" for missing ones, making it easy to see your 
    system state at a glance.

    Smart Sorting & Filtering: It features a "Hard Sort" logic that automatically pushes ignored items 
    to the bottom while keeping active tasks at the top, 
    ensuring you always focus on the packages that need attention.

    Automated Backup & Import: Every time you run an initial sync, the script automatically exports 
    a timestamped JSON backup of your current setup. It also allows you to import existing JSON 
    configurations to quickly set up a new machine.

    Bulk Action Controls: With "All Keep" and "All Ignore" buttons, you can manage hundreds of 
    packages instantly, and the "UPDATE & Make Changes" button handles the heavy lifting of running 
    the actual WinGet commands in the background.

    High-Visibility Design: Specifically tailored with large 14pt bold fonts and a spacious layout, 
    the interface is optimized for readability, reducing eye strain during long maintenance sessions.


Run:    
.\advanced-winget.ps

C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File .\advanced-winget.ps1

Create a Window's shortcut with this as the target # Add the foler location to .\advanced-winget.ps1    
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File "C:\code\winget\advanced-winget.ps1"
