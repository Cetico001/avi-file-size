@echo off
setlocal enabledelayedexpansion

set /a fcont=0

rem verificar se existe o relatorio nas pastas e se existir os apaga
set "root=%~dp0"

for /r "%root%" %%d in (.) do (
  if exist "%%d\relatorio_subd.txt" (
    del "%%d\relatorio_subd.txt"
    echo Deleted "%%d\relatorio_subd.txt"
  )
)

rem criar arquivos em todos as pastas que contem arquivos quebrados
for /r %%i in (*.avi) do (
  if %%~zi equ 0 (
    echo Corrupted file: "%%i" >> "%%~dpi\relatorio_subd.txt"
  )
)

for /d /r %%i in (*) do (
  set "file=%%i\relatorio_subd.txt"
  if exist "!file!" (
    for /f %%j in ('type "!file!" ^| find /v /c ""') do set count=%%j
    (echo Number of corrupted AVI files: !count!) >> "!file!"
    set count=0
  )
)

rem verificar se está faltando arquivo