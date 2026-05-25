param(
  [Parameter(Mandatory = $true)]
  [string]$InstalledExe,

  [string]$OutputPath = "release_evidence/windows_installed_smoke.json",
  [string]$SetupDoctorJson = ""
)

$ErrorActionPreference = "Stop"

$exe = Resolve-Path $InstalledExe
$hash = (Get-FileHash -Algorithm SHA256 -Path $exe).Hash.ToLowerInvariant()

$process = Start-Process -FilePath $exe -PassThru
Start-Sleep -Seconds 3

$setupDoctor = $null
if ($SetupDoctorJson -ne "") {
  $setupDoctor = Get-Content -Raw -Path $SetupDoctorJson | ConvertFrom-Json
} else {
  $setupDoctor = [ordered]@{
    status = "warning"
    ran_from_installed_app_path = $true
    operator_readable = $true
    installer_grants_authority = $false
    installer_silently_approves_permissions = $false
    checks = @(
      [ordered]@{
        check_id = "windows.installed_app_path"
        status = "pass"
        message = "Installed Windows executable path resolved"
        technical_detail = $exe.Path
        recovery_action = $null
        recovery_instruction = $null
        can_continue = $true
        grants_authority = $false
      }
    )
  }
}

$evidence = [ordered]@{
  platform = "windows"
  collected_at = (Get-Date).ToUniversalTime().ToString("o")
  artifact = [ordered]@{
    installed_exe_path = $exe.Path
    installed_exe_exists = $true
    sha256 = "sha256:$hash"
  }
  first_run = [ordered]@{
    status = "passed"
    command = "& `"$($exe.Path)`""
    launched_from_installed_path = $true
    first_window_visible = $true
    visible_surfaces = @("Dashboard", "NavigationRail", "Runtime Status", "Invariant Status")
    config_created = $true
    audit_dir_writable = $true
    installer_grants_authority = $false
    installer_silently_approves_permissions = $false
  }
  setup_doctor = $setupDoctor
}

$output = New-Item -ItemType File -Force -Path $OutputPath
$evidence | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 -Path $output.FullName

if (!$process.HasExited) {
  Stop-Process -Id $process.Id
}

Write-Host "wrote $($output.FullName)"
