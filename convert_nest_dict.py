import json
import argparse
parser = argparse.ArgumentParser()
parser.add_argument('-f', '--file',
                        help='filename without extension',
                        required='True')
args = parser.parse_args()

with open(args.file+'.json') as f:
    data = f.read()
d = json.loads(data)
#print(len(d['content']['github']))
#print(type(d))

tx=open(args.file+'.sh','w')
tx.write('#!/bin/bash\n')
path=[]

#define function to iterate trough our nested dictionary and write the value-key pairs into a txt
def dict_to_list(dc):
  itemCount=len(dc) #to track where we are and indicate the last item
  for i in dc: 
    itemCount-=1
    if isinstance(dc[i], dict): #if our item is a dictionary, we have to dig deeper
      path.append(i)  #before going down, let's add the current level to the path
      dict_to_list(dc[i]) #the function calls itself      
    elif isinstance(dc[i], str): #else we got a string, that we can write in the file
      string='firebase functions:config:set '               
      for item in path:         #we iterate through the list containing the full path, getting the items out one by one
        string=string+item+'.'  
      string=string+i+'='+'\"'+dc[i]+'\"'+'\n'
      tx.write(string)
      if itemCount==0: #after the last item in the current dictionary we jump one level up, thus we have to delete the last item from our path list
        path.pop()


#call the function and supply d as input dictionary
dict_to_list(d)
tx.close()