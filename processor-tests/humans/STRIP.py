#!/usr/bin/python

import sys,os,re

for filename in os.listdir('.'):
    if not filename.endswith('.txt'): continue
    #print filename
    lines = open(filename).read().split('\n')
    for i in range(len(lines)-1, -1, -1):
        if re.match('.*"static-ordering".*false.*', lines[i]):
            #print filename
            lines[i-1] = re.sub(",\s*$", "", lines[i-1])
            lines.pop(i)
    lines = "\n".join(lines)
    open(filename, "w+").write(lines)
    
