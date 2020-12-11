Functionalities

1. Filter and clean original .gdx file as produced by Aglink (R\adjust_gdx.r)
2. Compare the data file (.gdx) to the code lists (.gms) as received from Aglink. Potential errors reported in Excel files. (scirpts\convert_to_gdx.gms)
3. Create a visualization of the Aglink baseline in the GUI for further checks (scripts\aglink_gdx_forGUI.gms)


Code installation

- Requires a working CAPRI installation. Set the path to the working folder on your own machine in settings.gms
- GAMS scripts are collected in \scripts. You need a GAMS installation to run the scripts
- For running the R script, you need R installed on your computer
- Create a subfolder \data
- Placed the data file (.gdx format) we receive from the Aglink team under \data
- Place the set definitions received from the Aglink team (in .gms format) under \sripts
- create a subfolder results

GUI installation

- The GUI is only for visualizing the Aglink baseline. The conversion of the Aglink .gdx to a CAPRI-usable format does not require the GUI
- The GUI folder includes the customized .xml files to visualize the original Aglink baseline. It includes table definitions and code lists for the Aglink result cube.
- Copy the content of the \GUI folder to a GUI installation from any CAPRI version. 
- Adjust the java patch in capri64.bat and execute the file


How to process a new Aglink baseline?

- change path, file names etc. in root\settings.gms
- update possibly modified regional/product/etc. codes for the GUI, using utilities\create_xml.gms
- create_xml.gms will create (surpise) an xml file with the full code lists of Aglink
- run R\adjust_gdx.r to reshape the original Aglink result cube (data massage). This generates \data\MTO20XX.gdx
- adjust and run convert_to_gdx.gms. This will reshape the original Aglink
  .gdx format to a more usable one and create reporting Excel sheets
  on the code changes
- adjust Aglink set definitions in the CAPRI installation (gams/baseline)
  if needed and re-run convert_to_gdx.gms
- re-run create_xml.gms and update the .xml files in the GUI folder
  so that the GUI shows the updated code lists (if any)
- adjust and run aglink_gdx_forGUI.gms. This will generate a .gdx
  in the results/capmod folder that you can visualize with a GUI.
- start GUI/capri64.bat to check the Aglink time series in the GUI
