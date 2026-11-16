param(
  [string]$Fixture = "tests/fixtures/e201.fixture.json",
  [string]$Schema = "schemas/compile_gate_summary.schema.json"
)
$ErrorActionPreference = 'Stop'
if (-not (Test-Path $Fixture)) { throw "Fixture missing: $Fixture" }
if (-not (Test-Path $Schema)) { throw "Schema missing: $Schema" }
$r = Get-Content $Fixture -Raw | ConvertFrom-Json
if ($r.schema_version -ne '1.0') { throw 'schema_version mismatch' }
if ($r.result -ne 'FAIL' -or $r.code -ne 'E201') { throw 'E201 fixture identity mismatch' }
$a = $r.annotation
if ($a.level -ne 'error') { throw 'E201 level mismatch' }
if ($a.file -ne 'rtl/pvpu_reset_sync.sv') { throw 'E201 file mismatch' }
if ([int]$a.start_line -lt 1 -or [int]$a.end_line -lt [int]$a.start_line) { throw 'E201 line range invalid' }
if ([int]$a.start_column -lt 1 -or [int]$a.end_column -lt [int]$a.start_column) { throw 'E201 column range invalid' }
if ($a.rule -ne 'G2-DEV-001') { throw 'E201 rule mismatch' }
Write-Host "::notice file=$($a.file),line=$($a.start_line),endLine=$($a.end_line),col=$($a.start_column),endColumn=$($a.end_column),title=E201 fixture test::Contract PASS"
