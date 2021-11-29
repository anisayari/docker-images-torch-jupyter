FROM nvcr.io/nvidia/pytorch:20.12-py3

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install imageio-ffmpeg==0.4.3 pyspng==0.1.0

RUN pip install jupyterlab==2.2.9 ipywidgets==7.6.3
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter nbextension enable --py widgetsnbextension #enable ipywidgets
RUN jupyter labextension install jupyterlab-plotly@4.14.3

EXPOSE 8080

ADD start.sh /

WORKDIR /workspace
RUN chown -R 42420:42420 /workspace

# Unset TORCH_CUDA_ARCH_LIST and exec.  This makes pytorch run-time
# extension builds significantly faster as we only compile for the
# currently active GPU configuration.
RUN (printf '#!/bin/bash\nunset TORCH_CUDA_ARCH_LIST\nexec \"$@\"\n' >> /entry.sh) && chmod a+x /entry.sh

ENTRYPOINT ["/start.sh"]