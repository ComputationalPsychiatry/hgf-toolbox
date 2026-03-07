function setup()
% Set up the HGF Toolbox by adding all subdirectories to the MATLAB path.
%
% USAGE:
%   Run this once after downloading or cloning the toolbox:
%     >> cd /path/to/hgf-toolbox
%     >> setup
%
%   This adds the toolbox and all its subdirectories to your MATLAB path.
%   You can then call any toolbox function from anywhere (e.g., fitModel,
%   simModel, hgf_binary_config, etc.) without specifying paths.

toolboxDir = fileparts(mfilename('fullpath'));
addpath(genpath(toolboxDir));
disp(['HGF Toolbox added to path: ', toolboxDir]);

end
