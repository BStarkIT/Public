var wshShell = new ActiveXObject("WScript.Shell");
wshShell.Run('%SystemRoot%\\system32\\WindowsPowerShell\\v1.0\\powershell.exe -ExecutionPolicy Bypass -File "C:\\PS\\Devops\\Tray.ps1"', 0, false);