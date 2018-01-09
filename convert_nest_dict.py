#----------------------------- import ----------------------------------
import json
import argparse

#----------------------------- init ------------------------------------
#parsing the arguments
parser = argparse.ArgumentParser()
parser.add_argument('-f', '--file',
                        help='filename without extension',
                        required='True')
args = parser.parse_args()

#open the data file, extract the data and close the file
with open(args.file+'.json') as f:
    data = f.read()
d = json.loads(data)

#opening the file we wanna write into
tx=open(args.file+'.sh','w')
tx.write('#!/bin/bash\n')
path=[]

#--------------------------- functions ---------------------------------
#define function to iterate trough our nested dictionary
# and write the value-key pairs into a txt
def dict_to_list(dc):
  #to track where we are and indicate the last item
  itemCount=len(dc)
  for i in dc: 
    itemCount-=1
    #if our item is a dictionary, we have to dig deeper
    if isinstance(dc[i], dict):
    #before going down, let's add the current level to the path
      path.append(i)
      #the function calls itself
      dict_to_list(dc[i])
    #else we got a string, that we can write in the file
    elif isinstance(dc[i], str):
      string='firebase functions:config:set '
      #we iterate through the list containing the full path,
      #getting out the items one by one              
      for item in path:
        string=string+item+'.'  
      string=string+i+'='+'\"'+dc[i]+'\"'+'\n'
      tx.write(string)
      #after the last item in the current dictionary we jump one level up,
      #thus we have to delete the last item from our path list
      if itemCount==0: 
        path.pop()


#------------------------------ commands ---------------------------------
#call the function and supply d as input dictionary
dict_to_list(d)
#close the file we were writing into
tx.close()