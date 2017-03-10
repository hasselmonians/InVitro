classdef Recording < handle
    
    %% Properties:
    properties (Hidden)
        db
    end
    
    properties %(SetAccess=private)
        fname
        V
        I
        ts
    end
    
    properties (Hidden, SetAccess=private)
        b_d
    end
    
    properties
        type
    end
    
    methods
        
        
        %% Constructor:
        function self = Recording(fname,type)
            import InVivoSTD.*
            
            if ~exist('type','var')
                type = 'undefined';
            end
            
            self.type = type;
            self.fname = fname;
         
            self.db = InVitroSTD.Database(self.fname,@InVitroSTD.Utils.abfload,@error);
            
            self.reload;
            
        end
        
        %% Reload from Database:
        function self = reload(self)
            
            [~, si] = InVitroSTD.Utils.abfload(self.fname);
            si = si/1E6;
            
            d = self.db.get;
            if numel(size(d))==2
                self.V{1} = d(:,1);
                self.I{1} = d(:,2);
                self.ts{1} = si*(cumsum(ones(size(self.V{1})))-1);
            else % Multiple sweeps
                for i = 1:size(d,3)
                    self.V{i} = squeeze(d(:,1,i));
                    self.I{i} = squeeze(d(:,2,i));
                    self.ts{i} = si*(cumsum(ones(size(self.V{1})))-1);
                end
            end
            
        end
    end
end