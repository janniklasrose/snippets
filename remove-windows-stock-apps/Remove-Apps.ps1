<# Remove-Apps.ps1
 #
 # Remove Windows10 stock apps
 #
 # Copyright (c) 2019 Jan N Rose
 #>

### List of patterns for apps to be removed
$patterns = @(
    ### ZUNE
    "Microsoft.ZuneMusic" # "Groove Music"
    "Microsoft.ZuneVideo" # "Films & TV"
    ### BING
    "Microsoft.BingFinance" # "Finance"
    "Microsoft.BingNews" # "News"
    "Microsoft.BingSports" # "Sports"
    "Microsoft.BingWeather" # "Weather"
    ### OFFICE
    "Microsoft.MicrosoftOfficeHub" # "Office"
    "Microsoft.Office.OneNote" # "OneNote"
    "Microsoft.Office.Sway" # "Sway"
    ### COMMUNICATION
    "microsoft.windowscommunicationsapps" # "Calendar" & "Mail"
    "Microsoft.Messaging" # "Messaging"
    "Microsoft.People" # "People"
    "Microsoft.SkypeApp" # "Skype"
    ### HELP
    "Microsoft.WindowsFeedbackHub" # "Feedback Hub"
    "Microsoft.GetHelp" # "Get Help"
    "Microsoft.Getstarted" # "Tips"
    ### MEDIA
    "Microsoft.Windows.Photos" # "Photos"
    "Microsoft.WindowsCamera" # "Camera"
    "Microsoft.MSPaint" # "Paint 3D"
    ### 3D
    "Microsoft.Print3D" # "Print 3D"
    "Microsoft.Microsoft3DViewer" # "3D Viewer"
    "Microsoft.MixedReality.Portal" # "Mixed Reality Portal"
    ### PHONE
    "Microsoft.OneConnect" # "Mobile Plans"
    "Microsoft.YourPhone" # "Your Phone"
    ### XBOX
    "Microsoft.XboxApp" # "Xbox"
    "Microsoft.XboxGameOverlay" # "Xbox Game Bar"
    "Microsoft.XboxGamingOverlay" # "Xbox Game Bar"
    "Microsoft.XboxSpeechToTextOverlay" # "Xbox Game Speech Window"
    "Microsoft.XboxIdentityProvider" # "Xbox Identity Provider"
    "Microsoft.XboxOneSmartGlass" # "Xbox One SmartGlass"
    ### SYSTEM
    "Microsoft.WindowsAlarms" # "Alarms & Clock"
    "Microsoft.WindowsCalculator" # "Calculator"
    "Microsoft.ScreenSketch" # "Snip & Sketch"
    "Microsoft.MicrosoftStickyNotes" # "Sticky Notes"
    "Microsoft.WindowsSoundRecorder" # "Voice Recorder"
    ### OTHER
    "Microsoft.Wallet" # "Microsoft Pay"
    "Microsoft.WindowsMaps" # "Maps"
    "Microsoft.MicrosoftSolitaireCollection" # "Microsoft Solitaire Collection"
)

### Loop through list of patterns to remove apps
ForEach ( $pattern in $patterns ) {
    Write-Host "Finding apps with pattern ""$pattern"""
    ### Get apps
	$apps = Get-AppxPackage $pattern
    ### Loop over apps
    ForEach ( $app in $apps ) {
        $name = $app.Name
		Write-Host "    Found app ""$name"""
        ### Ensure we skip the Microsoft Store!
	    if ( $name -eq "Microsoft.WindowsStore" ) {
            Write-Host "    We are skipping the app ""$name"""
	    } else {
            Write-Host "    We are removing the app ""$name"""
            Remove-AppxPackage -ErrorAction Continue $app
        }
    }
}
