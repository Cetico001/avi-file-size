<h1> BATCH file that scans corrupted AVI files from cameras (create_data.bat or RelatorioRevXX.bat) </h1>

<h6>The BATCH file is used due its facility of use for people who don't know how to intall any IDE or program language </h6>
<h6> Context: The researchers install and configure cameras in the road with output of a bunch of AVI files with nearly 8~12 minutes each. Some files are corrupted in the process and the file is empty. To check easily if the videos are or not corrupted, the researchers use this BATCH file in their computer and its output is 3 TXT files with a report of the files in the path. </h6>


> Status: development

<h2> Run: step by step </h2>

- First you should drop this file in the directory where are located the AVI files. ( It recognizes the sub-folders too)
- The AVI files must have the date in this format in its name: YYYYMMDDHHMMSS
  - All the AVI names will be read and the data will be collected and be stored in a database called "relatorio.txt"
  - The size of the AVI file will be collected in MB and verify if it is 0MB, these are the corrupted files. The number of those files will be counted and stored in "verificar_dados.txt".
  -all the corrupted files will be listed in missing_data.txt (data, hora, pasta)
- Drop the batchfile where the AVI files are located
- The corrupted_hours.txt shows the start video time and when it should end (based on next video)

<h2> Next steps </h2>

- Caminhos de cada vídeo que está faltando, ou está corrompido.
- Fazer relatorios por pastas de cada ponto.
  
<h1> BATCH file that scans corrupted AVI files from cameras: RESEARCHERS (gera_relatorio.bat) </h1>

<h6> This is a code made mainly for the use of the researchers and shows the corrupted files and if it is missing any file </h6>

> Status: development

- Simply put the BATCH file in the folder where the points of the research are located, as you can see below:
![image](https://user-images.githubusercontent.com/84081250/225407289-89902e51-fe29-489f-882a-c13ce08bbfca.png) 

The folder the code is located should look like the image above.

- Then double-click in BATCH file and it will generate a TXT file in each point folder.


<h2> Next steps </h2>
- 
