function y = tapas_logit(x, a)

if any(x >= a) || any(x <= 0)
    error('tapas:hgf:logit:ArgOutOfRange', 'Argument out of range.');
end
    
y = log(x./(a-x));

return;