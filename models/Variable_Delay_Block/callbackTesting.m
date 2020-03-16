%callback init test
maxDelay = 2^4;
RAM_SIZE = ceil(log2(maxDelay));

(sprintf("Variable Delay Block\nDelay Signal Width: %d\nRAM Size (Max Delay): %d", RAM_SIZE, 2^RAM_SIZE)) 
