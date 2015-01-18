#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2014-12-09 16:30:16
# @Author  : Tom Hu (webmaster@h1994st.com)
# @Link    : http://h1994st.com
# @Version : 1.0

import os
import re

symbol = [',', '.', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '=', '_', '+', '`', '~', '<', '>', '?', '/', ';', ':', '\'', '\"', '[', ']', '{', '}', '|', '\\', '\n', '\t']

def main():
    # inputFile = open('/Users/Momo/Programs/course/datamining/spamfilter/SMS_Spam_Data-2', 'r')
    # outputFile = open('/Users/Momo/Programs/course/datamining/spamfilter/sms2.txt', 'w')

    inputFile = open('/Users/Momo/Programs/course/datamining/spamfilter/SMS_Spam_Data-1', 'r')
    outputFile = open('/Users/Momo/Programs/course/datamining/spamfilter/sms1.txt', 'w')

    print "start"
    line = inputFile.readline()
    while line != "":
        # filter(lambda x: not x in symbol, line)
        # line.lower()
        
        line = re.sub(r'\b[0-9]{6,}\b', ' XXXTELPHONENUMXXX ', line) # remove telephone number
        line = re.sub(r'(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?', ' XXXURLXXX ', line) # remove url
        line = re.sub(r'www[\.\w\/?\-]+[\w\/?\-]+', ' XXXURLXXX ', line); # remove url
        line = re.sub(r'(\$|£)[1-9]+[0-9]*', ' XXXMONEYXXX ', line) # remove money
        line = re.sub(r'£[0-9,.]+', ' XXXMONEYXXX ', line) # remove money
        line = re.sub(r'\b[0-9]{1,5}\b', ' XXXSHORTNUMXXX ', line) # remove short num
        line = re.sub(r'[ \r\v\f](([0-9]+[\w]+)|([\w]+[0-9]+)(\/)*)+[ \t\r\v\f]', ' XXXNUMALPHAXXX ', line) # remove num alpha
        line = re.sub(r'\b[0-9a-zA-Z]([0-9]|[a-zA-Z])*[0-9]+([0-9]|[a-zA-Z])+[0-9a-zA-Z]\b', ' XXXNUMALPHAXXX ', line) # remove num alpha

        outputFile.write(line)

        line = inputFile.readline()

    inputFile.close()
    outputFile.close()

if __name__ == '__main__':
    main()
