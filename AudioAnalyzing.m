classdef AudioAnalyzing < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = private)
        UIFigure         matlab.ui.Figure
        RecordButton     matlab.ui.control.Button
        LoadButton       matlab.ui.control.Button
        SpectrogramAxes  matlab.ui.control.UIAxes
        Fs               double   % Sampling frequency
        AudioData        double   % Loaded audio data
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: RecordButton
function RecordButtonPushed(app, ~)
    % Specify the recording parameters
    recordDuration = 5; % Duration of the recording in seconds
    Fs = 44100; % Sampling frequency

    % Create an audiorecorder object
    recorder = audiorecorder(Fs, 16, 1); % Mono recording with 16-bit resolution

    % Start recording
    disp('Recording started...');
    recordblocking(recorder, recordDuration); % Block execution until recording is complete
    disp('Recording stopped.');

    % Retrieve the recorded audio data
    app.AudioData = getaudiodata(recorder);

    % Plot the spectrogram
    plotSpectrogram(app);
end
        % Button pushed function: LoadButton
        function LoadButtonPushed(app, ~)
            [file, path] = uigetfile({'*.wav'; '*.mp3'}, 'Select Audio File');
            if file ~= 0
                % Load audio file
                [audioData, Fs] = audioread(fullfile(path, file));

                % Ensure audioData is a column vector
                if size(audioData, 2) > 1
                    % Take the first channel if it's a stereo audio
                    audioData = audioData(:, 1);
                end

                % Store the loaded audio data and sampling frequency in app properties
                app.AudioData = audioData;
                app.Fs = Fs;

                % Plot spectrogram
                plotSpectrogram(app);
            end
        end

        % Function to plot the spectrogram
        function plotSpectrogram(app)
            % Parameters for STFT
            window_length = 1024; % Length of the window for STFT analysis
            overlap = 512; % Overlap between consecutive windows

            % Perform STFT
            [S, F, T] = spectrogram(app.AudioData, hamming(window_length), overlap, window_length, app.Fs);

            % Plot the spectrogram
            imagesc(app.SpectrogramAxes, T, F, 10*log10(abs(S)));
            axis(app.SpectrogramAxes, 'xy');
            xlabel(app.SpectrogramAxes, 'Time (s)');
            ylabel(app.SpectrogramAxes, 'Frequency (Hz)');
            title(app.SpectrogramAxes, 'Spectrogram');
            colorbar(app.SpectrogramAxes);
        end

    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)
            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'Audio Analyzer';

            % Create RecordButton
            app.RecordButton = uibutton(app.UIFigure, 'push');
            app.RecordButton.ButtonPushedFcn = createCallbackFcn(app, @RecordButtonPushed, true);
            app.RecordButton.Position = [50 420 100 22];
            app.RecordButton.Text = 'Record';

            % Create LoadButton
            app.LoadButton = uibutton(app.UIFigure, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.Position = [200 420 100 22];
            app.LoadButton.Text = 'Load File';

            % Create SpectrogramAxes
            app.SpectrogramAxes = uiaxes(app.UIFigure);
            title(app.SpectrogramAxes, 'Spectrogram')
            xlabel(app.SpectrogramAxes, 'Time (s)')
            ylabel(app.SpectrogramAxes, 'Frequency (Hz)')
            app.SpectrogramAxes.Position = [50 100 540 300];
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = AudioAnalyzing
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
