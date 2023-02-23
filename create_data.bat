@echo off
color a
echo Gerando arquivos...
setlocal EnableDelayedExpansion

rem definindo as variaveis de caminho e arquivos a serem criados
set "dir=%CD%"
set "relatorio=%~dp0\relatorio.txt"
set "verificar_dados=%~dp0\verificar_dados.txt"
set "missing_data=%~dp0\missing_data.txt"

rem verifica se existe
if exist "%relatorio%" del "%relatorio%"
if exist "%verificar_dados%" del "%verificar_dados%"
if exist "%missing_data%" del "%missing_data%"

rem escrevendo o cabecalho dos arquivos
echo dia, mes, ano, hora, minuto, segundo, MB, caminho, nome >> "%relatorio%"
echo nome, qtdd_total,danif,arq_OK >> "%verificar_dados%"
echo data, hora, pasta >> "%missing_data%"

rem loop para pegar as informacoes de nome do arquivo, tamanho do arquivo, ano, mes e dia
for /r "%dir%" %%f in (*.avi) do (
  set "fullname=%%~nxf"
  set /A "filesize=%%~zf/1000000"
  set "number=!fullname:~-22!"
for /f "tokens=2 delims=_" %%a in ("!fullname!") do set "data_hora=%%a"
    set "ano=!data_hora:~0,4!"
    set "mes=!data_hora:~4,2!"
    set "dia=!data_hora:~6,2!"
    set "hora=!data_hora:~8,2!"
    set "minuto=!data_hora:~10,2!"
    set "segundo=!data_hora:~12,2!"

  rem coloca os dados no arquivo txt
  echo !dia!, !mes!, !ano!, !hora!, !minuto!, !segundo!, !filesize! MB, %%~dpf, !fullname! >> "%relatorio%"
 
  rem check for 0MB files and add data to missing_data file
  if !filesize! equ 0 (
    set "folder=%%~dpf"
    set "folder=!folder:%cd%\=!"
    echo !dia!/!mes!/!ano!, !hora!:!minuto!:!segundo!, !folder! >> "%missing_data%"
  )

)

rem define as variaveis de conrtagem e conta quantos arquivos tem em cada pasta
for /d /r "%dir%" %%d in (*) do (
  set "avi_count=0"
  set "danif=0"
  set "arq_OK=0"

  for /f %%a in ('dir /b "%%d\*.avi" 2^>nul ^| find /v /c ""') do set "avi_count=%%a"
  if !avi_count! gtr 0 (
    set "name=%%~nxd"
    for %%b in ("%%d\*.avi") do (
      if %%~zb equ 0 (
        set /a "arq_OK+=1"
      ) else (
        set /a "danif+=1"
      )
    )
    echo !name!, !avi_count!, !danif!, !arq_OK! >> "%verificar_dados%"
  )
)

echo Arquivo de saida gerado com sucesso!