$groups = Get-Content test.txt
$excel = New-Object -ComObject excel.application
$excel.Visible = $True
$Workbook = $Excel.Workbooks.Add()
ForEach ($group in $groups)
{
    $Excel.Worksheets.Add()
    $Excel.Worksheets.Item(1).Name = "$group"
    Get-ADGroupMember -Recursive -Identity $Group | Select-Object -ExpandProperty samaccountname
}
$workbook.Save()
$workbook.Close()
$excel.Quit()
