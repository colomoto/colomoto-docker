#!/usr/bin/python

# Author: CoLoMoTo
# Affiliation: CoLoMoTo
# Aim:
# Take multiple NuSMV outputs and write all results in one file (tab-separated columns).
# Extracts information from all lines of type: 
# -- specification AF pY505LCK = 0  is true
# Date: 20/07/2017


import sys, fileinput, re, getopt

def main(argv):
    
    # Filename for report
    outputFile = ''
    
    # Extract arguments and output file name
    try:
        opts, args = getopt.getopt(argv,"ho:",["outputfile="])
    except getopt.GetoptError as err:
        print(err)
        print 'nusmv_report_all_tests.py -o <outputfile> <argument1, argument2>'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'nusmv_report_all_tests.py -o <outputfile> <argument1, argument2>'
            sys.exit()
        elif opt in ("-o", "--outputfile"):
            outputFile = arg
    
    # Compile the regular expression
    patternSpec = re.compile('-- specification ')
    patternOutcome = re.compile('-- specification (.*)  is (true|false)')
    
    # Create container for matches
    outcomes = []
    
    # Open all files one after another
    fin = fileinput.input(files=(args))
    # Go through each line
    for line in fin:
        # If line starts with '-- specification '
        if patternSpec.match(line):
            # Extract success of not of the test
            matches = patternOutcome.match(line)
            # Append results to 'outcomes' list
            if matches:
                outcomes.append((fin.filename(), matches.group(1), matches.group(2)))
    fin.close()
    
    # Write result in output file
    with open(outputFile, 'w') as fout:
    	fout.write("File\tSpecification\tOutcome\n")
        for res in outcomes:
            fout.write("\t".join(res)+"\n")
    

if __name__ == "__main__":
   main(sys.argv[1:])


