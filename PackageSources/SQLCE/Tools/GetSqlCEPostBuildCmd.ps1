# TODO: get the right project!
$proj = $dte.Solution.Projects.Item(1)

$solutionDir = [System.IO.Path]::GetDirectoryName($dte.Solution.FullName) + "\"
$path = $ToolsDir.Replace($solutionDir, "`$(SolutionDir)")

$NativeAssembliesDir = Join-Path $path  "..\NativeBinaries"
$x86 = $(Join-Path $NativeAssembliesDir "x86\*.dll")
$x64 = $(Join-Path $NativeAssembliesDir "amd64\*.dll")

$SqlCEPostBuildCmd = "if not exist `"`$(TargetDir)x86`" md `"`$(TargetDir)x86`"
copy `"$x86`" `"`$(TargetDir)x86`"
if not exist `"`$(TargetDir)amd64`" md `"`$(TargetDir)amd64`"
copy `"$x64`" `"`$(TargetDir)amd64"