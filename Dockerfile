FROM nvcr.io/nvidia/pytorch:20.12-py3

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install imageio-ffmpeg==0.4.3 pyspng==0.1.0

WORKDIR /workspace

# Unset TORCH_CUDA_ARCH_LIST and exec.  This makes pytorch run-time
# extension builds significantly faster as we only compile for the
# currently active GPU configuration.
RUN (printf '#!/bin/bash\nunset TORCH_CUDA_ARCH_LIST\nexec \"$@\"\n' >> /entry.sh) && chmod a+x /entry.sh
ENTRYPOINT ["/entry.sh"]