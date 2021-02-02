# RecordingMute

Toggle the mute on all the microphones.

## DESCRIPTION

Whatever the state of the microphones they will be toggled so that they can be muted or unmuted.

Installing [AudioDeviceCmdlets](https://github.com/frgnca/AudioDeviceCmdlets) must be done by the user.

## PARAMETER Application

If an application name is provided then that application's mute status will also be toggled.

__Nb.__ This is **very** flaky ... Is it Teams or W10 automation?

## EXAMPLES

    PS> .\Set-RecordingMute.ps1

Toggle the state of all the microphones and the state in Teams.

    PS> .\Set-RecordingMute.ps1 'Teams'

## LINK

Code shamelessly pillaged from [Mewt](https://github.com/dakota-mewt/mewt). 