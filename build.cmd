del /Q .\jbx.exe
del /Q hello.java
nim c -d:ssl -d:release jbx.nim
.\jbx.exe
del /Q hello.java