This script is for generating bunch of nginx files for totara cluster from prepared template.

CONDITIONS
1. Script has to be present within folder where files have to be updated using template.
2. Template file (included in repo) has to be present in the same folder as script and has to be named template.conf
3. Order of procedures is very important - when generating new set first use option 2, then option 3, 
   review files if they look as expected remove manually folder new_set and folder backup and folder is redy to push. 
4. If you are not satisfied with the generated set of files - use option 4 which will reverse all changes and you can start over again from option 2. 
