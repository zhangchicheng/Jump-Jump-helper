function piece = findPiece(image)
r = image(:, :, 1);
g = image(:, :, 2);
b = image(:, :, 3);
[i, j] = find((r == 53) .* (g == 51) .* (b == 90));
px = max(j);
py = max(i);
piece = [px, py];
end