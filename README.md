# InlineASMPoSh

This is just my attempts so far at getting inline assembly to run in PowerShell. Somewhere, the program fails because maybe it doen't properly indicate where the assembly bytes are located?

I haven't delved too deep into this, but the overall idea is pretty simple. Write some C# code that writes bytes to a specific place in memory and execute the defined file that PowerShell generates.
