# InlineASMPoSh

This is just my attempts so far at getting inline assembly to run in PowerShell. Somewhere, the program fails because maybe it doen't properly indicate where the assembly bytes are located?

I haven't delved too deep into this, but the overall idea is pretty simple. Write some C# code that writes bytes to a specific place in memory and execute the defined file that PowerShell generates.

# Update from 24 Jan 2023
It does work now, it just needs to be run in the 32 bit version of powershell since the target platform is x86 otherwise you'll get a huge number in the return.
