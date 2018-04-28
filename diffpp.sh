#!/bin/bash


usage()
{
  echo "usage:"
  echo "$0 file1 file2 [filter]"
  echo
  echo "if specified filter, then make difference with filtered file1 and file2."
  echo "filter is given by any command which assume stdin as input."
}


executeDiff()
{
  local tmpFile1
  local tmpFile2
  local actualFile1
  local actualFile2

  tmpFile1=$1
  shift
  tmpFile2=$1
  shift
  actualFile1=$1
  shift
  actualFile2=$1
  shift

  diff -ru ${tmpFile1} ${tmpFile2} | sed -e "s/${tmpFile1}/${actualFile1}/g"  -e "s/${tmpFile2}/${actualFile2}/g" 

}

applyFilter()
{

  local filename=$1
  shift
  local filter="$*"
  
  local tmpfile=$(mktemp tmpXXXX)
  
  
  cat ${filename} | eval "${Filter}" > ${tmpfile}
  echo $tmpfile
  
}

if [ $# -lt 2 ]
then
  usage
  exit 1
fi

File1=$1
shift
File2=$1
shift

if [ $# -ge 1 ]
then

  Filter="$*"
  
  tFile1=$(applyFilter ${File1} "$*")
  tFile2=$(applyFilter ${File2} "$*")
  
  executeDiff ${tFile1} ${tFile2} ${File1} ${File2}

  rm -f ${tFile1} ${tFile2}
else
  diff -ru ${File1} ${File2}
fi


