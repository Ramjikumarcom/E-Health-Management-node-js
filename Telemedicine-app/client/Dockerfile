FROM node:19-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

# Set the API base URL environment variable
ENV REACT_APP_API_BASE_URL=http://backend:5000

# Build the application
RUN npm run build

# Install serve to run the application
RUN npm install -g serve

EXPOSE 3000

CMD ["serve", "-s", "build", "-l", "3000"]
