#!/bin/bash

cd $CATALINA_HOME

# Copy jar file built by component to WEB-INF/lib
for f in ./webapps/ROOT/runtime/component/*; do
    if [[ -d $f ]]; then
        cp -f ./webapps/ROOT/runtime/component/$f/lib/*.jar ./webapps/ROOT/WEB-INF/lib/
    fi
done

# Add RemoteIpValue to tomcat conf 
xmlstarlet ed -L -s "/Server/Service[@name='Catalina']/Engine[@name='Catalina']/Host[@name='localhost']" -t elem -n "ValveTMP" -v "" \
-s "//ValveTMP" -t attr -n "className" -v "org.apache.catalina.valves.RemoteIpValve" \
-s "//ValveTMP" -t attr -n "remoteIpHeader" -v "x-forwarded-for" \
-s "//ValveTMP" -t attr -n "remoteIpProxiesHeader" -v "x-forwarded-by" \
-s "//ValveTMP" -t attr -n "protocolHeader" -v "x-forwarded-proto" \
-r "//ValveTMP" -v Valve \
conf/server.xml

exec "$@"
