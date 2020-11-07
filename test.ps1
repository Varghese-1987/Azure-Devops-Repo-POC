 try{
           Write-Host 'fun'
     }
     catch{
       Write-Error 'Error'
       Exit 1
     }
     Finally{
       Write-Host "exited.."
     }
    
