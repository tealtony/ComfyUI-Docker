# For build automation - Allows building from any ai-dock base image
# Use a *cuda*base* image as default because pytorch brings the libs
FROM ghcr.io/ai-dock/pytorch:2.0.1-py3.10-cuda-11.8.0-base-22.04

LABEL org.opencontainers.image.source https://github.com/ai-dock/comfyui
LABEL org.opencontainers.image.description "ComfyUI Stable Diffusion backend and GUI"
LABEL maintainer="Tony Bissell <tony@tealrobot.com>"

# Copy early so we can use scripts in the build - Changes to these files will invalidate the cache and cause a rebuild.
WORKDIR /app

RUN git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
    https://github.com/comfyanonymous/ComfyUI.git .

# ComfyUI Manager
# RUN cd /app/ComfyUI/custom_nodes && \
#     git clone --depth=1 --no-tags --recurse-submodules --shallow-submodules \
#         https://github.com/ltdrdata/ComfyUI-Manager.git

# Install Comfy UI requirements
RUN pip install --no-cache-dir \
    -r requirements.txt \
    --index-url https://download.pytorch.org/whl/cu121 \
    --extra-index-url https://pypi.org/simple


# Install the requirements.txt for each custom_nodes folder if it exists
# for each folder in ../workspace/custom_nodes
#RUN for d in ../workspace/custom_nodes/*/; do echo "Installing requirements for $d"; if [ -f "$d/requirements.txt" ]; then echo "Requirements file found, installing" && pip install -r $d/requirements.txt; fi; done
#RUN for d in /workspace/custom_nodes/*/; do echo $d; done

#RUN ls -la  && pip install -r requirements.txt

COPY scripts/entrypoint.sh ./entrypoint.sh

CMD ["bash", "entrypoint.sh"]