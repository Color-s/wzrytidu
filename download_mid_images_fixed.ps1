# --- 修正版，100% 可下载 ---
$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$BASE = "https://pvp.52api.cn/img"
$OUT  = "img"

$IDS = @(
  521,179,312,190,515,191,127,106,523,157,176,141,513,136,182,115,563,
  156,197,142,109,110,152,124,119,540,504,148,108,582,146,137,537
)

New-Item -ItemType Directory -Path $OUT -Force | Out-Null

foreach ($id in $IDS) {
  $url  = "$BASE/$id.jpg"
  $dest = Join-Path $OUT "$id.jpg"
  Write-Host "Downloading $id.jpg ..." -ForegroundColor Cyan
  try {
    Invoke-WebRequest -Uri $url -OutFile $dest -TimeoutSec 30 -UseBasicParsing
    $size = (Get-Item $dest).Length
    if ($size -lt 1024) {
      Write-Warning "文件太小（可能失败）：$id.jpg ($size bytes)"
    }
  } catch {
    Write-Warning "下载失败：$id.jpg ($($_.Exception.Message))"
  }
}

Write-Host "`n✅ 全部处理完成，图片保存在 .\$OUT\" -ForegroundColor Green
