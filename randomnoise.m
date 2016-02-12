% random number in the range of [-abs, +abs], uniform distribution
function error = randomnoise(abs, meret)

if abs == 0
    error = zeros(meret);
else
    error = -abs + 2*abs .* rand(meret);
end

   