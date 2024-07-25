using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.IO.Pipes;
using System.Linq;
using System.Net;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml.Linq;
//i like how people think dragging nyx's api into a .net disassembler makes them think they are a reverse engineer 😱
//open source commented
namespace NyxAPI
{
    internal class Pipe// and no its not 'detected' a lot of people dont understand nyxs pipes are external, not in roblox
    {
        [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Auto)]
        private static extern IntPtr CreateFile(string lpFileName, uint dwDesiredAccess, uint dwShareMode, IntPtr lpSecurityAttributes, uint dwCreationDisposition, uint dwFlagsAndAttributes, IntPtr hTemplateFile);

        [DllImport("kernel32.dll", SetLastError = true)]
        private static extern bool CloseHandle(IntPtr hObject);
    

        private const uint GENERIC_READ = 0x80000000;
        private const uint GENERIC_WRITE = 0x40000000;
        private const uint OPEN_EXISTING = 3;
        private const int INVALID_HANDLE_VALUE = -1;

        public static bool NamedPipeExists(string pipe)//shit didnt really work 💔
        {
            IntPtr handle = CreateFile(
                pipe,
                GENERIC_READ | GENERIC_WRITE,
                0,
                IntPtr.Zero,
                OPEN_EXISTING,
                0,
                IntPtr.Zero);

            if (handle.ToInt64() != INVALID_HANDLE_VALUE)
            {
                CloseHandle(handle);
                return true;
            }
            return false;
        }

        public static void NamedPipeSendData(string script)//will send data to namedpipe
        {
            try
            {
                using (NamedPipeClientStream pipeclient = new NamedPipeClientStream(".", "STOPSKIDDINGMYPIPE", PipeDirection.Out))
                {
                    pipeclient.Connect();

                    using (StreamWriter writer = new StreamWriter(pipeclient))
                    {
                        writer.AutoFlush = true;
                        writer.WriteLine(script);
                    }
                }
            }
            catch (Exception ex)
            {
                Nyx msgbox = new Nyx();
                msgbox.Message(3, "Exception while executing! " + ex.Message.ToString());
                Environment.Exit(-1);
            }
        }

        public string name = @"\\\\.\\pipe\\STOPSKIDDINGMYPIPE";//fluxus name :o
    };

    public class Nyx
    {
        public static string Exploit = "NyxAPI";//exploit name that will show on msg boxs

        [StructLayout(LayoutKind.Sequential)]
        public struct STARTUPINFO
        {
            public uint cb;
            public string lpReserved;
            public string lpDesktop;
            public string lpTitle;
            public uint dwX;
            public uint dwY;
            public uint dwXSize;
            public uint dwYSize;
            public uint dwXCountChars;
            public uint dwYCountChars;
            public uint dwFillAttribute;
            public uint dwFlags;
            public short wShowWindow;
            public short cbReserved2;
            public IntPtr lpReserved2;
            public IntPtr hStdInput;
            public IntPtr hStdOutput;
            public IntPtr hStdError;
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct PROCESS_INFORMATION
        {
            public IntPtr hProcess;
            public IntPtr hThread;
            public uint dwProcessId;
            public uint dwThreadId;
        }

        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool CreateProcess(
            string lpApplicationName,
            string lpCommandLine,
            IntPtr lpProcessAttributes,
            IntPtr lpThreadAttributes,
            bool bInheritHandles,
            uint dwCreationFlags,
            IntPtr lpEnvironment,
            string lpCurrentDirectory,
            ref STARTUPINFO lpStartupInfo,
            out PROCESS_INFORMATION lpProcessInformation);


        static bool IsProcessRunning(string processName) { Process[] processes = Process.GetProcessesByName(processName); return processes.Length > 0; }
        static void CloseProcess(string processName) { Process[] processes = Process.GetProcessesByName(processName); foreach (Process process in processes) { try { process.Kill(); } catch (Exception) { } } }

        static async void NOTRACIST()//nyx likes to hide in the background even after roblox is closed and some people do NOT have brain
        {
            string rbx = "RobloxPlayerBeta";
            string nyx = "nyxbeta";//to kill but its renamed for > 4.0

            while (true)
            {
                if (!IsProcessRunning(rbx))
                {
                    CloseProcess(nyx);
                }

                await Task.Delay(1);//1000 originally 
            }

        }
        
        public void Attach()
        {
            NOTRACIST();//only runs when attached, not on forms load; but i can possibly just make this run when the form initalizes its compotents

            Directory.CreateDirectory("workspace");
            File.WriteAllText("workspace\\DONOTTOUCH.lua", "");//dogSHIT ass method for 3.0 nyx will no longer use this


            if (File.Exists("nyxbeta.exe"))
            {
                if (IsRobloxOpen())
                {
                    if (IsAttached())
                    {
                        Message(2, Exploit + " is already attached");
                    }
                    else
                    {
                        STARTUPINFO si = new STARTUPINFO();
                        si.cb = (uint)Marshal.SizeOf(si);
                        PROCESS_INFORMATION pi = new PROCESS_INFORMATION();

                        try
                        {
                            if (CreateProcess(null, "nyxbeta.exe", IntPtr.Zero, IntPtr.Zero, false, 0, IntPtr.Zero, null, ref si, out pi))
                            {
                                Message(2, "Attach successful");
                            }
                            else
                            {
                                Message(1, ("Exception caught for attaching! " + Marshal.GetLastWin32Error()));
                            }
                        }
                        catch (Exception ex)
                        {
                            Message(1, "Attach(); exception -> " + ex.Message);
                        }
                    }
                }
                else
                {
                    Message(1, "Roblox isnt open");
                }
            }
            else
            {
                Message(3, "Could not find nyxbeta.exe\nDid you turn off antivirus?\n\nIf you are this exploits developer, call Update(); somewhere in your code");
            }
        }

        public void Execute(string source)
        {
            if (File.Exists("nyxbeta.exe"))
            {
                if (IsAttached() == true)//is attached didnt really work as intended it closed the pipes after a while
                {
                    Pipe.NamedPipeSendData(source);
                }
                else
                {
                    Message(2, "Attach to execute scripts");
                }
            }
            else
            {
                Message(3, "Could not find nyxbeta.exe\nScript failed to execute");
            }
        }

        public bool IsAttached()
        {
            if (File.Exists(@"\\.\pipe\STOPSKIDDINGMYPIPE"))//waitnamedpipe DIDNT work (fuck you dllimport)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public void Update()
        {
            WebClient server = new WebClient();

            if (File.Exists("nyxbeta.exe"))
            {
                File.Delete("nyxbeta.exe");
                server.DownloadFile(server.DownloadString("https://raw.githubusercontent.com/speedstarkawaii/nyx/main/nyxbeta.link"), "nyxbeta.exe");

                string ver = server.DownloadString("https://raw.githubusercontent.com/speedstarkawaii/nyx/main/version.doc");
                Message(2, "Updated the API to version " + ver.ToString());
            }
            else
            {
                server.DownloadFile(server.DownloadString("https://raw.githubusercontent.com/speedstarkawaii/nyx/main/nyxbeta.link"), "nyxbeta.exe");
            }
        }

        public bool IsRobloxOpen()
        {
            Process[] rbx = Process.GetProcessesByName("RobloxPlayerBeta");
            return rbx.Length > 0;
        }

        public void Message(int shitcase, string message)//best messagebox ever
        {
            string title = Exploit;
            MessageBoxIcon icon;

            switch (shitcase)
            {
                case 1:
                    icon = MessageBoxIcon.Warning;
                    title = Exploit + " Warning";
                    break;
                case 2:
                    icon = MessageBoxIcon.Information;
                    title = Exploit + " Information";
                    break;
                case 3:
                    icon = MessageBoxIcon.Error;
                    title = Exploit + " Error";
                    break;
                default:
                    icon = MessageBoxIcon.None;
                    title = Exploit + " Message";
                    break;
            }

            MessageBox.Show(message, title, MessageBoxButtons.OK, icon);
        }
    };
}
