function normalizeAmplitudeCallback(~, ~)
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

    % Normalize the signal
    normalized_signal = audioData / max(abs(audioData));

    % Plot the original and normalized signals for comparison
    t = (0:length(audioData)-1) / originalFs;  % Assuming the time axis
    figure;
    subplot(2,1,1);
    plot(t, audioData);
    title('Original Signal');
    xlabel('Time (seconds)');
    ylabel('Amplitude');

    subplot(2,1,2);
    plot(t, normalized_signal);
    title('Normalized Signal');
    xlabel('Time (seconds)');
    ylabel('Amplitude');
end

function [audioData, originalFs] = recordAudio()
    % Function to record audio with user-specified duration

    % Prompt user for recording duration
    prompt = {'Enter recording duration (seconds):'};
    dlgtitle = 'Recording Duration';
    dims = [1 50];
    definput = {'10'}; % Default duration is 10 seconds
    duration = inputdlg(prompt,dlgtitle,dims,definput);

    % Check if the user canceled the input dialog
    if isempty(duration)
        disp('Recording cancelled.');
        audioData = [];
        originalFs = 0;
        return;
    end

    % Convert the duration to a numeric value
    duration = str2double(duration{1});

    % Check if the input is valid
    if isnan(duration) || duration <= 0
        disp('Invalid duration. Recording cancelled.');
        audioData = [];
        originalFs = 0;
        return;
    end

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
