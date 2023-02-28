FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:latest

WORKDIR /app

# copy current directory to app dir 
COPY . .

# output file location
RUN mkdir /out
ENV STORAGE_PREFIX unknown_invocation

ENTRYPOINT /app/simple.sh
