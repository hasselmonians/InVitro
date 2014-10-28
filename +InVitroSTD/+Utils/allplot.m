function allplot(sv)

    fn = fieldnames(sv);
    %figure

    for i = 1:length(fn)
        for k = 1:length(fn)
            eval(['x = sv.' fn{i} ';']);
            eval(['y = sv.' fn{k} ';']);
            
            %subplot(length(fn),length(fn),CMBHOME.Utils.SubplotSub2Ind([length(fn) length(fn)],[i k]))
            figure
            plot(x,y,'.')
        end
    end

end