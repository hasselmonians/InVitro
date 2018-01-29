classdef Neuron
% Standard object for saving InVitro patch recordings from a single cell.
% Currently supports saving, writing, and basic analysis of the files. Soon
% to include epoching functionality as well.

    %% Properties
    properties
        Recording
    end
    
    properties 
        props
        threshold
    end
    
    
    methods
        %% Constructor
        function self = Neuron(varargin)
            
            if nargin == 0
                baseDir = uigetdir(pwd,'Select Folder Containg ABF Files for the cell');
                abfs = dir(fullfile(baseDir,'*.abf'));
            else
%                 p = inputParser;
%                 p.addParamValue('baseDir',[])
%                 p.addParamValue('abfs', [])
%                 
%                 p.parse(varargin{:});
%                 
%                 baseDir = p.Results.baseDir; 
%                 abfs = p.Results.abfs;
                baseDir = varargin{1};
                abfs = varargin{2};
                
                if isempty(abfs)
                   abfs = dir(fullfile(baseDir,'*.abf'));
                end
            end
            
            for i = 1:length(abfs)
                r(i) = InVitroSTD.Recording([baseDir filesep abfs(i).name]);
            end
            
            self.Recording = r(:);
            
        end
    end
        
    
end