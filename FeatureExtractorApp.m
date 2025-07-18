classdef FeatureExtractorApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = private)
        UIFigure              matlab.ui.Figure
        LoadButton            matlab.ui.control.Button
        SpectralCentroidBtn   matlab.ui.control.Button
        BandwidthBtn          matlab.ui.control.Button
        FlatnessBtn           matlab.ui.control.Button
        MeanBtn               matlab.ui.control.Button
        StdDevBtn             matlab.ui.control.Button
        SkewnessBtn           matlab.ui.control.Button
        KurtosisBtn           matlab.ui.control.Button
        ZCRBtn                matlab.ui.control.Button
        EnergyBtn             matlab.ui.control.Button
        TempoBtn              matlab.ui.control.Button
        ResultsTextArea       matlab.ui.control.TextArea
        
        % Add properties for audio data and sampling frequency
        AudioData             double
        Fs                    double
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, ~)
            % Allow user to select an audio file
            [file, path] = uigetfile({'*.wav'; '*.mp3'}, 'Select Audio File');
            if isequal(file, 0)
                % User canceled selection
                return;
            end
            
            % Read audio file
            [audioData, fs] = audioread(fullfile(path, file));
            % Store audio data and sampling frequency
            app.AudioData = audioData;
            app.Fs = fs;
            
            % Update UI
            app.ResultsTextArea.Value = ['Audio file ', file, ' loaded.'];
        end

        % Button pushed function: SpectralCentroidBtn
        function SpectralCentroidBtnPushed(app, ~)
            if isempty(app.AudioData) || isempty(app.Fs)
                % Audio data not loaded
                app.ResultsTextArea.Value = 'No audio data loaded. Please load an audio file first.';
                return;
            end
            
            % Calculate spectral centroid
            spectral_centroid = spectralCentroid(app.AudioData, app.Fs);
            app.ResultsTextArea.Value = ['Spectral Centroid: ', num2str(spectral_centroid)];
        end
        
        % Button pushed function: BandwidthBtn
        function BandwidthBtnPushed(app, ~)
            if isempty(app.AudioData) || isempty(app.Fs)
                % Audio data not loaded
                app.ResultsTextArea.Value = 'No audio data loaded. Please load an audio file first.';
                return;
            end
            
            % Calculate bandwidth
            bandwidth = spectralBandwidth(app.AudioData, app.Fs);
            app.ResultsTextArea.Value = ['Bandwidth: ', num2str(bandwidth)];
        end
        
        % Button pushed function: FlatnessBtn
        function FlatnessBtnPushed(app, ~)
            if isempty(app.AudioData)
                % Audio data not loaded
                app.ResultsTextArea.Value = 'No audio data loaded. Please load an audio file first.';
                return;
            end
            
            % Calculate flatness
            flatness = spectralFlatness(app.AudioData);
            app.ResultsTextArea.Value = ['Flatness: ', num2str(flatness)];
        end
        
        % Button pushed function: MeanBtn
        function MeanBtnPushed(app, ~)
            if isempty(app.AudioData)
                % Audio data not loaded
                app.ResultsTextArea.Value = 'No audio data loaded. Please load an audio file first.';
                return;
            end
            
            % Calculate mean
            mean_val = mean(app.AudioData);
            app.ResultsTextArea.Value = ['Mean: ', num2str(mean_val)];
        end
        
        % Button pushed function: StdDevBtn
        function StdDevBtnPushed(app, ~)
            if isempty(app.AudioData)
                % Audio data not loaded
                app.ResultsTextArea.Value = 'No audio data loaded. Please load an audio file first.';
                return;
            end
            
            % Calculate standard deviation
            std_val = std(app.AudioData);
            app.ResultsTextArea.Value = ['Standard Deviation: ', num2str(std_val)];
        end
        
        % Button pushed function: SkewnessBtn
        function SkewnessBtnPushed(app, ~)
            if isempty(app.AudioData)
                % Audio data not loaded
                app.ResultsTextArea.Value = 'No audio data loaded. Please load an audio file first.';
                return;
            end
            
            % Calculate skewness
            skewness_val = skewness(app.AudioData);
            app.ResultsTextArea.Value = ['Skewness: ', num2str(skewness_val)];
        end
        
        % Button pushed function: KurtosisBtn
        function KurtosisBtnPushed(app, ~)
            if isempty(app.AudioData)
                % Audio data not loaded
                app.ResultsTextArea.Value = 'No audio data loaded. Please load an audio file first.';
                return;
            end
            
            % Calculate kurtosis
            kurtosis_val = kurtosis(app.AudioData);
            app.ResultsTextArea.Value = ['Kurtosis: ', num2str(kurtosis_val)];
        end
        
        % Button pushed function: ZCRBtn
        function ZCRBtnPushed(app, ~)
            if isempty(app.AudioData)
                % Audio data not loaded
                app.ResultsTextArea.Value = 'No audio data loaded. Please load an audio file first.';
                return;
            end
            
            % Calculate zero-crossing rate
            zero_crossing_rate = zcr(app.AudioData);
            app.ResultsTextArea.Value = ['Zero-Crossing Rate: ', num2str(zero_crossing_rate)];
        end
        
        % Button pushed function: EnergyBtn
        function EnergyBtnPushed(app, ~)
            if isempty(app.AudioData)
                % Audio data not loaded
                app.ResultsTextArea.Value = 'No audio data loaded. Please load an audio file first.';
                return;
            end
            
            % Calculate energy
            energy = sum(app.AudioData.^2);
            app.ResultsTextArea.Value = ['Energy: ', num2str(energy)];
        end
        
        % Button pushed function: TempoBtn
        function TempoBtnPushed(app, ~)
            if isempty(app.AudioData) || isempty(app.Fs)
                % Audio data not loaded
                app.ResultsTextArea.Value = 'No audio data loaded. Please load an audio file first.';
                return;
            end
            
            % Estimate tempo
            tempo = estimateTempo(app.AudioData, app.Fs);
            app.ResultsTextArea.Value = ['Tempo: ', num2str(tempo)];
        end

    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)
            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 400 500];
            app.UIFigure.Name = 'Feature Extractor';

            % Create LoadButton
            app.LoadButton = uibutton(app.UIFigure, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.Position = [50 450 150 22];
            app.LoadButton.Text = 'Load Audio File';

            % Create SpectralCentroidBtn
            app.SpectralCentroidBtn = uibutton(app.UIFigure, 'push');
            app.SpectralCentroidBtn.ButtonPushedFcn = createCallbackFcn(app, @SpectralCentroidBtnPushed, true);
            app.SpectralCentroidBtn.Position = [50 420 150 22];
            app.SpectralCentroidBtn.Text = 'Spectral Centroid';

            % Create BandwidthBtn
            app.BandwidthBtn = uibutton(app.UIFigure, 'push');
            app.BandwidthBtn.ButtonPushedFcn = createCallbackFcn(app, @BandwidthBtnPushed, true);
            app.BandwidthBtn.Position = [50 390 150 22];
            app.BandwidthBtn.Text = 'Bandwidth';

            % Create FlatnessBtn
            app.FlatnessBtn = uibutton(app.UIFigure, 'push');
            app.FlatnessBtn.ButtonPushedFcn = createCallbackFcn(app, @FlatnessBtnPushed, true);
            app.FlatnessBtn.Position = [50 360 150 22];
            app.FlatnessBtn.Text = 'Flatness';

            % Create MeanBtn
            app.MeanBtn = uibutton(app.UIFigure, 'push');
            app.MeanBtn.ButtonPushedFcn = createCallbackFcn(app, @MeanBtnPushed, true);
            app.MeanBtn.Position = [50 330 150 22];
            app.MeanBtn.Text = 'Mean';

            % Create StdDevBtn
            app.StdDevBtn = uibutton(app.UIFigure, 'push');
            app.StdDevBtn.ButtonPushedFcn = createCallbackFcn(app, @StdDevBtnPushed, true);
            app.StdDevBtn.Position = [50 300 150 22];
            app.StdDevBtn.Text = 'Standard Deviation';

            % Create SkewnessBtn
            app.SkewnessBtn = uibutton(app.UIFigure, 'push');
            app.SkewnessBtn.ButtonPushedFcn = createCallbackFcn(app, @SkewnessBtnPushed, true);
            app.SkewnessBtn.Position = [50 270 150 22];
            app.SkewnessBtn.Text = 'Skewness';

            % Create KurtosisBtn
            app.KurtosisBtn = uibutton(app.UIFigure, 'push');
            app.KurtosisBtn.ButtonPushedFcn = createCallbackFcn(app, @KurtosisBtnPushed, true);
            app.KurtosisBtn.Position = [50 240 150 22];
            app.KurtosisBtn.Text = 'Kurtosis';

            % Create ZCRBtn
            app.ZCRBtn = uibutton(app.UIFigure, 'push');
            app.ZCRBtn.ButtonPushedFcn = createCallbackFcn(app, @ZCRBtnPushed, true);
            app.ZCRBtn.Position = [50 210 150 22];
            app.ZCRBtn.Text = 'Zero-Crossing Rate';

            % Create EnergyBtn
            app.EnergyBtn = uibutton(app.UIFigure, 'push');
            app.EnergyBtn.ButtonPushedFcn = createCallbackFcn(app, @EnergyBtnPushed, true);
            app.EnergyBtn.Position = [50 180 150 22];
            app.EnergyBtn.Text = 'Energy';

            % Create TempoBtn
            app.TempoBtn = uibutton(app.UIFigure, 'push');
            app.TempoBtn.ButtonPushedFcn = createCallbackFcn(app, @TempoBtnPushed, true);
            app.TempoBtn.Position = [50 150 150 22];
            app.TempoBtn.Text = 'Tempo';

            % Create ResultsTextArea
            app.ResultsTextArea = uitextarea(app.UIFigure);
            app.ResultsTextArea.Position = [220 50 150 400];
            app.ResultsTextArea.Editable = 'off';
            app.ResultsTextArea.Value = '';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = FeatureExtractorApp
            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Show the app window
            app.UIFigure.Visible = 'on';
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end

function centroid = spectralCentroid(y, Fs)
   spec = abs(fft(y));
   freq = linspace(0, Fs/2, length(spec)/2); % Consider only positive frequencies
   spec = spec(1:length(spec)/2); % Keep only positive frequencies
   centroid = sum(freq .* spec) / sum(spec);
end

function bandwidth = spectralBandwidth(y, Fs)
   spec = abs(fft(y));
   freq = linspace(0, Fs/2, length(spec)/2); % Consider only positive frequencies
   spec = spec(1:length(spec)/2); % Keep only positive frequencies
   centroid = sum(freq .* spec) / sum(spec);
   bandwidth = sqrt(sum(((freq - centroid).^2) .* spec) / sum(spec));
end

function flatness = spectralFlatness(y)
   spec = abs(fft(y));
   flatness = exp(mean(log(spec))) / (mean(spec));
end

function zc_rate = zcr(y)
   zc_rate = sum(abs(diff(y > 0))) / (length(y) - 1);
end

function tempo = estimateTempo(y, Fs)
   % This is a very simple and naive tempo estimation method.
   % You may want to use more sophisticated methods for accurate tempo estimation.
   [~, tempo] = beatTrack(y, Fs);
end

function skew = calculateSkewness(data)
   n = length(data);
   mean_data = mean(data);
   std_data = std(data);
   skew = (1/n) * sum(((data - mean_data) / std_data).^3);
end

function kurt = calculateKurtosis(data)
   n = length(data);
   mean_data = mean(data);
   std_data = std(data);
   kurt = (1/n) * sum(((data - mean_data) / std_data).^4) - 3;
end

function [beats, tempo] = beatTrack(y, Fs)
   % Dummy function for tempo estimation
   % You should replace this with a proper tempo estimation algorithm
   beats = [];
   tempo = 120; % Default tempo
end
