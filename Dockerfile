FROM ubi8/ubi-minimal AS build
LABEL maintainer "Chris Collins <collins.christopher@gmail.com"

ENV client "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip"
ENV signature "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip.sig"
ENV zipfile "awscliv2.zip"
ENV sigfile "awscliv2.sig"

ENV required_packages "unzip gnupg less"

RUN microdnf install ${required_packages} \
      && microdnf clean all \
      && rm -rf /var/cache/yum

# REF: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#v2-install-validate-linux
COPY aws.gpg /opt/aws.gpg

RUN gpg --import /opt/aws.gpg

RUN curl "${client}" -o ${zipfile} \
      && curl "${signature}" -o ${sigfile} \
      && gpg --verify ${sigfile} ${zipfile} \
      && unzip ${zipfile} -d /opt \
      && rm -rf ${sigfile} ${zipfile}

RUN /opt/aws/install

# Check install
RUN ln -s /opt/aws/aws2 --version

ENTRYPOINT ["/usr/local/bin/aws2"]
CMD ["--version"]

