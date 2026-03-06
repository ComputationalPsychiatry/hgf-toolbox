function X = nearest_psd(X)
% Finds the nearest positive semi-defnite matrix to X
% Input: X - a square matrix
% Output: X - nearest positive semi-definite matrix to input X

% Ensure symmetry
X = (X' + X)./2;

% Continue until X is positive semi-definite
while any(eig(X) < 0)
    % V: right eigenvectors, D: diagonalized X (X*V = V*D <=> X = V*D*V')
    [V, D] = eig(X);
    % Replace negative eigenvalues with 0 in D
    D = max(0, D);
    % Transform back
    X = V*D*V';
    % Ensure symmetry
    X = (X' + X)./2;
end

end

