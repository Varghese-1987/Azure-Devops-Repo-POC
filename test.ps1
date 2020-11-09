 try{
 Start-Transcript -path "Logs\demo.log" -append
           Write-Host 'fun'
     }
     catch{
       Write-Error 'Error'
       Exit 1
     }
     Finally{
       Write-Host "exited.."
       Stop-Transcript
     }
    
