param(
    [string]$OutputPath = "./evidence_$env:COMPUTERNAME",
    [switch]$FullCollect
)

if (!(Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
}

function Get-NetworkEvidence {
    $netDir = Join-Path $OutputPath "network"
    New-Item -ItemType Directory -Path $netDir -Force | Out-Null

    netstat -ano | Out-File (Join-Path $netDir "netstat.txt")
    Get-NetTCPConnection | Export-Csv (Join-Path $netDir "tcp_connections.csv") -NoTypeInformation
    Get-NetUDPEndpoint | Export-Csv (Join-Path $netDir "udp_endpoints.csv") -NoTypeInformation
    arp -a | Out-File (Join-Path $netDir "arp_table.txt")
    ipconfig /displaydns | Out-File (Join-Path $netDir "dns_cache.txt")
    Get-DnsClientCache | Export-Csv (Join-Path $netDir "dns_cache.csv") -NoTypeInformation
}

function Get-ProcessEvidence {
    $procDir = Join-Path $OutputPath "processes"
    New-Item -ItemType Directory -Path $procDir -Force | Out-Null

    Get-Process | Select-Object Name, Id, CPU, StartTime, Path, Company |
        Export-Csv (Join-Path $procDir "processes.csv") -NoTypeInformation
    Get-Service | Where-Object { $_.Status -eq "Running" } |
        Export-Csv (Join-Path $procDir "services_running.csv") -NoTypeInformation
    Get-WmiObject Win32_StartupCommand |
        Export-Csv (Join-Path $procDir "startup_programs.csv") -NoTypeInformation
    schtasks /query /fo csv /v | Out-File (Join-Path $procDir "scheduled_tasks.txt")
}

function Get-SystemEvidence {
    $sysDir = Join-Path $OutputPath "system"
    New-Item -ItemType Directory -Path $sysDir -Force | Out-Null

    Get-WmiObject Win32_ComputerSystem | Export-Csv (Join-Path $sysDir "system_info.csv") -NoTypeInformation
    Get-WmiObject Win32_LogicalDisk | Export-Csv (Join-Path $sysDir "disks.csv") -NoTypeInformation
    Get-WmiObject Win32_NetworkAdapterConfiguration |
        Export-Csv (Join-Path $sysDir "network_adapters.csv") -NoTypeInformation
    systeminfo | Out-File (Join-Path $sysDir "systeminfo.txt")

    Get-WmiObject Win32_UserAccount |
        Select-Object Name, Domain, SID, Disabled, Lockout, PasswordRequired |
        Export-Csv (Join-Path $sysDir "user_accounts.csv") -NoTypeInformation
    Get-LocalGroupMember -Group Administrators |
        Export-Csv (Join-Path $sysDir "admin_users.csv") -NoTypeInformation
}

function Get-PersistenceEvidence {
    $perDir = Join-Path $OutputPath "persistence"
    New-Item -ItemType Directory -Path $perDir -Force | Out-Null

    Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" |
        Out-File (Join-Path $perDir "run_keys.txt")
    Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" |
        Out-File (Join-Path $perDir "run_keys_user.txt")
    Get-WmiObject -Namespace root\subscription WMIEventConsumer |
        Out-File (Join-Path $perDir "wmi_consumers.txt")
    Get-WmiObject -Namespace root\subscription __EventFilter |
        Out-File (Join-Path $perDir "wmi_filters.txt")
}

function Get-LogEvidence {
    $logDir = Join-Path $OutputPath "logs"
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null

    $events = @(
        @{Log="Security"; Id=4624; Name="logon_success"},
        @{Log="Security"; Id=4625; Name="logon_failure"},
        @{Log="Security"; Id=4688; Name="process_creation"},
        @{Log="Security"; Id=4698; Name="scheduled_task_creation"},
        @{Log="System"; Id=7045; Name="service_install"},
        @{Log="Microsoft-Windows-Sysmon/Operational"; Id=1; Name="sysmon_process"},
        @{Log="Microsoft-Windows-Sysmon/Operational"; Id=3; Name="sysmon_network"},
        @{Log="Microsoft-Windows-PowerShell/Operational"; Id=4104; Name="scriptblock"}
    )

    foreach ($evt in $events) {
        try {
            Get-WinEvent -FilterHashtable @{
                LogName = $evt.Log
                Id = $evt.Id
                StartTime = (Get-Date).AddDays(-7)
            } -MaxEvents 1000 -ErrorAction SilentlyContinue |
                Export-Csv (Join-Path $logDir "$($evt.Name).csv") -NoTypeInformation
        } catch {}
    }
}

Write-Host "Collecting evidence to $OutputPath"
Get-NetworkEvidence
Get-ProcessEvidence
Get-SystemEvidence
Get-PersistenceEvidence

if ($FullCollect) {
    Get-LogEvidence
}

Write-Host "Evidence collection completed"
Write-Host "Output directory: $OutputPath"
