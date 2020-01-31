Function AllSite-Report{
if((Get-PSSnapin | Where {$_.Name -eq "Microsoft.SharePoint.PowerShell"}) -eq $null) {
 Add-PSSnapin Microsoft.SharePoint.PowerShell;
}
$ErrorActionPreference = 0
$date=Get-Date -Format dd/MM/yyyy
$sourceWebURL = Get-SPweb "SITEURLHERE"
$sourceListName = "Site Reports"
$list=$sourceWebURL.lists[$sourceListName]

$query = New-Object Microsoft.SharePoint.SPQuery
$query.ViewAttributes = "Scope='Recursive'"
$query.RowLimit = 1000
$query.ViewFields = "<FieldRef Name='ID'/>"
$query.ViewFieldsOnly = $true
do
{
   $listItems = $list.GetItems($query)
   $query.ListItemCollectionPosition = $listItems.ListItemCollectionPosition
   foreach($item in $listItems)
   {
     Write-Host "Deleting Item - $($item.Id)"
     $list.GetItemById($item.Id).delete()
   }
}




while ($query.ListItemCollectionPosition -ne $null)

$AllSites= Get-SPWebApplication -Identity WEBAPPURLHERE
    Foreach ($site in $allsites.sites){
    Foreach($web in $site.AllWebs){
    Clear-Variable 1, 2, Percent, percentofQU, Rounding, Userlist,user, users

    $newItem=$list.Items.add()
    $newItem2=$list.Items.add()
    $title=$WEB.Title
    $url=$WEB.url
    $createdate=$web.Created.ToShortDateString()
    $ContentDB=$site.ContentDatabase
    $ContentDB=$ContentDB -replace 'SPContentDataBase Name=',''
    $owner=$site.Owner.DisplayName
    $Size= [math]::Round(($site.Usage.Storage/1MB),2)

    $WT=get-spweb -Identity $web.Url
    $Template=$WT.WebTemplate+$WT.WebTemplateId
    $NewItem['Title']="$Title"
    $newItem['URL']=$URL
    $newItem['ContentDataBase']=$ContentDB
    $newItem['Owner']=$owner
    $newItem['Size of Site In MBs'] = $Size
    $newItem['Web template']=$Template
    $newItem['Date of Audit']=$date
    $newItem['Date Created']=$createdate
    $2=$site.StorageQuota
    $1=$site.StorageUsed

    if ($1 -eq "0"){$1=1}
    IF ($2 -eq "0"){$2=1}
    $percentofQU=($1/$2)*100
    
    $Rounding=[math]::Round(($percentofQU),3)
    $Percent=$Rounding
    If ($Percent -ge 100){$percent = 0}
    $newitem['Percentage of template Used']=$Percent
    $newItem['Quota Template Size (MBs)']=$2/1024/1024
$web=$site.OpenWeb()
$Users=$web.SiteGroups|?{$_.name -like "*owner*"}
$100=$users.Users.displayname
        Foreach($User in $100)
        {
        $Userlist+="$user; "}
        $newItem['Owners']=$userlist
        $newItem.update()


   }}



$sourceWebURL.Dispose()
}
