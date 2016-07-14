#! /bin/bash

# assumes *nix program avconv is installed

for f in *.wav; 
	do sox "$f" -r 44100 "$f"; 
done

return 0;
