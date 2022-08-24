if status is-interactive
    # Commands to run in interactive sessions can go here
	eval (dircolors /home/sahil_u/.dir_colors | head -n 1 | sed 's/^LS_COLORS=/set -x LS_COLORS /;s/;$//')
end
