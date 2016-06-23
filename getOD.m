function OD = getOD (frames)

Io = double(squeeze(max(frames)));

OD = log10(Io./squeeze(frames(:,:,:)));

end