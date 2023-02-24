<h1> BATCH file that scans corrupted AVI files from cameras </h1>

<h6>The BATCH file is used because of its facility of use for people who don't know how to intall any IDE or program language </h6>
<h6> Context: The researchers install and configure cameras in the road with output of a bunch of AVI files with nearly 8~12 minutes each. Some files are corrupted in the process and the file is empty. To check easily if the videos are or not corrupted, the researchers use this BATCH file in their computer and its output is 3 TXT files with a report of the files in the path. </h6>


> Status: development

<h2> Run: step by step </h2>

- First you should drop this file in the directory where are located the AVI files. ( It recognizes the sub-folders too)
- The AVI files must have the date in this format in its name: YYYYMMDDHHMMSS
  - All the AVI names will be read and the data will be collected and be stored in a database called "relatorio.txt"
  - The size of the AVI file will be collected in MB and verify if it is 0MB, these are the corrupted files. The number of those files will be counted and stored in "verificar_dados.txt".
  -all the corrupted files will be listed in missing_data.txt (data, hora, pasta)
- Drop the batchfile where the AVI files are located

<h2> Next steps </h2>

- Find a way to store the missing time in "relatorio.txt"
  - Store the next video time in another column in missing_files.txt
  - If the diference in time of the videos is more than 12 minutes, the next row of missing_files.txt is 
  
  > ,,missing_files.txt
  
