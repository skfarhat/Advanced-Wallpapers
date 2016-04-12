
tell application "System Events"
    tell current desktop
        
        -- (0=off, 1=interval, 2=login, 3=sleep)
        %@ set picture rotation to %@
        
        -- true, false
        %@ set random order to %@
        
        -- "Mac OS X:Library:Desktop Pictures:Plants:"
        %@ set pictures folder to "%@"
        
        -- intreval in seconds
        %@ set change interval to %@ -- seconds
        
    end tell
end tell
