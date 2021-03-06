New-ADOrganizationalUnit -Name Notendur -ProtectedFromAccidentalDeletion $false


New-ADGroup Allir -Path "ou=notendur,dc=bold,dc=local" -GroupScope Global


$notendur = Import-Csv C:\Users\Administrator\Documents\Bold_notendur_u.csv -Delimiter ","


foreach($notandi in $notendur) {


    $deild = $notandi.deild


    if (-not(Get-ADOrganizationalUnit -Filter {name -like $deild})) {


        New-ADOrganizationalUnit -Name $notandi.deild -Path "ou=notendur,dc=bold,dc=local" -ProtectedFromAccidentalDeletion $false

    }

    if(-not(Get-ADGroup -Filter {name -like $deild})) {

        New-ADGroup -Name $notandi.deild -Path $("ou=" + $notandi.deild + ",ou=notendur,dc=bold,dc=local") -GroupScope Global

        Add-ADGroupMember -Identity Allir -Members $notandi.deild

    }
    New-ADUser -GivenName $notandi.fornafn -Surname $notandi.eftirnafn -Name $notandi.nafn -Department $notandi.deild -DisplayName $notandi.nafn -SamAccountName $notandi.notendanafn -UserPrincipalName $($notandi.notendanafn + '@bold.local') -AccountPassword (ConvertTo-SecureString -AsPlainText "pass.123" -Force) -Path $("ou=" + $notandi.deild + ",ou=notendur,dc=bold,dc=local") -Enabled $true
    Add-ADGroupMember -Identity $notandi.deild -Members $notandi.notendanafn
}
