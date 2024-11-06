FROM pytorch/pytorch:1.12.0-cuda11.3-cudnn8-runtime
RUN apt update
RUN apt install -y screen
RUN apt install -y build-essential
RUN apt-get -y update
RUN apt-get -y install git
RUN apt-get -y install wget
RUN apt-get -y install libopenmpi-dev
RUN pip install mpi4py
RUN pip install matplotlib
RUN pip install virtualenv
RUN pip install imageio
RUN pip install clean-fid
RUN pip install git+https://github.com/openai/CLIP.git
RUN conda install -c pytorch faiss-gpu cudatoolkit=11.3
RUN pip install blobfile
RUN pip install tenacity
RUN pip install diffusers[pytorch]
RUN pip install transformers[pytorch]
RUN pip install openai
RUN pip install accelerate
RUN pip install wilds
RUN git clone https://github.com/openai/improved-diffusion.git
RUN cd improved-diffusion; pip install -e .

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

COPY . .

RUN chmod +x /app/models/get_models.sh
RUN chmod +x /app/scripts/main_improved_diffusion_cifar10_conditional.sh


# Run the commands for dataset and model preparation
RUN cd data && python get_cifar10.py && cd .. && \
    cd models && ./get_models.sh && cd ..

# Set the default command to run the test script
CMD ["./scripts/main_improved_diffusion_cifar10_conditional.sh"]