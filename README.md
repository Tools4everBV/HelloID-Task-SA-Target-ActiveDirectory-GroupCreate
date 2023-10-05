
# HelloID-Task-SA-Target-ActiveDirectory-GroupCreate

## Prerequisites

- [ ] The HelloID SA on-premises agent installed

- [ ] The ActiveDirectory module is installed on the server where the HelloID SA on-premises agent is running.

## Description

This code snippet executes the following tasks:

1. Define a hash table `$formObject`. The keys of the hash table represent the properties of the `New-ADGroup` cmdlet, while the values represent the values entered in the form.

> To view an example of the form output, please refer to the JSON code pasted below.

>  The script provides examples of how certain fields, such as email and managedBy, need to be supplied differently to the New-ADGroup cmdlet. Although these fields are initially added in the form object, they are later modified in the script to match the properties of the New-ADGroup.


```json
{
    "Name": "TestGroup1",
    "Description": "TestGroup1",
    "GroupCategory": "Security",
    "GroupScope": "Global",
    "OrganizationalUnit": "OU=Groups,DC=Tools,DC=local",
    "ManagerUserPrincipalName" : "john.doe@tools.com",
    "email": "TestGroup@tools.com"
}
```

> :exclamation: It is important to note that the names of your form fields might differ. Ensure that the `$formObject` hashtable is appropriately adjusted to match your form fields.



2. Imports the ActiveDirectory module.

3. Verify if the group that must be created already exists based on the `name` using the `Get-ADgroup` cmdlet.

4. If the group does not exist, a new group is created using the `New-ADgroup` cmdlet. The hash table called `$formObject` is passed to the `New-ADgroup` cmdlet using the `@` symbol in front of the hash table name.  [See the Microsoft Docs page](https://learn.microsoft.com/en-us/powershell/module/activedirectory/new-adgroup?view=windowsserver2022-ps)

>

