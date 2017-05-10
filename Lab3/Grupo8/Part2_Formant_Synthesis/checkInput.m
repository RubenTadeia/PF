function checkInput(f0, duration)
    if f0<0
        Exception = MException('checkInput:f0', ...
            'Value %d must be positive',f0);
        throw(Exception)
    elseif duration<0
        Exception = MException('checkInput:duration', ...
            'Value %d must be positive',duration);
        throw(Exception)
    end
end
