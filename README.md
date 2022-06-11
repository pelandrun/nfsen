# nfsen#**Another nfsen container** 

ubuntu 22.04

nfsen-1.3.7 (you can try 1.3.8 if you dare)

apache2

# Install
```
git clone https://github.com/pelandrun/nfsen
```
#build image
```
cd nfsen

docker image build  -t local/nfsen .
```
# Start container 
```
docker compose up -d
```
then excecute conntrack -D -p udp
```
conntrack -D -p udp
```
#Why conntrack -D -p udp

If you don't, you might see all netflow/ipfix/sflow container traffic coming from the docker network gateway. Why this happened is a mystery.
for me. my best guess is:

1 As soon as you configure your netflow exporters, netflow traffic will start reaching the docker host.

2 While the containers are being instantiated and the ports are exposed, the connection table on the docker host is populated with srcnat.

3 When the compose ends it's already too late, the damage is already done.

Also described [here](https://github.com/moby/moby/issues/8795)

If you know of a better solution, please share.

#Caveat
When the server is running, any modifications to the nfset.conf file must be done after the container is stopped or removed.
like this:

```
docker compose down 
```
edit nfsen.conf
```
docker compose up -d
```
