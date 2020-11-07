 try{
       throw 'demo exception'
     }
     catch{
       Write-Error 'Error'
       Exit 1
     }
     Finally{
       Write-Host "exited.."
     }
