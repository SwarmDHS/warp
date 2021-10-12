RUN echo "Setting up warp core..."

# Copy core software and services
RUN cp /usr/core/bootstrapd/bootstrapd.service /lib/systemd/system

RUN echo "Finished setting up warp core"
