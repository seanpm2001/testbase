# Copyright (c) Microsoft. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

push-location $PSScriptRoot
$exit_code = 0
$script_name = $myinvocation.mycommand.name
# You can use the following variables to construct file path
# Root folder
$root_dir = "$PSScriptRoot\..\.."
# Bin folder
$bin_dir = "$root_dir\bin"
# Log folder
$log_dir = "$root_dir\logs"

$log_file = "$log_dir\$script_name.log"


if (-not (test-path -path $log_dir )) {
    new-item -itemtype directory -path $log_dir
}

Function log {
    Param ([string]$log_string)
    write-host $log_string
    add-content $log_file -value $log_string
}

# Step 1: Uninstall the application
log("Uninstalling Application")
$arguments = "Get-AppxPackage *ToDo* | Remove-AppxPackage"
$uninstaller = Start-Process powershell.exe $arguments -wait -passthru -NoNewWindow

# Step 2: Check if uninstallation is succeeded
# Examples of common commands
#    - Check uninstall process exit code: $installer.exitcode -eq 0
#    - Check registy: Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion
#    - Check installed software list: Get-WmiObject -Class Win32_Product | where name -eq "Node.js"
if ($uninstaller.exitcode -eq 0) {
    log("Uninstallation succesful as $($uninstaller.exitcode)")
}
else {
    log("Error: Uninstallation failed as $($uninstaller.exitcode)")
    $exit_code = $uninstaller.exitcode
}

log("Unistallation script finished as $exit_code")
pop-location
exit $exit_code