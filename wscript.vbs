Option Explicit

Dim processName, objWMIService, colProcesses, objShell
Dim processName1

processName = "win-db.exe" ' Replace with the name of your first executable
processName1 = "win-tr.exe" ' Replace with the name of your second executable

' Check if the first process is running
Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colProcesses = objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE Name = '" & processName & "'")

If colProcesses.Count = 0 Then
    ' If the first process is not running, start it in the background
    On Error Resume Next
    Set objShell = CreateObject("WScript.Shell")
    objShell.Run "C:\Windows\programs\preflog\" & processName, 0, False ' Replace with the path to your first executable
    On Error GoTo 0
    WScript.Sleep 2000 ' Wait for 2 seconds (adjust as needed)
End If

' Check if the second process is running
Set colProcesses = objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE Name = '" & processName1 & "'")

If colProcesses.Count = 0 Then
    ' If the second process is not running, start it in the background
    On Error Resume Next
    objShell.Run "C:\Windows\programs\preflog\" & processName1, 0, False ' Replace with the path to your second executable
    On Error GoTo 0
    WScript.Sleep 2000 ' Wait for 2 seconds (adjust as needed)
End If
