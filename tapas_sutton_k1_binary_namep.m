function pstruct = tapas_sutton_k1_binary_namep(pvec)
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2013 Christoph Mathys, TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

pstruct = struct;

pstruct.mu   = pvec(1);
pstruct.Rhat    = pvec(2);
pstruct.vhat_1   = pvec(3);
pstruct.h_1    = pvec(4);

return;