$CP = New-Object System.CodeDom.Compiler.CompilerParameters
$CP.ReferencedAssemblies.Add('System.dll')
$CP.CompilerOptions = '/unsafe /target:exe /platform:x86'
$CP.OutputAssembly = 'test.exe'

Add-Type -TypeDefinition @'
using System;
using System.IO;
using System.ComponentModel;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Security;

public class Dummy
{
    [SuppressUnmanagedCodeSecurity]
    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate int AssemblyAddFunction(int x, int y);
    
    [DllImport("kernel32.dll")]
    private static extern bool VirtualProtectEx(IntPtr hProcess, IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint lpflOldProtect);
    
    public static void Main()
    {
        byte[] assembledCode =
        {
            0x55,               // 0 push ebp            
            0x8B, 0x45, 0x08,   // 1 mov  eax, [ebp+8]   
            0x8B, 0x55, 0x0C,   // 4 mov  edx, [ebp+12]  
            0x01, 0xD0,         // 7 add  eax, edx       
            0x5D,               // 9 pop  ebp            
            0xC3                // A ret                 
        };

        uint _;

        int returnValue;
        unsafe
        {
            fixed (byte* ptr = assembledCode)
            {
                var memoryAddress = (IntPtr) ptr;

                // Mark memory as EXECUTE_READWRITE to prevent DEP exceptions
                if (!VirtualProtectEx(Process.GetCurrentProcess().Handle, memoryAddress, (UIntPtr) assembledCode.Length, 0x40, out _))
                {
                    throw new Win32Exception();
                }

                AssemblyAddFunction myAssemblyFunction = (AssemblyAddFunction)Marshal.GetDelegateForFunctionPointer(memoryAddress, typeof(AssemblyAddFunction));
                returnValue = myAssemblyFunction(10, -15);
            }               
        }

        Console.WriteLine(returnValue);
    }
}
'@ -CompilerParameters $CP
