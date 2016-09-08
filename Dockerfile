# chekote/ubuntu:yakkety
FROM ubuntu:yakkety

# Fix 'setlocale: LC_ALL: cannot change local (en_US.UTF-8)'
RUN locale-gen en_US.UTF-8	

