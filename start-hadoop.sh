
make hadoop r=start s=journal

make hadoop r=start s=master

# make hadoop r=copy s=metadata
#
# make hadoop r=bootstrap s=standby

make hadoop r=start s=standby

make hadoop r=start s=datanode

# make hadoop r=format s=zkfc

make hadoop r=start s=zkfc

make hadoop r=start s=yarn

make hadoop r=start s=yrm

