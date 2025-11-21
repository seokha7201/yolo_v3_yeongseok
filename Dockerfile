FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    git wget build-essential pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Darknet 클론
RUN git clone https://github.com/pjreddie/darknet.git /darknet
WORKDIR /darknet

# CPU 빌드 설정 (GPU=0)
RUN sed -i 's/GPU=1/GPU=0/' Makefile || true && \
    sed -i 's/CUDNN=1/CUDNN=0/' Makefile || true && \
    sed -i 's/OPENCV=1/OPENCV=0/' Makefile || true

# 빌드
RUN make -j"$(nproc)"

# 가중치 다운로드
RUN wget https://pjreddie.com/media/files/yolov3.weights

# 실행 스크립트 생성
RUN echo '#!/bin/bash\n\
if [ $# -ne 1 ]; then\n\
  echo "Usage: /run_yolo.sh <image_url>"\n\
  exit 1\n\
fi\n\
URL="$1"\n\
wget -O input.jpg "$URL"\n\
cd /darknet\n\
./darknet detector test cfg/coco.data cfg/yolov3.cfg yolov3.weights input.jpg -dont_show\n' \
> /run_yolo.sh && chmod +x /run_yolo.sh

ENTRYPOINT ["/run_yolo.sh"]
