% Thomas and AKS 2003 Phonological encoding

'loading Thomas 2003 phonological encoding...'
% Thomas_AKS_03_Phonological_Encoding

% 24 consonants + 18 vowels    
 Phones={  '/p/'   ;   '/b/'   ;    '/m/'   ;    '/f/'   ;    '/v/'   ;    '/8/'  ;   '/5/'   ;
           '/sh/'  ;   '/3/'   ;    '/t/'   ;    '/d/'   ;    '/n/'   ;    '/s/'  ;   '/z/'   ;   
           '/ch/'  ;   '/d3/'  ;    '/k/'   ;    '/g/'   ;    '/n¬/'  ;    '/h/'  ;   '/l/'   ;
           '/r/'   ;   '/j/'   ;    '/w/'   ;    '/i/'   ;    '/e/'   ;    '/u/'  ;   '/o/'   ;
           '/ae/'  ;   '/^/'   ;    '/aj/'  ;    '/oi/'  ;    '/I/'   ;    '/E/'  ;   '/U/'   ;
           '/O/'   ;   '/au/'  ;    '/o-/'  ;    '/a:/'  ;    '/u8/'  ;    '/E8/' ;   '/&/'   };

Phone_Representations =[
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
   0   1   0   0   0   1   1   0   0   0   0   0   0   0   0   0   0   0   0 ;   % '/p/'  spill    *
   
   0   1   0   0   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0 ;   % '/b/'  bill     *
   
   1   1   0   0   1   1   1   0   0   0   1   0   0   0   0   0   0   0   0 ;   % '/m/'  mill     *
   
   0   1   0   1   0   1   1   0   0   1   0   0   0   0   0   0   0   0   0 ;   % '/f/'  feel     *
      
   0   1   0   1   1   1   1   0   0   1   0   0   0   0   0   0   0   0   0 ;   % '/v/'  veal     *
   
   0   1   0   1   0   0   1   0   0   0   0   0   0   0   0   0   0   0   0 ;   % '/8/'  thigh    *
   
   0   1   0   1   1   0   1   0   0   0   0   0   0   0   0   0   0   0   0 ;   % '/5/'  thy      *
   
   0   1   0   1   0   0   1   0   0   1   0   0   1   1   0   0   0   0   0 ;   % '/sh/' shop
   
   0   1   0   1   1   0   1   0   0   1   0   0   1   1   0   0   0   0   0 ;   % '/3/'  measure
     
   0   1   0   0   0   0   1   1   0   0   0   0   0   0   0   0   0   0   0 ;   % '/t/'  still    *
   
   0   1   0   0   1   0   1   1   0   0   0   0   0   0   0   0   0   0   0 ;   % '/d/'  dill     *
   
   1   1   0   0   1   0   1   1   0   0   1   0   0   0   0   0   0   0   0 ;   % '/n/'  nil      *
   
   0   1   0   1   0   0   1   1   0   1   0   0   0   0   0   0   0   0   0 ;   % '/s/'  seal     *
   
   0   1   0   1   1   0   1   1   0   1   0   0   0   0   0   0   0   0   0 ;   % '/z/'  zeal     *
    
   0   1   0   0   0   0   1   1   0   1   0   0   0   0   0   0   0   0   0 ;   % '/ch/' church
   
   0   1   0   0   1   0   1   1   0   1   0   0   0   0   0   0   0   0   0 ;   % '/d3/' June
     
   0   1   0   0   0   0   0   0   1   0   0   0   0   0   0   0   0   0   0 ;   % '/k/'  skill    *
   
   0   1   0   0   1   0   0   0   1   0   0   0   0   0   0   0   0   0   0 ;   % '/g/'  gill     *
  
   1   1   0   0   1   0   0   0   1   0   1   0   0   0   0   0   0   0   0 ;   % '/n¬/' ring     *
   
   1   1   0   1   0   0   0   0   1   0   0   0   0   0   0   0   0   0   0 ;   % '/h/'  high     *
   
   1   1   0   1   1   0   1   1   0   0   0   1   1   0   0   0   0   0   0 ;   % '/l/'  leaf     *
   
   1   0   0   1   1   0   1   1   0   0   0   0   0   0   0   0   0   0   0 ;   % '/r/'  reef     *
   
   1   1   0   1   1   0   0   1   0   0   0   0   1   0   0   0   0   0   0 ;   % '/j/'  you      *
   
   1   0   0   1   1   1   0   0   1   0   0   0   0   0   0   0   0   0   0 ;   % '/w/'  witch    *

   
      
   1   0   1   1   1   0   1   0   0   0   0   0   1   1   0   0   0   1   0 ;   % '/i/' beet      *
   
   1   0   1   1   1   0   1   0   0   0   0   0   1   0   1   0   0   1   1 ;   % '/e/' bait      *
   
   1   0   1   1   1   0   0   0   1   0   0   0   0   1   0   0   1   1   1 ;   % '/u/' boot      *
      
   1   0   1   1   1   0   0   0   1   0   0   0   0   0   1   0   1   1   1 ;   % '/o/' boat      *
   
   1   0   1   1   1   0   1   0   0   0   0   0   1   0   0   1   0   0   0 ;   % '/ae/' bat      *
   
   1   0   1   1   1   0   0   0   0   0   0   0   0   0   0   1   0   0   0 ;   % '/^/'  but      *
   
   1   0   1   1   1   0   0   0   0   0   0   0   0   0   0   1   0   0   1 ;   % '/aj/' bite     *
   
   1   0   1   1   1   0   0   0   0   0   0   0   0   0   1   0   1   1   1 ;   % '/oi/' boy
   
   1   0   1   1   1   0   1   0   0   0   0   0   0   0   0   0   0   0   0 ;   % '/I/'  bit      * central changed
   
   1   0   1   1   1   0   1   0   0   0   0   0   0   0   1   0   0   0   0 ;   % '/E/'  bet      *
   
   1   0   1   1   1   0   0   0   1   0   0   0   0   1   1   0   1   0   0 ;   % '/U/' foot      *
   
   1   0   1   1   1   0   0   0   1   0   0   0   0   0   1   0   1   0   0 ;   % '/O/' bought/or *
   
   1   0   1   1   1   0   0   0   1   0   0   0   0   0   0   1   1   0   1 ;   % '/au/' bout/cow *
   
   1   0   1   1   1   0   0   0   0   0   0   0   0   0   0   1   1   0   0;    % '/o-/' dog
 
   1   0   1   1   1   0   0   0   0   0   0   0   0   0   0   1   0   0   0;    % '/a:/' bath

   1   0   1   1   1   0   0   0   0   0   0   0   0   1   0   0   1   1   1;    % '/u8/' tour
   
   1   0   1   1   1   0   0   0   0   0   0   0   0   0   1   0   0   1   1;    % '/E8/' hair

   1   0   1   1   1   0   0   0   0   0   0   0   0   0   1   0   0   0   0     % '/&/'  about

   ];  


% * = these phonemes are the PM 91 phoneme set


% descriptive variables (necessary for the next procedures)
num_consonants=24;
num_vowels=18;
phonemic_code_width=size(Phone_Representations,2);



%save MIG_DATA Phones Phone_Representations num_consonants num_vowels;
%save phonemic_form/MIG_DATA_char Phones num_consonants num_vowels
% 

