@echo off
echo Gerando arquivos...
setlocal EnableDelayedExpansion

rem definindo as variaveis de caminho e arquivos a serem criados
set "dir=%CD%"
set "relatorio=%~dp0\relatorio.txt"
set "verificar_dados=%~dp0\verificar_dados.txt"
set /a cont=0
set /a novosminutos=0
set /a ante=0
set /a novashoras1=0
set /a novashoras=0
set /a novosdias=0
set /a novosdias1=0
set /a auth=0
set /a fcont=0
set /a xcont=0

rem verifica se existe
if exist "%relatorio%" del "%relatorio%"
if exist "%verificar_dados%" del "%verificar_dados%"
  
rem cria cabecalho do arquivo relatorio
echo Verificar,Data, Hora, Tamanho, Diretorio, Nome >> "%verificar_dados%"
  
rem Loop for, que interage sobre todos os arquivos com a extensão ".avi" no diretório %dir% e em todos os seus subdiretórios (/s), em ordem crescente (/od) rem o comando dir é usado para listar o conteúdo do diretório e o modificador /b é utilizado para listar apenas o nome do arquivo
  
for /f "delims=" %%f in ('dir /s /b /od "%dir%\*.avi"') do (
  set "fullname=%%~nxf"
  set "filesize=%%~zf"
  set "Verificar=Ok"
  if !filesize! equ 0 (
    set "Verificar=Erro"
    echo Corrompido: %%~dpf!fullname! >> "%relatorio%"
    set /a "xcont=xcont+1"
  )
  
  if !cont! geq 1 (
   set /a "novosminutos=!minuto!+11"
   set /a "novashoras=!hora!"
   if !novosminutos! geq 60 (
     set /a "novosminutos=!novosminutos!-60"
     set /a "novashoras=!hora!+1"
     if !novashoras! geq 24 (
       set /a "novosdias=!dia!+1"
     )
   )
   set /a "ante=!minuto!+8"
   set /a "novashoras1=!hora!"
   if !ante! geq 60 (
     set /a "ante=!ante!-60"
     set /a "novashoras1=!hora!+1"
     if !novashoras1! geq 24 (
       set /a "novosdias1=!dia!+1"
     )
   )
  )
  
  rem echo !novashoras1!:!ante!, !novashoras!:!novosminutos! >> "%relatorio%"
   
  set /a "horapos=!hora!+1"
  set /a "horant=!hora!"
  
  for /f "tokens=2 delims=_" %%a in ("!fullname!") do set "data_hora=%%a"
    set "ano=!data_hora:~0,4!"
    set "mes=!data_hora:~4,2!"
    set "dia=!data_hora:~6,2!"
    set "hora=!data_hora:~8,2!"
    set "minuto=!data_hora:~10,2!"
    set "segundo=!data_hora:~12,2!"
  
  set "dd=!dia!"
  set "hh=!hora!"
  set "mm=!minuto!"
  
  rem conversão
  if !minuto! lss 10 (
    set /a "minuto=1!minuto!-100"
  ) 
  if !hora! lss 10 (
    set /a "hora=1!hora!-100"
  ) 
  if !dia! lss 10 (
    set /a "dia=1!dia!-100"
  ) 
  if !filesize! lss 1073741824 (
    set "filesize=!filesize:~0,-6! MB"
  ) else (
    set /a "filesize=!filesize! / 1073741824"
    set "filesize=!filesize! GB"
  )
  
  if !cont! geq 1 if !hora! leq !horapos! if !hora! geq !horant! (
   if !minuto! geq !novosminutos! (
    if !hora! equ !novashoras! (
     set "Verificar=Verificar"
     echo Faltando Video >> "%verificar_dados%"
     set /a auth=1
     set /a "fcont=fcont+1"
     echo Caminho a verificar: %%~dpf!fullname! >> "%relatorio%"    
    )
   )
   if !hora! gtr !novashoras! if !auth! equ 0 (
     set "Verificar=Verificar"
     echo Faltando Video >> "%verificar_dados%"
     set /a auth=1
     set /a "fcont=fcont+1"
     echo Caminho a verificar: %%~dpf!fullname! >> "%relatorio%"
   )
   if !minuto! lss !ante! if !auth! equ 0 (
    if !hora! leq !novashoras1! (
     set "Verificar=Verificar"
     echo Faltando Video >> "%verificar_dados%"
     set /a auth=1
     set /a "fcont=fcont+1"
     echo Caminho a verificar: %%~dpf!fullname! >> "%relatorio%"
    )
   ) 
  )
  	
  set /a auth=0
  echo !Verificar!, !ano!-!mm!-!dd!, !hh!:!mm!:!segundo!, !filesize!, %%~dpf, !fullname! >> "%verificar_dados%"
  
  set /a "cont=!cont!+1"
  
) 
  
echo Quantidade de videos faltando: !fcont! >> "%relatorio%"
echo Quantidade de videos corrompidos: !xcont! >> "%relatorio%"

