param(  
  $folder = "Z:\Films",
  $outputFile = "D:\Git\details.txt" )

$objShell = New-Object -ComObject Shell.Application


$fileList = @()
$attrList = @{}
$details = ( "Frame height", "Frame width", "Frame rate" )


$objFolder = $objShell.namespace($folder)
for ($attr = 0 ; $attr  -le 500; $attr++)
{
    $attrName = $objFolder.getDetailsOf($objFolder.items, $attr)
    if ( $attrName -and ( -not $attrList.Contains($attrName) ))
    { 
        $attrList.add( $attrName, $attr ) 
    }
}



dir $folder -Recurse -Directory | ForEach-Object{

    $objFolder = $objShell.namespace($_.FullName)
    
    foreach($file in $objFolder.items())
    {
        foreach( $attr in $details)
        {
            $attrValue = $objFolder.getDetailsOf($file, $attrList[$attr])
            if ( $attrValue ) 
            { 
                Add-Member -InputObject $file -MemberType NoteProperty -Name $("A_" + $attr) -value $attrValue
            } 
        }
        $fileList += $file
        $fileList.Count
    }
   
}

$fileList | Export-Csv $outputFile -Delimiter ','
$fileList | Format-Table
