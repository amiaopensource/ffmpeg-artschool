$scripts = Get-ChildItem .

ForEach ($script in $scripts) {
   & "$PSScriptRoot\$($script.Name) -s ..\sample_video_files\Cat01.mp3"
    
}