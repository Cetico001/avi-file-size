@echo off
echo Gerando arquivos...
setlocal EnableDelayedExpansion
chcp 65001

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
set /a sinc=0
set /a comparar=0

rem verifica se existe
if exist "%relatorio%" del "%relatorio%"
if exist "%verificar_dados%" del "%verificar_dados%"
if exist "%~dp0\a.txt" del "%~dp0\a.txt"

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
  set /a "verif=!data_hora:~0,4!+0"
  if !verif! geq 2000 (
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
     set /a "cont=!cont!+1"

     echo !Verificar!, !ano!-!mm!-!dd!, !hh!:!mm!:!segundo!, !filesize!, %%~dpf, !fullname! >> "%verificar_dados%"
  ) else (
	
      for /f "tokens=1 delims=_" %%a in ("!fullname!") do set "rec=%%a"
	set /a string=0
	for /L %%i in (0,1,100) do (
    	  set "letra=!rec:~%%i,1!"
    	  if not "!letra!"=="" set /a string+=1
	)

	if !sinc! gtr 0 (
	 set /a comparar=!maiornumero!
	)
	if !string! equ 4 (
	  set /a num=!rec:~3,1!
	  if !num! gtr 3 (
	   set vet[!num!]=%%~dpf!fullname!
	   set /a "sinc=!sinc!+1"
	  )
	) else (
	     if !string! equ 5 (
	      set /a num=!rec:~3,2!
	      set vet[!num!]=%%~dpf!fullname!
		set /a "sinc=!sinc!+1"
	     ) else (
		if !string! equ 6 (
	 	 set /a num=!rec:~3,3!
	  	 set vet[!num!]=%%~dpf!fullname!
		 set /a "sinc=!sinc!+1"
 	  	) 
	     )
	  )

	if !num! gtr !comparar! (
	 set /a maiornumero=!vet[!num!]!
	)
      )
)


for /L %%i in (3,1,1000) do (

  if not "!vet[%%i]!"=="" (
    echo Video desincronizado: !vet[%%i]! >> "%relatorio%"
  )
)

echo Quantidade de videos faltando: !fcont! >> "%relatorio%"
echo Quantidade de videos corrompidos: !xcont! >> "%relatorio%"
echo Quantidade de videos desincronizados: !sinc! >> "%relatorio%"

