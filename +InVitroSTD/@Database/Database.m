classdef Database < handle
% This is a class to be used as a field in a structure. Adds the ability to
% store data on hard drive / server while looking like a field in a
% structure. Custom load/save functionality present. 

% wchapman 2014.05.03


    %% classdef
    properties (Hidden)
        
    end
    
    properties
        fname           % File or server to get information from
        loadHandle      % Function handle to call on fname (eg @load)
        saveHandle      % Function handle to save on fname (eg @save)
    end
    
    methods
        %% Constructor
        function self = Database(fname,loadHandle,saveHandle)
            % db = database('myFile.mat',@load,@save)
            if ~exist('loadHandle','var')
                loadHandle = [];
            end
            
            if ~exist('saveHandle','var')
                saveHandle = [];
            end
            
            if isempty(loadHandle)
                loadHandle = @load;
            end
            
            if isempty(saveHandle)
                saveHandle = @save;
            end
            
            self.fname = fname;
            self.loadHandle = loadHandle;
            self.saveHandle = saveHandle;
        end
        
        %% this.get:
        function data = get(self)
            disp('Loading...')
            data = self.loadHandle(self.fname);
        end
        
        %% this.set = dataVar
        function set(self,dataVar)
            disp('Saving...')
            self.saveHandle(self.fname,dataVar);
        end
        
        %% test

        
    end
    
end

