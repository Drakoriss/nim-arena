if not exist "build" (
    md "build\release"
)
if not exist "build\release" (
    md "build\release"
)
nim c -r -d:release -o:build\release\arena src\main.nim
