function createGUI()
    % Create a figure window
    fig = figure('Position', [100, 100, 400, 500], 'MenuBar', 'none', 'ToolBar', 'none');
    
    % Button labels and callbacks
    buttonLabels = {'Obtaining the Signal', 'Detecting Anomalies', ...
                    'Normalization of Amplitude', 'Noise Detection & Spectrogram Analysis', 'OpenFeatureExtractorApp', ...
                    'Audio Analyzing'};
    buttonCallbacks = {@obtainSignalCallback, @detectAnomaliesCallback, ...
                        @normalizeAmplitudeCallback, @noiseDetectionAndSpectrogramCallback,@OpenFeatureExtractorAppBtnPushed, ...
                      @audioanalyzingBtnPushed};

    % Create buttons
    buttonHeight = 30;
    buttonWidth = 300;
    buttonSpacing = 10;
    numButtons = numel(buttonLabels);
    for i = 1:numButtons
        yPos = 480 - i * (buttonHeight + buttonSpacing);
        btn = uicontrol('Style', 'pushbutton', 'String', buttonLabels{i}, ...
            'Position', [50, yPos, buttonWidth, buttonHeight], 'Callback', buttonCallbacks{i});
    end
end