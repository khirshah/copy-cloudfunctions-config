import fileinput
import argparse

#--------------------------- init ------------------------------------------
#parst the arguments
parser = argparse.ArgumentParser()
parser.add_argument('-F', '--fileToSearch',
                        help='fileToSeach',
                        required='True')
parser.add_argument('-ST', '--textToSearch',
                        help='textToSeach',
                        required='True')
parser.add_argument('-RT', '--textToReplace',
                        help='textToReplace',
                        required='True')

args = parser.parse_args()

#--------------------------- text replace ----------------------------------
with fileinput.FileInput(args.fileToSearch+'.sh', inplace=True) as file:
    for line in file:
        print(line.replace(args.textToSearch, args.textToReplace), end='')