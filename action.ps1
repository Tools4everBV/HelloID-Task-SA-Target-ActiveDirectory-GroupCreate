# HelloID-Task-SA-Target-ActiveDirectory-GroupCreate
####################################################
# Form mapping
$formObject = @{
    DisplayName    = $form.Name
    Name           = $form.Name
    SamAccountName = $form.Name
    Description    = $form.Description
    GroupCategory  = $form.GroupCategory
    GroupScope     = $form.GroupScope
    Path           = $form.OrganizationalUnit
    Manager        = $form.ManagerUserPrincipalName
    email          = $form.email
}

try {
    Write-Information "Executing ActiveDirectory action: [GroupCreate] for: [$($formObject.DisplayName)]"
    Import-Module ActiveDirectory -ErrorAction Stop
    $group = Get-ADgroup -Filter "Name -eq '$($formObject.Name)'"
    if ($group) {
        Write-Error "An ActiveDirectory group for: [$($formObject.DisplayName)] does already exist"
    } else {
        if (-not [string]::IsNullOrEmpty($formObject.Manager)) {
            Write-Information "Adding Manager [$($formObject.Manager)] as managedBy to the group"
            $managerObject = Get-ADuser -Filter "UserPrincipalName -eq '$($formObject.Manager)'"
            $formObject.Add( 'managedBy', $managerObject )
            $formObject.Remove('Manager')
        }

        if (-not [string]::IsNullOrEmpty($formObject.email)) {
            Write-Information "Adding email [$($formObject.email))] to the group"
            $formObject.Add( 'OtherAttributes', @{mail = "$($formObject.email)" } )
            $formObject.Remove('email')
        }

        $group = New-ADGroup @formObject -PassThru
        $auditLog = @{
            Action            = 'CreateResource'
            System            = 'ActiveDirectory'
            TargetIdentifier  = $([string]$group.SID)
            TargetDisplayName = $formObject.DisplayName
            Message           = "ActiveDirectory action: [GroupCreate] for: [$($formObject.DisplayName)] executed successfully"
            IsError           = $false
        }
        Write-Information -Tags 'Audit' -MessageData $auditLog
        Write-Information "ActiveDirectory action: [GroupCreate] for: [$($formObject.DisplayName)] executed successfully"
    }
} catch {
    $ex = $_
    $auditLog = @{
        Action            = 'CreateResource'
        System            = 'ActiveDirectory'
        TargetIdentifier  = $([string]$group.SID)
        TargetDisplayName = $formObject.DisplayName
        Message           = "Could not execute ActiveDirectory action: [GroupCreate] for: [$($formObject.DisplayName)], error: $($ex.Exception.Message)"
        IsError           = $true
    }
    Write-Information -Tags 'Audit' -MessageData $auditLog
    Write-Error "Could not execute ActiveDirectory action: [GroupCreate] for: [$($formObject.DisplayName)], error: $($ex.Exception.Message)"
}
####################################################
