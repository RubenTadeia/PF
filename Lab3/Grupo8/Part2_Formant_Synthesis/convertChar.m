function vowel = convertChar(vowel)
    if ischar(vowel)
        switch vowel
            case 'a'
                vowel = 1;
            case 'E'
                vowel = 2;
            case 'i'
                vowel = 3;
            case 'O'
                vowel = 4;
            case 'u'
                vowel = 5;
            case '6'
                vowel = 6;
            case 'e'
                vowel = 7;
            case 'o'
                vowel = 8;
            case '@'
                vowel = 9;
            otherwise
                Exception = MException('convertChar:vowel', ...
                'Value %s not a vowel {a, E, i, O, u, 6, e, o, @}',vowel);
                throw(Exception)
        end
    end
end