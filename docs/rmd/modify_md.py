#!/usr/bin/env python
# coding: utf-8
from os import listdir
import re

files = listdir("./develop/")

print(files)

for i in files:
    if i.endswith(".md"):
        with open("./develop/"+ i) as f:
            text = f.read()
            text = re.sub("\nknit((.|\n)*)[0-9]{4}-[0-9]{2}-[0-9]{2}", "---" ,text)
            print(text)
        with open("./develop/"+ i, "w") as f:
            f.write(text)