#################################################
#           UserControl script
#             by: Sam Dinkelman
#               3/1/2019
#
#This script takes in the current user name
#
#
#

Function Create{
  $answer2 = read-host -prompt "Would you like to create multiple users? [Yes/No]"
  if (($answer2 -match "Yes") -or ($answer2 -match "Y")){
    CreateMultiple
  }
  $username = read-host -prompt "What will we name this new user?"
  $password = read-host -prompt "What will their password be?" -AsSecureString
  $fullname = read-host -prompt "What is their name?"
  $description = read-host -prompt "Give a brief description of this account"
  New-LocalUser "$username" -Password $password -Fullname "$fullname" -Description "$description"
}

Function CreateMultiple{
    $howmany = readhost -prompt "How many users would you like to add?"
    for($i = 0; $i -lt $howmany; $i++){
        Create
  }
}

Function Delete{
  $answer3 = read-host -prompt "Would you like to delete multiple users? [Yes/No]"
  if (($answer3 -match "Yes") -or ($answer3 -match "Y")){
     DeleteMultiple
  }
  $rmusername = read-host -prompt "What is the username you would like to delete?"
  write-host "`nFirst lets see what will happen if we remove this user"
  Remove-LocalUser -Name "$rmusername" -whatif
  $answer = read-host -prompt "`nWould you still like to continue? [Yes/No]"

  if (($answer -match "Yes") -or ($answer -match "Y")){
    Remove-LocalUser -Name $rmusername
    write-host "`nUser successfully deleted, Here are all users:"
    Get-LocalUser
  }
}

Function DeleteMultiple{
    $howmany2 = read-host -prompt "How many users would you like to delete?"
    for($i = 0; $i -lt $howmany2; $i++){
        Delete
    }
}

Function AddAdmin{
  $adminusername = read-host "What is the username that will be an admin?"
  Add-LocalGroupMember -Group "Administrators" -Member "$adminusername"
  write-host "Here are the users that are admins:"
  Get-LocalGroupMember "Administrators"
}

Function RemoveAdmin{
  $rmadminusername = read-host "What is the username to revoke admin rights from?"
  Remove-LocalGroupMember -Group "Administrators" -Member "$rmadminusername"
  write-host "`nHere are the users that are admins:"
  Get-LocalGroupMember "Administrators"
}

Function UserstoGroup{
  $numberofusers = read-host -prompt "How many users do you want to add?"
  $grouptoadd = read-host -prompt "Which group would you like to add them to?"
  for ($i = 0; $i -lt $numberofusers; $i++){
    $userstoadd = read-host -prompt "Which users would you like to add?"
    Add-LocalGroupMember -Group "$grouptoadd" -Member "$userstoadd"
    Get-LocalGroupMember "$grouptoadd" 
  }
  
}

#this prints the help statement if -help is found on command line
Function help {
  write-host "`nOptions:"
  write-host "`n-create        Creates a new user after filling out some basic info about them"
  write-host "`n-delete        Deletes a user after checking with current user"
  write-host "`n-admin         Makes a user an administrator with all privileges"
  write-host "`n-rmadmin       Revokes a users admin rights"
  write-host "`n-userstogroup  Adds a bunch of users to a group"
}

write-host "`nUse this script to create, delete, and modify user privileges"
write-host "`nCurrent user is: $env:Username"

switch($args[0]){
    -help { help }
    -create { Create }
    -delete { Delete }
    -admin { AddAdmin }
    -rmadmin { RemoveAdmin }
    -userstogroup { UserstoGroups }
}

if($args.count -lt 1){
  write-host "`nUsage: ./UserControl.ps1 for further options use -help"
