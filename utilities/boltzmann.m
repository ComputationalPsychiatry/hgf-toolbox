function y = boltzmann(x, beta)

q = exp(beta.*x);
Z = sum(q);
y = q./Z;

