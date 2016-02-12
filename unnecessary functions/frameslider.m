% whole is a vector
% framesize is the size of the frame
% number is the sorszam of the fragment we are looking for
% fragment is a subvector of whole, at the number.th position, with length=framesize

function fragment = frameslider(whole, framesize, number)

start = framesize*(number-1) + 1;
ending = start + framesize - 1;
fragment = whole(start:ending);