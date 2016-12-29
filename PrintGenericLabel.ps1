
$Username = [Environment]::UserName
$printer = "Friendly Name of Printer"
$ip = "192.168.x.x"
$Date = Get-Date

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

#############  First Form (for $labelData)

$objForm1 = New-Object System.Windows.Forms.Form 
$objForm1.Text = "Label Name"
$objForm1.Size = New-Object System.Drawing.Size(300,200) 
$objForm1.StartPosition = "CenterScreen"

$objForm1.KeyPreview = $True
$objForm1.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$Script:labelData=$objTextBox1.Text;$objForm1.Close()}})
$objForm1.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$objForm1.Close()}})

$OKButton1 = New-Object System.Windows.Forms.Button
$OKButton1.Location = New-Object System.Drawing.Size(75,120)
$OKButton1.Size = New-Object System.Drawing.Size(75,23)
$OKButton1.Text = "Next"
$OKButton1.Add_Click({$labelData=$objTextBox1.Text;$objForm1.Close()})
$objForm1.Controls.Add($OKButton1)

$CancelButton1 = New-Object System.Windows.Forms.Button
$CancelButton1.Location = New-Object System.Drawing.Size(150,120)
$CancelButton1.Size = New-Object System.Drawing.Size(75,23)
$CancelButton1.Text = "Cancel"
$CancelButton1.Add_Click({$objForm1.Close()})
$objForm1.Controls.Add($CancelButton1)

$objLabel1 = New-Object System.Windows.Forms.Label
$objLabel1.Location = New-Object System.Drawing.Size(10,20) 
$objLabel1.Size = New-Object System.Drawing.Size(280,20) 
$objLabel1.Text = "Type what the label should say below:"
$objForm1.Controls.Add($objLabel1) 

$objTextBox1 = New-Object System.Windows.Forms.TextBox 
$objTextBox1.Location = New-Object System.Drawing.Size(10,40) 
$objTextBox1.Size = New-Object System.Drawing.Size(260,20) 
$objForm1.Controls.Add($objTextBox1) 

$objForm1.Topmost = $True

$objForm1.Add_Shown({$objForm1.Activate(); $objTextBox1.focus()})
[void] $objForm1.ShowDialog()

#############  Second Form (for $labelQty)

$objForm2 = New-Object System.Windows.Forms.Form 
$objForm2.Text = "Quantity of labels"
$objForm2.Size = New-Object System.Drawing.Size(300,200) 
$objForm2.StartPosition = "CenterScreen"

$objForm2.KeyPreview = $True
$objForm2.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$Script:labelQty=[int]$objTextBox2.Text;$objForm2.Close()}})
$objForm2.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$objForm2.Close()}})

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "Print"
$OKButton.Add_Click({$labelQty=$objTextBox2.Text;$objForm2.Close()})
$objForm2.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.Add_Click({$objForm2.Close()})
$objForm2.Controls.Add($CancelButton)

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,20) 
$objLabel.Size = New-Object System.Drawing.Size(280,20) 
$objLabel.Text = "Type the quantity of labels you want."
$objForm2.Controls.Add($objLabel) 

$objTextBox2 = New-Object System.Windows.Forms.TextBox 
$objTextBox2.Location = New-Object System.Drawing.Size(10,40) 
$objTextBox2.Size = New-Object System.Drawing.Size(260,20) 
$objTextBox2.Text = "1"
$objForm2.Controls.Add($objTextBox2) 

$objForm2.Topmost = $True

$objForm2.Add_Shown({$objForm2.Activate(); $objTextBox2.focus()})
[void] $objForm2.ShowDialog()


$Content = "^XA^CF,0,0,0^PR12^MD10^PW800^PON
^FO270,300^FB750,2,0,C,0^A0,30,20^FD$Username^FS
^FO20,10^FB750,1,0,C,0^A0,90,50^FD$labelData^FS
^FO40,170^BY2,2.0,2.0^BC,125,N,N^FD$labelData^FS
^FO20,100^FB750,2,0,C,0^A0,30,20^FD^FS^XZ"

Function PrintLabel (){

$Socket = New-Object System.Net.Sockets.TCPClient("$ip",9100)

$Stream = $Socket.GetStream()

$Writer = New-Object System.IO.StreamWriter($Stream)

$Writer.Write($Content)

$Writer.Flush()

$Writer.Close()

$Socket.Close()

}

$printed = 0

do {
	PrintLabel
	$printed++
}
until(
	$printed -eq $labelQty
)

# Record what user printed what labels
add-content "$Username,$printer,$labelData,$labelQty,$Date" -path \\Path\to\log\PrintedLabels.csv











