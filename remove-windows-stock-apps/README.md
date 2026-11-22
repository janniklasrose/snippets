# Remove Windows10 stock apps

Execute this script in PowerShell, but make sure to review the list of apps and comment out those you want to keep.

This is not an exhaustive list of Windows10 stock apps, and not all might be installed by default.

## A note on permissions

Depending on the execution policy of your system, you might not be able to execute this script. To confirm, open PowerShell and run `Get-ExecutionPolicy` (or `Get-ExecutionPolicy -List` for more information). To change the policy, open PowerShell **as Administrator** and execute `Set-ExecutionPolicy Unrestricted` in PowerShell. You can add `-Scope CurrentUser` to only change the policy for this user and not the entire machine. **Remember to change it back** to the old policy afterwards.
