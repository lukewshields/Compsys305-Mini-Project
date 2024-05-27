% Read the PNG image
img = imread(['small' ...
    'flappy.png']);

% Normalize each channel to the range of 0 to 15 (4 bits)
img = double(img);
img = img / 255 * 15;

% Split the image into its RGBA components and convert to 4-bit unsigned integers
r = uint8(img(:,:,1));
g = uint8(img(:,:,2));
b = uint8(img(:,:,3));
a = uint8(img(:,:,4));

% Combine the RGBA channels into a single 16-bit value for each pixel
combined_img = bitshift(r, 12) + bitshift(g, 8) + bitshift(b, 4) + a;

% Write data to MIF file
fid = fopen('image_data.mif', 'w');
fprintf(fid, 'DEPTH = %d;\n', size(img, 1) * size(img, 2));
fprintf(fid, 'WIDTH = %d;\n', 16); % 4 bits per channel * 4 channels
fprintf(fid, 'ADDRESS_RADIX = HEX;\n');
fprintf(fid, 'DATA_RADIX = BIN;\n');
fprintf(fid, 'CONTENT\n');
fprintf(fid, 'BEGIN\n');

for i = 1:size(img, 1)
    for j = 1:size(img, 2)
        address = (i - 1) * size(img, 2) + j - 1;
        data = combined_img(i, j);
        fprintf(fid, '%03X : %016s;\n', address, dec2bin(data, 16));
    end
end

fprintf(fid, 'END;\n');
fclose(fid);

disp('MIF file generated successfully.');
