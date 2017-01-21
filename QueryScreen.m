clear all;

try
    % setup up diary
    OutDir = fullfile(pwd, 'QueryScanner');
    mkdir(OutDir);
    OutFile = fullfile(OutDir, 'QueryScreenDiary.txt');
    if exist(OutFile, 'file') == 2
        delete(OutFile);
    end
    diary(OutFile);
    
    % hide intro screens
    Screen('Preference', 'VisualDebugLevel', 3);
    
    % enter default setup
    PsychDefaultSetup(2);

    % screen initialization and refresh
    Screens = Screen('Screens'); % get scren number
    ScreenNumber = max(Screens);
    [Window, Rect] = PsychImaging('OpenWindow', ScreenNumber, [0 0 0]);
    Screen('ColorRange', Window, 1, [], 1);
    PriorityLevel = MaxPriority(Window);
    Priority(PriorityLevel);
    [XCenter, YCenter] = RectCenter(Rect);
    [Refresh] = Screen('GetFlipInterval', Window);
    
    % Define commonly used colors
    White = WhiteIndex(ScreenNumber);
    Black = BlackIndex(ScreenNumber);
    Gray = White * 0.5;
    BgColor = [45 59 55] * 1/255;
    UnfilledColor = [38 41 26] * 1/255;
    BoxColor = [21 32 17] * 1/255;
    FilledColor = [41 249 64] * 1/255;
    Screen('FillRect', Window, BgColor);

    % set up text properties
    Screen('TextFont', Window, 'Arial');
    Screen('TextSize', Window, 50);
    Screen('TextColor', Window, [1 1 1]);
    Screen('FillRect', Window, BgColor);

    % now draw on screen
    Until = 0;
    for i = [3 2 1]
        OutText = ['No problems with screen detected.\n' ...
                   'This will close in ' num2str(i) ' seconds.\n'];
        DrawFormattedText(Window, OutText, 'center', 'center');
        Vbl = Screen('Flip', Window, Until);
        Until = Vbl + 1 - Refresh * 0.5;
    end
    WaitSecs('UntilTime', Until);

    % print diagnostic file
    Outfile = fullfile(OutDir, 'QueryScreen.txt');
    Fid = fopen(Outfile, 'w');
    fprintf(Fid, 'No problems detected with screen.\n');
    fclose(Fid);

    % now close everything
    ShowCursor;
    sca;
    ListenChar(0);
    Priority(0);
catch err
    fclose('all');
    ShowCursor;
    sca;
    ListenChar(0);
    Priority(0);
    diary off

    % print diagnostic file
    OutDir = fullfile(pwd, 'QueryScanner');
    mkdir(OutDir);
    Outfile = fullfile(OutDir, 'QueryScreen.txt');
    Fid = fopen(Outfile, 'w');
    fprintf(Fid, 'There were problems with screen.\n');
    fprintf(Fid, 'ERROR:    %s\n', err.message);
    fclose(Fid);

    rethrow(err);
end


               
