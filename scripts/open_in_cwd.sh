#!/bin/env bash
MYPATH=$(xtitle | pcregrep -io1 "\((.*)\) - NVIM")
MYPATH=${MYPATH/"~"/$HOME}
USETERMINAL=alacritty
if [ -d "$MYPATH" ]
then
	exec $USETERMINAL --working-directory "$MYPATH"
else
	exec $USETERMINAL --working-directory "`xcwd`"
fi
