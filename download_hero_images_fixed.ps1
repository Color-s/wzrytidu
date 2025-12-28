# download_hero_images_fixed.ps1
# 只下载“写死”的这些头像 id；不做匹配、不做范围遍历
# 输出：.\img\<id>.jpg

$ErrorActionPreference = "Stop"

$BASE = "https://pvp.52api.cn/img"
$OUT  = "img"

# 写死的头像ID列表（文件名就是 <id>.jpg）
$IDS = @(
  577,550,171,194,509,585,186,191,156,534,108,113,149,176,523,
  525,189,505,184,159,187,152,544,175,501,118,148,540,168,114,105
)

New-Item -ItemType Directory -Path $OUT -Force | Out-Null

foreach ($id in $IDS) {
  $url  = "$BASE/$id.jpg"
  $dest = Join-Path $OUT "$id.jpg"

  if (Test-Path $dest) {
    $len = (Get-Item $dest).Length
    if ($len -gt 0) {
      Write-Host "Skip (exists): $dest"
      continue
    }
  }

  Write-Host "Downloading: $url -> $dest"

  # 用 curl.exe（Windows 自带）下载；不要用 PowerShell 的 curl 别名
  $p = Start-Process -FilePath "curl.exe" -NoNewWindow -Wait -PassThru -ArgumentList @(
    "-L", "--fail", "--retry", "3",
    "--connect-timeout", "10",
    "--max-time", "60",
    $url, "-o", $dest
  )

  if ($p.ExitCode -ne 0) {
    Write-Warning "FAILED id=$id (curl exit code $($p.ExitCode))"
  }
}

Write-Host "`nDone. Saved to .\$OUT\"
