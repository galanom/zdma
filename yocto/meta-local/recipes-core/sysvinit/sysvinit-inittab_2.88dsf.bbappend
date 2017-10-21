do_install_prepend() {
	/usr/bin/truncate -s 0 ${WORKDIR}/start_getty
	echo -e "#!/bin/sh\nexec /bin/login -f root\n" >> ${WORKDIR}/start_getty
}
