if not exist "build" (
    md "build\debug"
)
if not exist "build\debug" (
    md "build\debug"
)
nim c -r -o:build\debug\arena src\main.nim
