#!/bin/bash

export OMADA_USER=omada
/opt/tplink/EAPController/jre/bin/java -server -Xms128m -Xmx1024m -XX:MaxHeapFreeRatio=60 -XX:MinHeapFreeRatio=30 -XX:+HeapDumpOnOutOfMemoryError -XX:-UsePerfData -Deap.home=/opt/tplink/EAPController -cp /opt/tplink/EAPController/lib/*: com.tp_link.eap.start.EapLinuxMain
