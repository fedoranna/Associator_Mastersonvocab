function [P, D] = phoneticsgenerator_phonpheat(P, D)

%% Generates a phonology part of vocabulary as in Thomas & AKS, 2003

% Uses the same phonological feature based phoneme representtaions as ThomasAKS2003
% but words can be as long as you want: P.wordlength
% There are no CV patterns

%% Phonetic representation

% 42 phonemes= 24 consonants + 18 vowels

P.phonemes={ 
    '/p/'   ;   '/b/'   ;    '/m/'   ;    '/f/'   ;    '/v/'   ;    '/8/'  ;   '/5/'   ;
    '/sh/'  ;   '/3/'   ;    '/t/'   ;    '/d/'   ;    '/n/'   ;    '/s/'  ;   '/z/'   ;
    '/ch/'  ;   '/d3/'  ;    '/k/'   ;    '/g/'   ;    '/n¬/'  ;    '/h/'  ;   '/l/'   ;
    '/r/'   ;   '/j/'   ;    '/w/'   ;    '/i/'   ;    '/e/'   ;    '/u/'  ;   '/o/'   ;
    '/ae/'  ;   '/^/'   ;    '/aj/'  ;    '/oi/'  ;    '/I/'   ;    '/E/'  ;   '/U/'   ;
    '/O/'   ;   '/au/'  ;    '/o-/'  ;    '/a:/'  ;    '/u8/'  ;    '/E8/' ;   '/&/'   };

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                19 Features
%_Fromkin & Rodman: An introduction to language_______________________________
%| 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10| 11| 12| 13| 14| 15| 16| 17| 18| 19|
%----------------------------------------------------------------------------
%| s | c | s | c | v | l | a | + | b | s | n | l | - | h | c | l | r | t | d |
%| o | o | y | o | o | a | n | c | a | t | a | a | c | i | e | o | o | e | i |
%| r | n | l | n | i | b | t | o | c | r | s | t | o | g | n | w | u | n | p |
%| o | s | l | t | c | i | e | r | k | i | a | e | r | h | t |   | n | s | t |
%| n | o | a | i | e | a | r | o |   | d | l | r | o |   | r |   | d | e | h |
%| a | n | b | n | d | l | i | n |   | e |   | a | n |   | a |   | e |   | o |
%| n | a | i | u |   |   | o | a |   | n |   | l | a |   | l |   | d |   | n |
%| t | n | c | a |   |   | r | l |   | t |   |   | l |   |   |   |   |   | g |
%|   | t |   | n |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
%|   | a |   | t |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
%|   | l |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
%-----------------------------------------------------------------------------
% * = these phonemes are the Plunkett & Marchman 1991 phoneme set

consonants = [
    0   1   0   0   0   1   1   0   0   0   0   0   0   0   0   0   0   0   0 ;   % 1; '/p/'  spill    *
    
    0   1   0   0   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0 ;   % 2; '/b/'  bill     *
    
    1   1   0   0   1   1   1   0   0   0   1   0   0   0   0   0   0   0   0 ;   % 3; '/m/'  mill     *
    
    0   1   0   1   0   1   1   0   0   1   0   0   0   0   0   0   0   0   0 ;   % 4; '/f/'  feel     *
    
    0   1   0   1   1   1   1   0   0   1   0   0   0   0   0   0   0   0   0 ;   % 5; '/v/'  veal     *
    
    0   1   0   1   0   0   1   0   0   0   0   0   0   0   0   0   0   0   0 ;   % 6; '/8/'  thigh    *
    
    0   1   0   1   1   0   1   0   0   0   0   0   0   0   0   0   0   0   0 ;   % 7; '/5/'  thy      *
    
    0   1   0   1   0   0   1   0   0   1   0   0   1   1   0   0   0   0   0 ;   % 8; '/sh/' shop
    
    0   1   0   1   1   0   1   0   0   1   0   0   1   1   0   0   0   0   0 ;   % 9; '/3/'  measure
    
    0   1   0   0   0   0   1   1   0   0   0   0   0   0   0   0   0   0   0 ;   % 10; '/t/'  still    *
    
    0   1   0   0   1   0   1   1   0   0   0   0   0   0   0   0   0   0   0 ;   % 11; '/d/'  dill     *
    
    1   1   0   0   1   0   1   1   0   0   1   0   0   0   0   0   0   0   0 ;   % 12; '/n/'  nil      *
    
    0   1   0   1   0   0   1   1   0   1   0   0   0   0   0   0   0   0   0 ;   % 13; '/s/'  seal     *
    
    0   1   0   1   1   0   1   1   0   1   0   0   0   0   0   0   0   0   0 ;   % 14; '/z/'  zeal     *
    
    0   1   0   0   0   0   1   1   0   1   0   0   0   0   0   0   0   0   0 ;   % 15; '/ch/' church
    
    0   1   0   0   1   0   1   1   0   1   0   0   0   0   0   0   0   0   0 ;   % 16; '/d3/' June
    
    0   1   0   0   0   0   0   0   1   0   0   0   0   0   0   0   0   0   0 ;   % 17; '/k/'  skill    *
    
    0   1   0   0   1   0   0   0   1   0   0   0   0   0   0   0   0   0   0 ;   % 18; '/g/'  gill     *
    
    1   1   0   0   1   0   0   0   1   0   1   0   0   0   0   0   0   0   0 ;   % 19; '/n¬/' ring     *
    
    1   1   0   1   0   0   0   0   1   0   0   0   0   0   0   0   0   0   0 ;   % 20; '/h/'  high     *
    
    1   1   0   1   1   0   1   1   0   0   0   1   1   0   0   0   0   0   0 ;   % 21; '/l/'  leaf     *
    
    1   0   0   1   1   0   1   1   0   0   0   0   0   0   0   0   0   0   0 ;   % 22; '/r/'  reef     *
    
    1   1   0   1   1   0   0   1   0   0   0   0   1   0   0   0   0   0   0 ;   % 23; '/j/'  you      *
    
    1   0   0   1   1   1   0   0   1   0   0   0   0   0   0   0   0   0   0 ;   % 24; '/w/'  witch    *
    ];

vowels = [
    1   0   1   1   1   0   1   0   0   0   0   0   1   1   0   0   0   1   0 ;   % 1; '/i/' beet      *
    
    1   0   1   1   1   0   1   0   0   0   0   0   1   0   1   0   0   1   1 ;   % 2; '/e/' bait      *
    
    1   0   1   1   1   0   0   0   1   0   0   0   0   1   0   0   1   1   1 ;   % 3; '/u/' boot      *
    
    1   0   1   1   1   0   0   0   1   0   0   0   0   0   1   0   1   1   1 ;   % 4; '/o/' boat      *
    
    1   0   1   1   1   0   1   0   0   0   0   0   1   0   0   1   0   0   0 ;   % 5; '/ae/' bat      *
    
    1   0   1   1   1   0   0   0   0   0   0   0   0   0   0   1   0   0   0 ;   % 6; '/^/'  but      *
    
    1   0   1   1   1   0   0   0   0   0   0   0   0   0   0   1   0   0   1 ;   % 7; '/aj/' bite     *
    
    1   0   1   1   1   0   0   0   0   0   0   0   0   0   1   0   1   1   1 ;   % 8; '/oi/' boy
    
    1   0   1   1   1   0   1   0   0   0   0   0   0   0   0   0   0   0   0 ;   % 9; '/I/'  bit      * central changed
    
    1   0   1   1   1   0   1   0   0   0   0   0   0   0   1   0   0   0   0 ;   % 10; '/E/'  bet      *
    
    1   0   1   1   1   0   0   0   1   0   0   0   0   1   1   0   1   0   0 ;   % 11; '/U/' foot      *
    
    1   0   1   1   1   0   0   0   1   0   0   0   0   0   1   0   1   0   0 ;   % 12; '/O/' bought/or *
    
    1   0   1   1   1   0   0   0   1   0   0   0   0   0   0   1   1   0   1 ;   % 13; '/au/' bout/cow *
    
    1   0   1   1   1   0   0   0   0   0   0   0   0   0   0   1   1   0   0;    % 14; '/o-/' dog
    
    1   0   1   1   1   0   0   0   0   0   0   0   0   0   0   1   0   0   0;    % 15; '/a:/' bath
    
    1   0   1   1   1   0   0   0   0   0   0   0   0   1   0   0   1   1   1;    % 16; '/u8/' tour
    
    1   0   1   1   1   0   0   0   0   0   0   0   0   0   1   0   0   1   1;    % 17; '/E8/' hair
    
    1   0   1   1   1   0   0   0   0   0   0   0   0   0   1   0   0   0   0     % 18; '/&/'  about
    
    ];

%% Randomly generate forms

wordlength = P.wordlength;

phonemes = [consonants; vowels];
nbof_phonemes = nrows(phonemes);
nbof_phonfeat = ncols(consonants);

patterns = NaN(0, wordlength);
while nrows(patterns) < P.vocabsize
    
    newword = NaN(1, wordlength);
    for i = 1:wordlength
        newword(i) = randchoose(1:nbof_phonemes, 1);
    end
    patterns = [patterns; newword];
    patterns = unique(patterns, 'rows');
    
end

%% Code phonological neighbourhood

phon_closeness = NaN(P.vocabsize, P.vocabsize);
for i = 1:P.vocabsize
    for j = 1:P.vocabsize
        phon_closeness(i,j) = nbof_commonelements(patterns(i,:), patterns(j,:));
        if i == j
            phon_closeness(i,j) = NaN;
        end
    end
end

neighbours = NaN(P.vocabsize, wordlength +1);
for i = 1:P.vocabsize
    for j = 0:wordlength
        neighbours(i, j+1) = sum(phon_closeness(i,:)==j);
    end
end

%% Create forms

forms = NaN(P.vocabsize, nbof_phonfeat*wordlength);
for i = 1:P.vocabsize
    
    form = [];
    for j = 1:wordlength
        form = [form, phonemes(patterns(i,j), :)];
    end            
    forms(i,:) = form;
    
end

%% Save

P.Psize = ncols(forms);
D.testingphons = forms;
P.patterns = patterns;
P.phon_neighbours = neighbours;
P.Pact_avg = mean(sum(D.testingphons, 2));

