$vlans = @(1,2,10,12,13,14)

(14..15) | foreach {
    ##'when we find one that isn't in $num, store it in sparenumber and break out of this joint. 
    if (!$vlans.Contains($_)) {
        $spareNumber = $_ 
        break 
    }
 }
 ## and here is your number... 
 $spareNumber 
