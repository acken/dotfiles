#!/usr/bin/env python

import os
import sys
import subprocess

def find_nih(haystack, needle, n):
    start = haystack.find(needle)
    while start >= 0 and n > 1:
        start = haystack.find(needle, start+len(needle))
        n -= 1
    return start

def runProcess(exe,workingDir):    
    yield "Evaluating..."
    p = subprocess.Popen(exe, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, cwd=workingDir)
    while(True):
        retcode = p.poll() # returns None while subprocess is running
        line = p.stdout.readline().decode(encoding='windows-1252').strip('\n').strip('\r')
        if line != "":
            yield line
        if(retcode is not None):
            break
    yield "\t"

def main(argv):
    if len(argv) > 1:
        if argv[1] == 'reactive-script-reacts-to':
            # Write one event pr line that this script will react to
            # print "goto*.cs|*"
            print "'codemodel' 'filesystem-change-file*.php'"
            return

    start = find_nih(sys.argv[1], " ", 2)
    file = sys.argv[1][start+2:-1]
    dir = os.path.dirname(file)
    for line in runProcess(file, dir):
        print(line)

# Write scirpt code here.
#   Param 1: event
#   Param 2: global profile name
#   Param 3: local profile name
#
# When calling other commands use the --profile=PROFILE_NAME and 
# --global-profile=PROFILE_NAME argument to ensure calling scripts
# with the right profile.

if __name__ == "__main__":
    main(sys.argv)
