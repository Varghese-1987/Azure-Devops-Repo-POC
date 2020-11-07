 try{
    fun
     }
     catch{
       Write-Error 'Error'
       Exit 1
     }
     Finally{
       Write-Host "exited.."
     }
     
     function fun{
       Write-Host 'fun'
     }
