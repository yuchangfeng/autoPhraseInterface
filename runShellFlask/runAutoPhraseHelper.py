#!/usr/bin/env python
# -*- coding: utf-8 -*- 

import os
abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
print("abspath = "+ str(abspath))
print("dname = "+ str(dname))
os.chdir(dname)

from subprocess import Popen,PIPE
import re
import time



# corpus file
# candidate_file = "./tempInput.txt"
# shell file
# autoPhrase_shell = "autoPhrase/phrasal_segmentation.sh"
# shell_para = "./tempInput.txt"
# segmentation file
# segmentation_res_file = "./segmentation.txt"


def write_file(doc, timestamp):
    """
    this function write data to file
    :param doc: a list of string (sentence)
    :return:
    """
    string = ''
    for item in doc:
        if string == '':
            string = item
        else:
            string = string +'\t'+ item

    candidate_file = "./%stempInput.txt" % (str(timestamp))
    with open(candidate_file, 'w+') as x_file:
        x_file.write(string)

def read_file(filename):
    '''
    读文件，返回文件字符串
    :param string: 
    :return:
    '''
    docDic = {}
    with open(filename, 'r') as file:
        # get sentences
        snts = file.read().replace('\n', '').split('\t')
        for snt in snts:
            if snt == '':
                break
            s = snt.replace('<phrase>','').replace('</phrase>','')
            phrases = parsing_segmenataion(snt)
            docDic[s]=phrases
        return docDic

def parsing_segmenataion(string):
    '''
    抽取文件字符串的phrase，返回phrase数组
    :param string:
    :return:
    '''
    p = re.compile(r'<phrase>([^<]+?)</phrase>')
    return p.findall(string)

def generating_list(doc):
    '''
    把function合成在一起使用，暴露在外。
    :param string(doc): is a list of string(sentance) 
    :return: 如果运行成功 返回数组 如果不成功返回空
    '''
    timestamp = int(round(time.time()*1000))
    write_file(doc, timestamp)
    shell_para = "./%stempInput.txt" % (str(timestamp))
    Process = Popen('%s/phrasal_segmentation.sh %s %s' % (str(dname),str(shell_para), str(timestamp)), shell=True)
    print(Process.communicate())

    phrase_dict = {}
    segmentation_res_file = "%s/%ssegmentation.txt" % (str(dname),str(timestamp))

    if Process:
        # phrase_dict = parsing_segmenataion(read_file(segmentation_res_file))
        phrase_dict = read_file(segmentation_res_file)

    cleanProcess = Popen('bash %s/rm_tmp_file.sh %s' % (str(dname),str(timestamp)), shell=True)
    print(cleanProcess.communicate())

    return phrase_dict





