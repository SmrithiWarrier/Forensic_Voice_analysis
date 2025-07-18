function obtainSignalCallback(~, ~)
    % Function to record or load audio, process with user-specified sampling frequency,
    % and plot the resulting audio data

    % Ask user for recording or loading
    choice = questdlg('Record audio or Load a file?', 'Audio Input', 'Record', 'Load', 'Record');

    if strcmp(choice, 'Record')
        % Record audio
        [audioData, originalFs] = recordAudio();
    elseif strcmp(choice, 'Load')
        % Load audio file
        [filename, pathname] = uigetfile({'*.wav;*.mp3;*.flac', 'Supported Audio Files (*.wav,*.mp3,*.flac)'});
        if filename ~= 0
            % Read audio data
            [audioData, originalFs] = audioread(fullfile(pathname, filename));
            disp(['Loaded audio file: ', filename]);
        else
            disp('No file selected.');
            return;
        end
    else
        disp('Cancelled.');
        return;
    end

    % Process audio with user-specified sampling frequency
    desiredFs = inputdlg('Enter desired sampling frequency (Hz):', 'Sampling Frequency');
    if isempty(desiredFs) || ~isnumeric(str2double(desiredFs{1}))
        disp('Invalid sampling frequency. Using original frequency.');
        desiredFs = originalFs;
    else
        desiredFs = str2double(desiredFs{1});

        % Check for potential aliasing
        if desiredFs < originalFs/2
            disp(['Warning: Desired sampling frequency ', num2str(desiredFs), ...
                ' Hz is lower than half of the original frequency ', ...
                num2str(originalFs/2), ' Hz.']);
            disp('Aliasing might occur. Consider resampling at a higher frequency.');
        else
            disp('Desired sampling frequency is sufficient to avoid aliasing.');
        end

        % Resample audio (if desiredFs is different from originalFs)
        if desiredFs ~= originalFs
            audioData = resample(audioData, desiredFs, originalFs);
            disp('Audio resampled to desired frequency.');
        end
    end

    % Plot the audio data in a new figure window
    figure;
    t = (0:length(audioData)-1)/desiredFs; % Create time vector
    plot(t, audioData);
    xlabel('Time (seconds)');
    ylabel('Amplitude');
    title('Sampled Audio Data');
    grid on;
    disp('Audio data plotted.');
end

function [audioData, originalFs] = recordAudio()
    % Function to record audio with user-specified duration

    % Prompt user for recording duration
    duration = inputdlg('Enter recording duration (seconds):', 'Recording Duration');
    if isempty(duration) || ~isnumeric(str2double(duration{1}))
        disp('Invalid duration. Recording cancelled.');
        return;
    end
    duration = str2double(duration{1});

    % Create audio recorder object
    recorder = audiorecorder(44100, 16, 1);

    % Record audio
    disp('Start speaking...');
    recordblocking(recorder, duration);
    disp('Recording finished.');

    % Get recorded audio data
    audioData = getaudiodata(recorder);
    originalFs = recorder.SampleRate;
end