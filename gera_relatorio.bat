@echo off
echo Gerando arquivos...
setlocal EnableDelayedExpansion
chcp 65001

rem definindo as variaveis de caminho e arquivos a serem criados
set "dir=%CD%"
set "Erros=%~dp0\RelatorioErros.txt"
set "relatorio=%~dp0\relatorio.txt"
set "verificar_dados=%~dp0\verificar_dados.txt"
set /a cont=0
set /a conferir=0
set /a horaconf=0
set /a horaiconf=0
set /a horafconf=0
set /a novashoras1=0
set /a novashoras=0
set /a novosdias=0
set /a novosdias1=0
set /a fcont=0
set /a xcont=0
set /a minfaltando=0
set /a sinc=0
set /a comparar=0
set /a vrf=0
set /p tipovideo=Tipo de video(1-Sequencial sem pastas. 2-Dividido por pastas.):
set /p tinicio=Digite o horario inicio da filmagem: 
set /p tfinal=Digite o horario final da filmagem: 
set /p periodohr=Digite a quantidade de horas da filmagem: 
set /a periodomin=!periodohr!*60
set /a qntdvideos=(!periodomin!*10)/99
set /a fuso=0
set /a diateste=0

for /f "tokens=*" %%a in ("%dir%") do set ultimos_numeros=%%~na
set ultimos_numeros=%ultimos_numeros:*-FTR=%
set /a ftrcode=!ultimos_numeros!

if !ftrcode! lss 10 (
 set /a "ftrcode=1!ftrcode!-100"
) 

if !tipovideo! equ 2 (
 for /L %%i in (302,1,310) do (
  if !ftrcode! equ %%i (
   set /a fuso=8
  ) 
 )
 for /L %%i in (1,1,11) do (
  if !ftrcode! equ %%i (
   set /a fuso=8
   if !ftrcode! equ 3 (
    set /a fuso=3
   )
  ) 
 )
 if !ftrcode! equ 15 (
  set /a fuso=3
 )
 if !ftrcode! equ 16 (
  set /a fuso=3
 )
 if !ftrcode! equ 301 (
  set /a fuso=3
 )
)

rem verifica se existe
if exist "%relatorio%" del "%relatorio%"
if exist "%verificar_dados%" del "%verificar_dados%"
if exist "%~dp0\a.txt" del "%~dp0\a.txt"
if exist "%Erros%" del "%Erros%"

rem cria cabecalho do arquivo relatorio
echo Verificar,Data, Hora, Tamanho, Diretorio, Nome >> "%verificar_dados%"
  
rem Loop for, que interage sobre todos os arquivos com a extensão ".avi" no diretório %dir% e em todos os seus subdiretórios (/s), em ordem crescente (/od) rem o comando dir é usado para listar o conteúdo do diretório e o modificador /b é utilizado para listar apenas o nome do arquivo
  
for /f "delims=" %%f in ('dir /s /b /od "%dir%\*.avi"') do (
  set "fullname=%%~nxf"
  set "filesize=%%~zf"
  set "Verificar=Ok"
  if !filesize! equ 0 (
    set "Verificar=Erro"
    echo Corrompido: %%~dpf!fullname! >> "%Erros%"
    set /a "xcont=xcont+1"
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
      
     set "mm=!minuto!"
     set "ss=!segundo!"
     set "hh=!hora!"
     set "dd=!dia!"


     rem conversão
     if !segundo! lss 10 (
       set /a "segundo=1!segundo!-100"
     ) 
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

     if !diateste! equ 0 (
	set /a diateste=1
      if !tinicio! lss !hora! (
	 set /a diainicio=!dia!+1
      ) else (
	 set /a diainicio=!dia!
      )
     )

     rem arrumando fuso horario
     if !tipovideo! equ 2 (
	if !fuso! equ 3 (
	 set /a hora=!hora!-fuso
	 if !hora! lss 0 (
	  set /a hora=!hora!+24
	  set /a dia=!dia!-1
	 )
	)
	if !fuso! equ 8 (
	 set /a hora=!hora!+fuso
	 if !hora! gtr 23 (
	  set /a hora=!hora!-24
	  set /a dia=!dia!+1
	 )
	)
      if !hora! lss 10 (
       set "hh=0!hora!"
      ) else (
	 set "hh=!hora!"
      )

      if !dia! lss 10 (
       set "dd=0!dia!"
      ) else (
	 set "dd=!dia!"
      ) 
     )

     if !conferir! equ 0 (
      set /a "horaconf=!hora!+1"
	if !horaconf! equ 24 (
	 set /a horaconf=0
	)
      if !tinicio! equ !horaconf! (
	 if !minuto! geq 50 (
	  set /a horaiconf=!minuto!-50
	  set /a conferir=1
	 )
      )
	if !hora! geq !tinicio! (
	 if !dia! equ !diainicio! (
	  set /a conferir=1
	  set /a minfaltando=!minuto!
	  set /a segfaltando=!segundo!
	  echo !minfaltando!:!segfaltando! minutos faltando antes desse caminho: %%~dpf!fullname! >> "%Erros%"
	 )
	)  
     )

     if !conferir! equ 1 (
      set /a horaconf=!hora!+1
      if !tfinal! equ !horaconf! (
	 if !minuto! geq 50 (
	  set /a horafconf=!minuto!-50
	  set /a conferir=2
	 )
      )  
     )

     if !cont! geq 1 if !hora! leq !horapos! if !hora! geq !horant! (

	   if !hora! equ !horas! (
	    set /a minutos=!minuto!-!minutos!
	   )
	   if !hora! gtr !horas! (
	    set /a horas=!hora!-!horas!
	    set /a conversao=!horas!*60
	    set /a minutos=!minuto!+!conversao!-!minutos!
	   )
	   if !hora! lss !horas! (
	    set /a dias=!dia!-!dias!
	    set /a dias=!dias!*24
	    set /a horas=!hora!+!dias!-!horas!
	    set /a conversao=!horas!*60
	    set /a minutos=!minuto!+!conversao!-!minutos!	
	   )
	   if !minutos! gtr 15 (
	    set /a minutos=2+!minutos!
	    set /a minutos=!minutos!/10
	    set /a minutos=!minutos!-1
          set "Verificar=Verificar"
          echo Faltando Video >> "%verificar_dados%"
          set /a "fcont=!fcont!+!minutos!"
          echo !minutos! video/s faltando antes desse caminho: %%~dpf!fullname! >> "%Erros%"
	   )
     )
     set /a segundos=!segundo!
     set /a minutos=!minuto!
     set /a horas=!hora!
     set /a dias=!dia!
     if !vrf! equ 0 (
	set "horainic=Data e hora do inicio dos videos !ano!-!mes!-!dd!, !hh!:!mm!:!ss!"
	set /a vrf=1
     )

     if !conferir! equ 1 (
      set /a "cont=!cont!+1"
     )

     echo !Verificar!, !ano!-!mes!-!dd!, !hh!:!mm!:!ss!, !filesize!, %%~dpf, !fullname! >> "%verificar_dados%"
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

	 if !tipovideo! equ 2 (
	  echo Video desincronizado: %%~dpf!fullname! >> "%Erros%"
	 )
      )
)

for /L %%i in (3,1,1000) do (

  if not "!vet[%%i]!"=="" (
    echo Video desincronizado: !vet[%%i]! >> "%Erros%"
  )

)

set /a minquantidade=0
set /a resto=0
set /a minquantidade=!minfaltando!/10
set /a resto=!minfaltando!-(!minquantidade!*10)
set /a cont=!cont!+!minquantidade!
set /a fcont=!minquantidade!+!fcont!

echo Quantidade de videos faltando: !fcont! >> "%relatorio%"
echo Minutos resto faltando: !resto!:!segfaltando! >> "%relatorio%"
echo Quantidade de videos corrompidos: !xcont! >> "%relatorio%"
echo Quantidade de videos desincronizados: !sinc! >> "%relatorio%"

set /a cont=!cont!-1
set /a horariosfaltando=(!sinc!*99)/10
set /a totalsincronizados=(!cont!*99)/10
set /a soma=!totalsincronizados!+!horariosfaltando!-!horafconf!+!horaiconf!-!minfaltando!

set /a "prdanterior=!periodomin!-8"
set /a "diferenca=!periodomin!-!soma!"

set /a diferenca=!diferenca!/10

if !fcont! gtr 0 if !tipovideo! equ 1 (
  set /a "diferenca=!diferenca!-!fcont!"
)

if !diferenca! gtr 0 (
 if !tipovideo! equ 1 (
	echo Quantidade de videos desincronizados faltando: !diferenca! >> "%relatorio%"
	echo !horainic! >> "%relatorio%"
	echo Ultima data e horario de sincronização !ano!-!mes!-!dd!, !hh!:!mm!:!ss! >> "%relatorio%"
 )
) else (
 if !tipovideo! equ 1 (
	echo !horainic! >> "%relatorio%"
	echo Ultima data e horario dos videos !ano!-!mes!-!dd!, !hh!:!mm!:!ss! >> "%relatorio%"
 )
)

if !tipovideo! equ 2 (
	echo !horainic! >> "%relatorio%"
	echo Ultima data e horario dos videos !ano!-!mes!-!dd!, !hh!:!mm!:!ss! >> "%relatorio%"
)

