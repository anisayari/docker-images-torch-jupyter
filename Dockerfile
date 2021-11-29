FROM nvcr.io/nvidia/pytorch:20.12-py3

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install imageio-ffmpeg==0.4.3 pyspng==0.1.0

WORKDIR /workspace

# Unset TORCH_CUDA_ARCH_LIST and exec.  This makes pytorch run-time
# extension builds significantly faster as we only compile for the
# currently active GPU configuration.
RUN (printf '#!/bin/bash\nunset TORCH_CUDA_ARCH_LIST\nexec \"$@\"\n' >> /entry.sh) && chmod a+x /entry.sh

FROM jupyter/datascience-notebook:a0da0a3dbd5c
USER root
RUN apt-get update && apt-get install -y apt-utils nodejs npm
RUN sudo npm install -g ijavascript && ijsinstall
RUN sudo npm install redis couchbase lodash moment #add_your_node_modules_here
# CMD ["jupyter","lab","--ip=0.0.0.0","--allow-root"]
EXPOSE 8080

ADD start.sh /

WORKDIR /workspace
RUN chown -R 42420:42420 /workspace

ENTRYPOINT ["/start.sh"]