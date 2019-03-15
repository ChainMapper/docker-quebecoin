FROM chainmapper/walletbase-xenial-build as builder

ENV GIT_COIN_URL    https://github.com/ChainMapper/QBC.git
ENV GIT_COIN_NAME   quebecoin   

RUN	git clone $GIT_COIN_URL $GIT_COIN_NAME \
	&& cd $GIT_COIN_NAME \
	&& git checkout 0.8.6.2 \
	&& chmod +x share/genbuild.sh \
	&& cd src \
	&& mkdir obj/support \
	&& mkdir obj/crypto \
	&& make -f makefile.unix "USE_UPNP=-" \
	&& cp quebecoind /usr/local/bin

FROM chainmapper/walletbase-xenial as runtime

COPY --from=builder /usr/local/bin /usr/local/bin

RUN mkdir /data
ENV HOME /data

#zmq port, rpc port & main port
EXPOSE 5555 6666 4334

COPY start.sh /start.sh
COPY gen_config.sh /gen_config.sh
COPY wallet.sh /wallet.sh
RUN chmod 777 /*.sh
CMD /start.sh quebecoin.conf QBC quebecoind