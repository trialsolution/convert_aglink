SET PATH=%PATH%;./jars
"C:\Program Files\Java\jre8\bin\java" -Xverify:none -XX:+UseParallelGC -XX:PermSize=20M -XX:MaxNewSize=32M -XX:NewSize=32M -Djava.library.path=jars  -jar jars\gig.jar caprinew.ini caprinew_default.xml
