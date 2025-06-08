# How to use tmux to manage SSH terminal sessions

## Start a tmux session

Type ```tmux``` and press enter to start a tmux session,

Run the command or bash script you want to be long running.

Press ```Ctrl-B``` then press ```D ``` to disconnect from session

## List active sessions
```tmux ls```

## Attach to select tmux session
```tmux attach -t 0```

## Create a named tmux session   
tmux new -s Session1   

## Links
tmux cheat sheet   
https://tmuxcheatsheet.com/   

Beginners guide to tmux
https://www.redhat.com/en/blog/introduction-tmux-linux   

