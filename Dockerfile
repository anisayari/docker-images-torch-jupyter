FROM nvcr.io/nvidia/pytorch:20.12-py3

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install imageio-ffmpeg==0.4.3 pyspng==0.1.0

WORKDIR /workspace

# Unset TORCH_CUDA_ARCH_LIST and exec.  This makes pytorch run-time
# extension builds significantly faster as we only compile for the
# currently active GPU configuration.
RUN (printf '#!/bin/bash\nunset TORCH_CUDA_ARCH_LIST\nexec \"$@\"\n' >> /entry.sh) && chmod a+x /entry.sh

# Expose Jupyter port & cmd
EXPOSE 8888
RUN mkdir -p /opt/app/data
FROM python:3.7

WORKDIR /workspace
RUN chown -R 42420:42420 /workspace


RUN pip install jupyter -U && pip install jupyterlab
EXPOSE 8888

RUN set -eu
CMD jupyter lab --ip=0.0.0.0 --port=8080 --no-browser --allow-root \
--LabApp.token='' \
  --LabApp.custom_display_url=${JOB_URL_SCHEME}${JOB_ID}.${JOB_HOST} \
  --LabApp.allow_remote_access=True \
  --LabApp.allow_origin='*' \
  --LabApp.disable_check_xsrf=True
