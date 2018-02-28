#!../../bin/linux-x86_64/ws3122

< envPaths

#epicsEnvSet("EPICS_CAS_INTF_ADDR_LIST" "10.0.7.1")

#epicsEnvSet("STREAM_PROTOCOL_PATH", ".:${TOP}/db")
epicsEnvSet(P, "usbtmc")
epicsEnvSet(R, "icslab")
epicsEnvSet(USBTMCPORT, "usbtmc1")
epicsEnvSet(WS3122PORT, "ws3122" )

cd "${TOP}"

dbLoadDatabase "dbd/ws3122.dbd"
ws3122_registerRecordDeviceDriver pdbbase


# Bus 001 Device 084: ID 05ff:0a21 LeCroy Corp.
epicsEnvSet(vendorNum, "05ff")
epicsEnvSet(productNum, "0a21")


# usbtmcConfigure(port, vendorNum, productNum, serialNumberStr, priority, flags)
usbtmcConfigure("$(USBTMCPORT)", "0x$(vendorNum)", "0x$(productNum)")
drvWS3122Configure("$(WS3122PORT)", "$(USBTMCPORT)")

dbLoadRecords("${TOP}/db/asynRecord.db","P=$(P):, R=$(R):, PORT=$(USBTMCPORT),ADDR=0,OMAX=100,IMAX=100")
dbLoadRecords("${TOP}/db/ws3122.db",    "P=$(P):, R=$(R):, PORT=$(USBTMCPORT),ADDR=0,TIMEOUT=0,NPOINTS=1000")


cd "${TOP}/iocBoot/${IOC}"

iocInit

dbl > "${TOP}/${IOC}_PVs.list"

< asyn_usbtmc.cmd
