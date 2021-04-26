#!/bin/sh
filename=$1
path=$HOME/Desktop

if [ -s $filename ];
then
    filename=$(ls $path | dmenu -p "Eintrag Wählen")
fi

$(grep '^Exec' "$path/$filename" | tail -1 | sed 's/^Exec=//' | sed 's/%.//' \
| sed 's/^"//g' | sed 's/" *$//g') &

# grep  '^Exec' "$path/$filename"    # - finds the line which starts with Exec
# | tail -1                         # - only use the last line, in case there are 
#                                   #   multiple
# | sed 's/^Exec=//'                # - removes the Exec from the start of the line
# | sed 's/%.//'                    # - removes any arguments - %u, %f etc
# | sed 's/^"//g' | sed 's/" *$//g' # - removes " around command (if present)
# $(...)                            # - means run the result of the command run 
#                                   #   here
# &                                 # - at the end means run it in the background
