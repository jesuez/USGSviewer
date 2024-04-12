FROM node:18-bookworm

# set working directory
WORKDIR /vue

# add `/vue/node_modules/.bin` to $PATH
ENV PATH /vue/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package.json /vue/package.json
RUN npm install
RUN npm install @vue/cli@3.7.0 -g
EXPOSE 8080
# start app
#CMD ["npm", "run", "serve"]

