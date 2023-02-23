<h1> BATCH file that scans corrupted AVI files from cameras </h1>

> Status: development

<h2> Run: step by step </h2>

- The AVI files must have the date in this format in its name: YYYYMMDDHHMMSS
  - All the AVI names will be read and the data will be collected and be stored in a database called "relatorio.txt"
  - The size of the AVI file will be collected in MB and verify if it is 0MB, these are the corrupted files. The number of those files will be counted and stored in "relatorio.txt".
- Drop the batchfile where the AVI files are located

<h2> Next steps </h2>

- Find a way to store the missing time in "relatorio.txt"
