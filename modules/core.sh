RUN echo "Setting up warp core..."

# Register bootstrapd as a systemd service
RUN sudo ln -s /usr/core/bootstrapd/bootstrapd.service /lib/systemd/system/bootstrapd.service

RUN mkdir -p /etc/bootstrapd

RUN sudo systemctl enable bootstrapd

RUN echo "Finished setting up warp core"
