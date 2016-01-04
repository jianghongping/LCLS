function [token,filetype]=read_filename(filename,del)
token={0 0};
[token{1},remainder]=strtok(filename,del);
if ~strcmp(token{1},filename)
    [token{2},remainder]=strtok(remainder,del);
end
I=3;
while ~isempty(remainder)
    [token{I},remainder]=strtok(remainder,del);
    I=I+1;
end
[token{I-1},filetype]=strtok(token{I-1},'.');