function checkInputVowel(vowel)
    if vowel<1 || vowel>9
        Exception = MException('checkInputVowel:vowel', ...
            'Value %d out of range',vowel);
        throw(Exception)
    end
end