function [U] = getBases( spec ) 

[U,S,V] = svd(spec,'econ');
sig = diags(S);
energy = 0;
thresh = .95
rank = 1;
while( (energy < thresh) && (rank <= length(sig)))
	energy = energy + sum(sig(1:rank)) / sum(sig);
	rank = rank + 1;
end
