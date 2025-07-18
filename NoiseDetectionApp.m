classdef NoiseDetectionApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = private)
        UIFigure          matlab.ui.Figure
        RecordButton      matlab.ui.control.Button
        LoadButton        matlab.ui.control.Button
        StatusLabel       matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: RecordButton
        function RecordButtonPushed(app, ~)
            duration = inputdlg('Enter recording duration (seconds):', 'Recording Duration');
            if isempty(duration) || ~isnumeric(str2double(duration{1}))
                disp('Invalid duration. Recording cancelled.');
                return;
            end
            duration = str2double(duration{1});
            [audioData, fs] = recordAudio(duration);
            noiseDetectionAndSpectrogramCallback(audioData, fs);
        end

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, ~)
            [filename, pathname] = uigetfile({'.wav;.mp3;.flac', 'Supported Audio Files (.wav,.mp3,.flac)'});
            if filename ~= 0
                % Read audio data
                [audioData, fs] = audioread(fullfile(pathname, filename));
                disp(['Loaded audio file: ', filename]);
                noiseDetectionAndSpectrogramCallback(audioData, fs);
            else
                disp('No file selected.');
                return;
            end
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)
            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 250 200];
            app.UIFigure.Name = 'Noise Detection App';

            % Create RecordButton
            app.RecordButton = uibutton(app.UIFigure, 'push');
            app.RecordButton.ButtonPushedFcn = createCallbackFcn(app, @RecordButtonPushed, true);
            app.RecordButton.Position = [50 120 150 22];
            app.RecordButton.Text = 'Record';

            % Create LoadButton
            app.LoadButton = uibutton(app.UIFigure, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.Position = [50 80 150 22];
            app.LoadButton.Text = 'Load Audio';

            % Create StatusLabel
            app.StatusLabel = uilabel(app.UIFigure);
            app.StatusLabel.HorizontalAlignment = 'center';
            app.StatusLabel.Position = [50 160 150 22];
            app.StatusLabel.Text = 'Ready';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = NoiseDetectionApp
            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end

function [audioData, fs] = recordAudio(duration)
    % Function to record audio with user-specified duration

    % Create audio recorder object
    recorder = audiorecorder(44100, 16, 1);

    % Record audio
    disp('Start speaking...');
    recordblocking(recorder, duration);
    disp('Recording finished.');

    % Get recorded audio data
    audioData = getaudiodata(recorder);
    fs = recorder.SampleRate;
end 

function noiseDetectionAndSpectrogramCallback(audioData, fs)
    % Define parameters for noise detection
    threshold = 0.1;  % Adjust as needed

    % Calculate the standard deviation of the signal
    signal_std = std(audioData);

    % Perform noise detection
    if signal_std > threshold
        disp('Signal contains noise.');
    else
        disp('Signal is noise-free.');
    end

    % Plot the spectrogram
    figure;
    spectrogram(audioData, hamming(1024), 512, 1024, fs, 'yaxis');
    title('Spectrogram');
end