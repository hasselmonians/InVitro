function visualize(d, figNum, ind)
%Plotting and analysis tool for in vitro data using the Neuron class in the InVitroSTD
%tooolbox
%
%Input Variables:
%   d: Neuron object containing all files for a given cell
%   figNum (optional): desired figure window, default = 1
%   ind (optional): desired file's data in Neuron object
%
%Example calls:
%   >> d.visualize;
%   >> visualize(d);
%   >> visualize(d, 4, 2);
%
%Craig Kelley 10/13/16

%% Initialze viariables and create figure
import InVitroSTD.*

clear index_selected;
if nargin < 3, ind = 1; end
if nargin == 1, figNum = 1; ind = 1; end

di = d.Recording(ind);

f = figure(figNum);
set(gcf, 'toolbar', 'figure')
%set(gcf,'Position',[450 400 1400 900]);
set(gcf, 'units', 'normalized', 'Position', [0,0,1,1]);
control_panel = uipanel('Position', [3/4 0 1/4 1]);

Fs = 1 / (di.ts{1}(2) - di.ts{1}(1));

global index_selected;
index_selected = 1;

%% Setup interactive components
%List box for scrolling through sweeps/recordings in a file
listbox1 = uicontrol('Parent', control_panel,...
    'Style', 'listbox',...
    'units', 'normalized', ...
    'Position', [.05 .05 .25 .3],...
    'FontSize', 14,...
    'String', 1:length(di.V),...
    'Max', 100,...
    'Callback', @listbox1_Callback, ...
    'tooltipstring', 'Individual Sweeps');

%List box for scrolling through files in Neuron object
listbox2 = uicontrol('Parent', control_panel,...
    'Style', 'listbox',...
    'units', 'normalized', ...
    'Position', [.35 .05 .25 .3],...
    'FontSize', 14,...
    'String', 1:length(d.Recording),...
    'Max', 1,...
    'Value', ind,...
    'Callback', @listbox2_Callback, ...
    'tooltipstring', 'Recordings');

%Push button for finding and plotting spikes
pushButton0 = uicontrol('Parent', control_panel, ...
    'Style', 'pushbutton', ...
    'units', 'normalized', ...
    'Position', [.05, .36, .25, .1], ...
    'String', 'Find Spikes', ...
    'FontSize', 10, ...
    'Callback', @pushButton0_Callback, ...
    'tooltipstring', 'Finds and plots spikes in current window');

%Push button for removing spikes from figure
pushButton1 = uicontrol('Parent', control_panel, ...
    'Style', 'pushbutton', ...
    'units', 'normalized', ...
    'Position', [.35, .36, .25, .1], ...
    'String', 'Remove Spikes', ...
    'FontSize', 10, ...
    'Callback', @pushButton1_Callback, ...
    'tooltipstring', 'Removes spikes from current window');

%Push button for plotting and fitting spike adaptation
pushButton2 = uicontrol('Parent', control_panel, ...
    'Style', 'pushbutton', ...
    'units', 'normalized', ...
    'Position', [.05, .465, .25, .1], ...
    'String', 'Spike Adaptation', ...
    'FontSize', 10, ...
    'Callback', @pushButton2_Callback, ...
    'tooltipstring', 'Plots spike adaptation for current sweep');

%Push button for plotting impedance
pushButton3 = uicontrol('Parent', control_panel, ...
    'Style', 'pushbutton', ...
    'units', 'normalized', ...
    'Position', [.05, .568, .25, .1], ...
    'String', 'Impedance', ...
    'FontSize', 10, ...
    'Callback', @pushButton3_Callback, ...
    'tooltipstring', ...
    sprintf('Plots impedance profile and attempts to\nfind a resonance peak of single ZAP/Chirp sweep'));

%Push button for plotting sag
pushButton4 = uicontrol('Parent', control_panel, ...
    'Style', 'pushbutton', ...
    'units', 'normalized', ...
    'Position', [.05, .669, .25, .1], ...
    'String', 'Sag Ratio', ...
    'FontSize', 10, ...
    'Callback', @pushButton4_Callback, ...
    'tooltipstring', ...
    sprintf('Plots sag ratio for all sweeps in current recording\nMust use F-I style recording'));

%Push button for plotting F-I Curve
peshButton5 = uicontrol('Parent', control_panel, ...
    'Style', 'pushbutton', ...
    'units', 'normalized', ...
    'Position', [.35, .465, .25, .1], ...
    'String', 'F-I Curve', ...
    'FontSize', 10, ...
    'Callback', @pushButton5_Callback, ...
    'tooltipstring', 'Plots F-I curve for current recording');

%Push button for plotting I-V Curve
pushButton6 = uicontrol('Parent', control_panel, ...
    'Style', 'pushbutton', ...
    'units', 'normalized', ...
    'Position', [.35, .568, .25, .1], ...
    'String', 'I-V Curve', ...
    'FontSize', 10, ...
    'Callback', @pushButton6_Callback, ...
    'tooltipstring', ...
    sprintf('Plots I-V curve for negative current injections\nin current recording'));

%Push button for plotting resting membrane potential
pushButton7 = uicontrol('Parent', control_panel, ...
    'Style', 'pushbutton', ...
    'units', 'normalized', ...
    'Position', [.35, .669, .25, .1], ...
    'String', 'Resting Potential', ...
    'FontSize',10, ...
    'Callback', @pushButton7_Callback, ...
    'tooltipstring', ...
    sprintf('Plots average resting potential in current window\nMust use gap-free or ten second sweep style recording'));

%Push button for plotting AHP/ADP
pushButton8 = uicontrol('Parent', control_panel, ...
    'Style', 'pushbutton', ...
    'units', 'normalized', ...
    'Position', [.65, .36, .25, .1], ...
    'String', 'AHP/ADP', ...
    'FontSize', 10, ...
    'Callback', @pushButton8_Callback, ...
    'tooltipstring', 'Calculates and plots AHPs or ADPs in current recording');

%Push button for plotting variance of resting membrane potential
pushButton9 = uicontrol('Parent', control_panel, ...
    'Style', 'pushbutton', ...
    'units', 'normalized', ...
    'Position', [.65, .465, .25, .1], ...
    'String', 'Variance', ...
    'FontSize', 10, ...
    'Callback', @pushButton9_Callback, ...
    'tooltipstring', ...
    sprintf('Calculates and plots variance of resting membrane potential\nMust use gap free or ten second sweep style recording')); 

pushButton10 = uicontrol('Parent', control_panel, ...
    'Style', 'pushbutton', ...
    'units', 'normalized', ...
    'Position', [.65, .568, .25, .1], ...
    'String', 'Spike Heights', ...
    'FontSize', 10, ...
    'Callback', @pushButton10_Callback, ...
    'tooltipstring', ...
    sprintf('Plots the average spike height at each current intensity in a recording'));

%Text box
textBox = uicontrol('Visible', 'on', ...
    'Style', 'text', ...
    'units', 'normalized', ...
    'Position', [.76, .83, .1, .15], ...
    'String', 'Spike Threshold Estimate', ...
    'FontSize', 14);

% %Text box 2
% textBox2 = uicontrol('Visible', 'on', ...
%     'Style', 'text', ...
%     'units', 'normalized', ...
%     'Position', [.86, .83, .1, .15], ...
%     'String', ' Adjust Spike Threshold', ...
%     'FontSize', 14);

%Box for spike threshhold estimate
editBox = uicontrol('Visible', 'on', ...
    'Style', 'edit', ...
    'FontSize', 16, ...
    'units', 'normalized', ...
    'Position', [.765, .85, .088, .07], ...
    'tooltipstring', ...
    sprintf('If spike height is less than 0mV enter\nbest estimate for threshold in mV'));

% %Box for spike threshold adjuster
% editBox2 = uicontrol('Visible', 'on', ...
%     'Style', 'edit', ...
%     'FontSize', 16, ...
%     'units', 'normalized', ...
%     'Position', [.865, .85, .088, .07], ...
%     'tooltipstring', ...
%     sprintf('If necessary (e.g. "Find Spikes" misses\nsome spikes or includes "bad" spikes)\nenter a value (+/-) in mV to shift the spike threshold'));
    

%% Initial plotting for given file
%Plot all recordings sweeps in selected file
ax(1) = subplot('Position', [.05, .25, .65, .72]);
hold off
ax(2) = subplot('Position', [.05, .05, .65, .15]);
hold off

for i = 1:length(di.ts)
    ax(1) = subplot('Position', [.05, .25, .65, .72]);
    plot(di.ts{i}, di.V{i})
    ylabel('Voltage (mV)')
    %title(getFileName(di))
    hold on
    ax(2) = subplot('Position', [.05, .05, .65, .15]);
    plot(di.ts{i}, di.I{i})
    xlabel('Time (s)')
    ylabel('Current (pA)')
    hold on
end

%% Callback functions for interactive components
    function listbox1_Callback(hObject, eventdata, handles)
        %clear current axes, plot selected sweep
        index_selected = get(hObject,'Value');
        ax(1) = subplot('Position', [.05 0.25 0.65 0.72]);
        hold off
        plot(di.ts{index_selected},di.V{index_selected});
        ylabel('Voltage (mV)')
        title(getFileName(di))
        ax(2) = subplot('Position', [.05 0.05 0.65 0.15]);
        hold off
        plot(di.ts{index_selected},di.I{index_selected});
        xlabel('Time (s)')
        ylabel('Current (pA)')
    end

    function listbox2_Callback(hObject, eventdata, handles)
        %clear current axes, plot all sweeps in selected file
        index = get(hObject, 'Value');
        visualize(d, figNum, min(index));
    end

    function pushButton0_Callback(hObject, eventdata, handles)
        %find and plot spikes in current sweep; 1st sweep default
%         if (isnan(str2double(get(editBox,'String'))) || isempty(str2double(get(editBox,'String')))) %...
%                && (isnan(str2double(get(editBox2,'String'))) || isempty(str2double(get(editBox2,'String'))))
%             [timeInd, height] = findSpikes(di);
%         elseif isnan(str2double(get(editBox,'String'))) || isempty(str2double(get(editBox,'String')))
%             [timeInd, height] = findSpikes(di, 0, str2double(get(editBox2,'String')));
%         else
%             [timeInd, height] = findSpikes(di, str2double(get(editBox,'String')), str2double(get(editBox2,'String')));
%         end
        if isnan(str2double(get(editBox,'String'))) || isempty(str2double(get(editBox,'String')))
            [timeInd, height] = findSpikes(di);
        else
            [timeInd, height] = findSpikes(di, str2double(get(editBox,'String')));
        end
        
        if ~all(cellfun(@isempty,timeInd))
            ax(1) = subplot('Position', [.05 0.25 0.65 0.72]);
            hold on
            plot(di.ts{index_selected}(timeInd{index_selected}), height{index_selected},'b*')
            ylabel('Voltage (mV)')
        end
    end

    function pushButton1_Callback(hObject, eventdata, handles)
        %remove spikes from currently plotted sweep; 1st sweep default
%         if (isnan(str2double(get(editBox,'String'))) || isempty(str2double(get(editBox, 'String')))) ...
%                 && (isnan(str2double(get(editBox2,'String'))) || isempty(str2double(get(editBox2,'String'))))
%             V2 = removeSpikes(di);
%         elseif isnan(str2double(get(editBox,'String'))) || isempty(str2double(get(editBox,'String')))
%             V2 = removeSpikes(di, 0, str2double(get(editBox2, 'String')));
%         else
%             V2 = removeSpikes(di, str2double(get(editBox,'String')), str2double(get(editBox2,'String')));
%         end
        if isnan(str2double(get(editBox,'String'))) || isempty(str2double(get(editBox, 'String')))
            V2 = removeSpikes(di);
        else
            V2 = removeSpikes(di, str2double(get(editBox, 'String')));
        end
        
        ax(1) = subplot('Position', [.05 0.25 0.65 0.72]);
        xs = xlim;
        ys = ylim;
        hold off
        plot(di.ts{index_selected}, V2(index_selected,:))
        ylabel('Voltage (mV)')
        xlim(xs);
        ylim(ys);
    end

    function pushButton2_Callback(hObject, eventdata, handles)
        %plot spike adaptation for current sweep; 1st sweep default
%         if (isnan(str2double(get(editBox,'String'))) || isempty(str2double(get(editBox, 'String')))) ...
%                 && (isnan(str2double(get(editBox2,'String'))) || isempty(str2double(get(editBox2,'String'))))
%             [out, freq] = spikeAdaptation(di);
%         elseif isnan(str2double(get(editBox,'String'))) || isempty(str2double(get(editBox,'String')))
%             [out, freq] = spikeAdaptation(di, 0, str2double(get(editBox2,'String')));
%         else
%             [out, freq] = spikeAdaptation(di, str2double(get(editBox,'String')), str2double(get(editBox2,'String')));
%         end
        if isnan(str2double(get(editBox,'String'))) || isempty(str2double(get(editBox,'String')))
            [out, freq] = spikeAdaptation(di);
        else
            [out, freq] = spikeAdaptation(di, str2double(get(editBox,'String')));
        end
        
        if ~isempty(freq{index_selected})
            figure()
            plot(out(index_selected).time, freq{index_selected}, 'bo')
            hold on
            plot(out(index_selected).time, out(index_selected).fitted, 'b')
            xlabel('Time (s)')
            ylabel('Frequency (Hz)')
            s = sprintf('Spike Adaptation at %d pA', round(out(index_selected).current));
            title(s)
        else
            fprintf('There are no spikes in this sweep\n');
        end
    end
        

    function pushButton3_Callback(hObject, eventdata, handles)
        %calculate impedance and peak frequency 
        [t, V, faxis, imp_curve, Y] = InVitroSTD.Analyze.Chirp2(di.I{index_selected},di.V{index_selected},di.ts{index_selected},0);
        [pk, time] = findpeaks(Y);
        %plot impedence for selected sweep
        figure()
        plot(faxis, imp_curve, 'b')
        hold on
        %plot fitted curve
        plot(faxis, Y, 'r')
        hold on
        %plot peak impedance
        if ~isempty(pk)
            plot(faxis(time(1)), pk(1), 'go', 'LineWidth', 2)
            s = sprintf('F = %.2f Hz; Q = %.2f', round(faxis(time(1)),2), pk(1) / Y(1));
            legend(s);
        else
            legend('No Resonance Frequency Found');           
        end
        title('Impedance')
        xlabel('Frequency (Hz)')
        ylabel('Impedance (G\Omega)')
    end

    function pushButton4_Callback(hObject, eventdata, handles)
        %calculate and plot sag and all negative current injections
        if isnan(str2double(get(editBox,'String'))) || isempty(str2double(get(editBox,'String')))
            res = InVitroSTD.Analyze.sag(di);
        else
            res = InVitroSTD.Analyze.sag(di, str2double(get(editBox,'String')));
        end
        [current, ~, ~, ~, ~] = IVcurve(di);
        
        %plotting
        figure()
        subplot(2,1,1)
        plot(res(2:end,1), res(2:end,4), 'b*-')
        xlabel('Current (pA)')
        ylabel('Sag Ratio')
        subplot(2,1,2)
        for j = 1:length(current(current < 0))
            plot(di.ts{j}, di.V{j})
            hold on
        end
        xlabel('Time (s)')
        ylabel('Change in Membrande Potential (mV)')
    end

    function pushButton5_Callback(hObject, eventdata, handles)
        %Calculate and plot FI curve
%         if (isnan(str2double(get(editBox,'String'))) || isempty(str2double(get(editBox, 'String')))) ...
%                 && (isnan(str2double(get(editBox2,'String'))) || isempty(str2double(get(editBox2,'String'))))
%             [current, freq] = FI(di);
%         elseif isnan(str2double(get(editBox,'String'))) || isempty(str2double(get(editBox,'String')))
%             [current, freq] = FI(di, 0, str2double(get(editBox2, 'String')));
%         else
%             [current, freq] = FI(di, str2double(get(editBox,'String')), str2double(get(editBox2,'String')));
%         end
        if isnan(str2double(get(editBox,'String'))) || isempty(str2double(get(editBox,'String')))
            [current, freq] = FI(di);
        else
            [current, freq] = FI(di,str2double(get(editBox,'String')));
        end
        
        figure()
        plot(current, freq, 'b*-')
        xlabel('Current (pA)')
        ylabel('Frequency (spikes/sec)')
        title('F-I Curve')
    end

    function pushButton6_Callback(hObject, eventdata, handles)
        %calculate and plot IV curves
        [current, voltage, fit, res, rsq] = IVcurve(di);
        figure()
        plot(current(current < 0), voltage(current < 0), 'bo')
        hold on
        p1 = plot(current(current < 0), fit(current < 0), 'b');
        s = sprintf('R = %.2d GOhm; R^2 = %.3d', res, rsq);
        legend(p1, s)
        xlabel('Current (pA)')
        ylabel('Membrane Potential (mV)')
        title('I-V Curve')
    end

    function pushButton7_Callback(hObject, eventdata, handles)
        %calculate and plot average resting membrane potential vs time
        [time, avg] = restingPotential(di);
        if length(time) == 5 || length(time) == 10
            figure()
            plot(time, avg, 'b*-')
            xlabel('Time (min)')
            ylabel('Resting Membrane Potential (mV)')
        else
            figure()
            plot(time ./ 60, avg, 'b*-')
            xlabel('Time (min)')
            ylabel('Resting Membrane Potential (mV)')
        end       
    end

    function pushButton8_Callback(hObject, eventdata, handles)
        %Try calculating AHP/ADP        
%         if isnan(str2double(get(editBox,'String'))) || isempty(str2double(get(editBox,'String')))
%             out = AHP(di);
%         else
%             out = AHP(di, str2double(get(editBox,'String')));
%         end
        if isnan(str2double(get(editBox,'String'))) || isempty(str2double(get(editBox,'String')))
            out = AHP(di);
        else
            out = AHP(di, str2double(get(editBox,'String')));
        end
                
        %If there are any, plot
        if sum(~isnan(out))
            [current, ~, ~, ~, ~] = IVcurve(di);
            current = current(~isnan(out));
            out = out(~isnan(out));
            figure()
            plot(current, out, 'b*-')
            xlabel('Current (pA)')
            ylabel('AHP/ADP (mV*s)')
        else
            fprintf('There are no AHP/ADPs in this recording.\n')
        end
    end

    function pushButton9_Callback(hObject, eventdata, handles)
        [avg, time] = rmpVar(di);
        figure()
        if length(time) == 5 || length(time) == 10
            plot(time, avg, 'b*-')
        else
            plot(time./60, avg, 'b*-')
        end
        xlabel('Time (min)')
        ylabel('Membrane Potential Variance')
    end

    function pushButton10_Callback(hObject, eventdata, handles)
        if isnan(str2double(get(editBox,'String'))) || isempty(str2double(get(editBox,'String')))
            [current, heights] = spikeHeights(di);
        else
            [current, heights] = spikeHeights(di, str2double(get(editBox,'String')));
        end
        
        figure()
        plot(current, heights, 'b*-')
        xlabel('Current (pA)')
        ylabel('Average Spike Height (mV)')
    end

    function out = getFileName(self)
        %out is a "human readable" string containing the file's name
        s = fliplr(self.fname);
        C = strsplit(s,'.');
        D = strsplit(C{2},'/');
        out = fliplr(D{1});
        out = strrep(out, '_', '-');
    end

end