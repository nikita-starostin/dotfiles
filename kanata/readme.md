kanata.exe - kanata executable
kanata.kbd - lisp configuration for kanata

kanata could be run right from console
kanata could not be installed via winsw, because it required some permissions that are not provided for windows services

to run kanata at background on windows need to install that with "Windows Scheduler Task"
  the action should be configured like the next:
    program C:\Windows\System32\conhost.exe
    args    --headless "D:\actual_programs\xdg_config\nvim\kanata\kanata.exe" --cfg "D:\actual_programs\xdg_config\nvim\kanata\kanata.kbd"
  put hidden checkbox on general tab to true, so it would be run in background without showing the window

to stop kanata press: <lctrl>+<space>+<esc>
