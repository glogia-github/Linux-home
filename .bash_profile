# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/login.defs
#umask 022

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

#===============================================================
# ==== Load Modules
module purge

# Switch datadir (for proper directories settings)
module switch dfldatadir/gen15602

# OptNPath
module load fortran/intel/20.0.0
module load mkl/20.0.0
export PATH=$PATH:$GEN15602_ALL_CCCWORKDIR/optnpath

# Orca
module load mpi/openmpi/4.1.1
export ORCA_BIN_DIR=$GEN15602_ALL_CCCWORKDIR/orca_6_0_0/orca_6_0_0
export PATH=$PATH:$ORCA_BIN_DIR
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORCA_BIN_DIR

# Molden
export PATH=$PATH:$GEN15602_ALL_CCCWORKDIR/molden

# XTB / CREST
export XTBHOME=$GEN15602_ALL_CCCWORKDIR/xtb
source $XTBHOME/share/xtb/config_env.bash

# Gaussian
module load gaussian/16-C.02
. $GAUSSIAN_ROOT/g16/bsd/g16.profile

# Python
module load python3/3.10.6

#===============================================================
# Define some colors first:
red='\e[0;31m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NC='\e[0m'              # No Color
# --> Nice. Has the same effect as using "ansi.sys" in DOS.

#-------------------
# Personnal Aliases
#-------------------

# Giacomos Alias
alias chome='cd /ccc/cont003/home/unisorbo/lombardg' # real home: is symlinked to bridge, all changes are identical in both directories.
home='/ccc/cont003/home/unisorbo/lombardg' # real home: is symlinked to bridge, all changes are identical in both directories.
alias cstore='cd /ccc/store/cont003/gen15602/lombardg' # store
store='/ccc/store/cont003/gen15602/lombardg' # store
alias cbridge='cd /ccc/cont003/dsku/blanchet/home/user/unisorbo/lombardg' # home of blanchet bridge
bridge='/ccc/cont003/dsku/blanchet/home/user/unisorbo/lombardg' # home of blanchet bridge
alias cirek='cd /ccc/cont003/dsku/blanchet/home/user/unisorbo/tomczyki' # home of blanchet bridge
irek='/ccc/cont003/dsku/blanchet/home/user/unisorbo/tomczyki' # home of blanchet bridge
alias cwork='cd /ccc/work/cont003/gen15602/lombardg'
work='/ccc/work/cont003/gen15602/lombardg'
alias cscratch='cd /ccc/scratch/cont003/gen15602/lombardg'
scratch='/ccc/scratch/cont003/gen15602/lombardg'
alias emacs='emacs -nw' # no window emacs
alias tree='tree -Csu' # alt to ls
alias lr='ls -lR' # recursive ls
alias sq='squeue -p skylake -o "%.7i %9P %.11u %.22j %.3t %.20S %.10M %.10L" ' # SLURM
alias skyq='ccc_mpp -p skylake -u $USER'
alias h='history'
alias jobs='jobs -l'
alias cost='ccc_myproject'

# -> Prevents accidentally clobbering files.

alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

## alias from setup
#misc
alias r='rlogin'
alias ..='cd ..'
alias PATH='echo -e ${PATH//:/\\n}'
alias du='du -kh'
alias df='df -kTh'

#The 'ls' family (this assumes you use the GNU ls)
alias ls='ls -aF --color'           # show hidden files
alias ll='ls -lhF --color'	# add colors for filetype recognition
alias lx='ls -lXB'          # sort by extension
alias lk='ls -lSr'          # sort by size
alias lc='ls -lcr'          # sort by change time
alias lu='ls -lur'          # sort by access time
alias lr='ls -lR'           # recursive ls
alias lt='ls -ltr'          # sort by date
alias lm='ls -al |more'     # pipe through 'more'

#User specific aliases and functions
alias almostFinished="echo '************************************';
                      echo 'Finished Steps:' ;
                      grep -r --include '*.log' 'cpu time' $CCCSCRATCHDIR
                     "
alias finished="echo '************************************';
                echo 'Finished Computations:' ;
                grep -r --include '*.slurmout' --exclude-dir=~/scratch finished ~/*
               "
alias nbtour="echo '************************************';
              echo 'Nombre de Tours :' ;
              grep -r --include '*.log' -c Predicted $CCCSCRATCHDIR
             "
alias count="echo '************************************';
             echo 'Number of YESs:' ;
             grep -r --include '*.log' -c YES $CCCSCRATCHDIR
            "
alias encours="echo '************************************';
               echo 'Running Computations: ' ;
               ccc_mpp -u $USER ;
               echo '************************************';
               echo 'Total Number of Computations:' ;
               ccc_mpp -u $USER | grep $USER -c
              "
alias lowFreq="echo '************************************';
               echo 'Three Lowest Frequencies: ' ;
               echo '************************************';
               grep -r --include '*.log' -A6 Harmonic ~/*
              "
alias vectors="echo '************************************';
               echo 'Computed Vectors:';
               grep -r --include '*.log' -E 'vectors produced|vectors were produced' $CCCSCRATCHDIR | sed 's/\(produced\).*/\1/g'
              "
alias warning="echo '************************************';
               echo 'Warning Produced: ' ;
               grep -r --include '*.log' Warning $CCCSCRATCHDIR
               grep -r --include '*.log' --exclude-dir=$HOME/scratch Warning ~/*
              "
alias predictions="find $CCCSCRATCHDIR -name '*.log' -exec sh -c 'echo; echo {}; grep Predicted -B5 {} | tail -6' \;"
alias giacomo="encours nbtour count almostFinished finished"
alias calculations="giacomo vectors warning lowFreq"
alias queue='ccc_mpp -u $USER'
alias watchLogs='watch tail -n7 ~/scratch/*/*.{log,out}'
# Better alternative, only a problem with quotes
# alias watchLogs='watch "find $SCRATCH -type f \( -regex '.*/*\.\(log\|out\)' \) -exec tail -n10 {} +"'
alias watchQueue='watch -n 10 --color "ccc_mpp -u $USER"'
