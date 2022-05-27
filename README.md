This script is for generating bunch of nginx files for totara cluster from prepared template.

CONDITIONS
1. Script has to be present within folder where files have to be updated using template.
2. Template file (included in repo) has to be present in the same folder as script and has to be named template.conf. Modify template as required before      using the script.
3. Order of procedures is VERY IMPORTANT - when generating new set first use option 2, then option 3, 
   review files if they look as expected remove manually folder new_set and folder backup and newly created files are ready to push. 
4. If you are not satisfied with the generated set of files - use option 4 which will reverse all changes and you can start over again from option 2. 

OPTION 1 
can be used to find any string contained in all files in the folder declaring how many times string is appearing in it:
0 -> more then 0 (script will print all files containing at least 1 searched string (1 or more))
1 -> more then 1 and so on...
