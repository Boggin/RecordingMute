<#
.SYNOPSIS
  Toggle the mute on all the microphones.

.DESCRIPTION
  Whatever the state of the microphones they will be toggled so that 
  they can be muted or unmuted.

  Installing AudioDeviceCmdlets must be done by the user.

.PARAMETER Application
  If an application name is provided then that application's mute status 
  will also be toggled.

.INPUTS
  None.

.OUTPUTS
  None.

.NOTES
  Version:        1.0
  Author:         Richard Bogle
  Creation Date:  2020-02-01
  Purpose/Change: Initial script development

.EXAMPLE
  PS> .\Set-RecordingMute.ps1

.EXAMPLE
  Toggle the state of all the microphones and the state in Teams.
  PS> .\Set-RecordingMute.ps1 'Teams'

.LINK
  https://github.com/dakota-mewt/mewt

.LINK
  https://github.com/frgnca/AudioDeviceCmdlets

.LINK
  https://github.com/Windos/BurntToast

.LINK
  https://openmoji.org/library/#emoji=1F92B
#>

[CmdletBinding()]

PARAM (
  [string]$application
)

Function Set-RecordingMute {
  Begin {
    Import-Module AudioDeviceCmdlets # https://github.com/frgnca/AudioDeviceCmdlets
    Import-Module BurntToast         # https://github.com/Windos/BurntToast
  }

  Process {
    $recording_devices = Get-AudioDevice -list | Where-Object { $_.Type -eq "Recording" }
    $recording_device_index = $recording_devices.Index | Out-String -stream
    $default_recording_device = $recording_devices | Where-Object { $_.Default -eq $True }

    foreach ($i in $recording_device_index) {
      Set-AudioDevice -Index ([int]$i) | Out-Null
      Set-AudioDevice -RecordingMuteToggle
    }

    Set-AudioDevice -Index $default_recording_device.Index | Out-Null

    Show-Notification
    Set-ForegroundApplication $application
  }
}

Function Show-Notification {
  $icon = Join-Path $PSScriptRoot "shushing_face.png"
  $isMuted = Get-AudioDevice -RecordingMute
  if ($isMuted) {
    New-BurntToastNotification -Text "Muted" -AppLogo $icon -Silent
  }
  else {
    New-BurntToastNotification -Text "Unmuted" -AppLogo $icon -Silent
  }
}

Function Set-ForegroundApplication {
  PARAM (
    [string]$application
  )

  Begin {
    Import-Module Pscx
    Add-Type -AssemblyName System.Windows.Forms
  }

  Process {
    if ($application -eq "Teams") {
      $handles = Get-Process Teams | Where-Object { $_.MainWindowHandle -ne 0 }
      foreach ($handle in $handles) {
        Set-ForegroundWindow $handle.MainWindowHandle
      }
      [System.Windows.Forms.SendKeys]::SendWait("^+{m}")
    }
  }
}